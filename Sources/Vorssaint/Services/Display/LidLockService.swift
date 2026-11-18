// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2026 Vorssaint

import AppKit
import CoreGraphics
import IOKit
import os

/// Watches lid transitions (`AppleClamshellState` on `IOPMrootDomain`) when
/// enabled and locks the screen if the MacBook lid closes while an external
/// HDMI display (or any external display when configured) is connected.
final class LidLockService {
    static let shared = LidLockService()

    private static let log = Logger(subsystem: "com.vorssaint.app", category: "LidLock")

    private var notificationPort: IONotificationPortRef?
    private var notification: io_object_t = 0
    private var lastLidClosed: Bool?

    private init() {}

    deinit {
        teardownObserver()
    }

    /// True on Macs that expose a lid sensor (`AppleClamshellState`).
    static var isSupported: Bool {
        BrightnessService.lidClosed() != nil
    }

    func syncWithPreferences() {
        let enabled = UserDefaults.standard.bool(forKey: DefaultsKey.lidLockEnabled)
        guard enabled, Self.isSupported else {
            teardownObserver()
            return
        }
        armObserver()
    }

    private func armObserver() {
        guard notificationPort == nil else { return }
        let root = IOServiceGetMatchingService(kIOMainPortDefault, IOServiceMatching("IOPMrootDomain"))
        guard root != 0 else { return }
        defer { IOObjectRelease(root) }

        guard let port = IONotificationPortCreate(kIOMainPortDefault) else { return }
        var notifier: io_object_t = 0
        let result = IOServiceAddInterestNotification(
            port,
            root,
            kIOGeneralInterest,
            { context, _, _, _ in
                guard let context else { return }
                let service = Unmanaged<LidLockService>.fromOpaque(context).takeUnretainedValue()
                DispatchQueue.main.async { [weak service] in
                    service?.lidStateMayHaveChanged()
                }
            },
            Unmanaged.passUnretained(self).toOpaque(),
            &notifier
        )
        guard result == KERN_SUCCESS else {
            IONotificationPortDestroy(port)
            return
        }

        notification = notifier
        notificationPort = port
        IONotificationPortSetDispatchQueue(port, DispatchQueue.main)
        lastLidClosed = BrightnessService.lidClosed()
    }

    private func teardownObserver() {
        if notification != 0 {
            IOObjectRelease(notification)
            notification = 0
        }
        if let port = notificationPort {
            IONotificationPortDestroy(port)
            notificationPort = nil
        }
        lastLidClosed = nil
    }

    private func lidStateMayHaveChanged() {
        let enabled = UserDefaults.standard.bool(forKey: DefaultsKey.lidLockEnabled)
        guard enabled else {
            teardownObserver()
            return
        }

        guard let currentClosed = BrightnessService.lidClosed() else { return }
        let previousClosed = lastLidClosed
        lastLidClosed = currentClosed

        let includeNonHDMI = UserDefaults.standard.bool(forKey: DefaultsKey.lidLockIncludeNonHDMI)
        let hasExternal = Self.hasMatchingExternalDisplay(includeNonHDMI: includeNonHDMI)
        let action = LidLockSupport.evaluateLidTransition(
            enabled: enabled,
            previousLidClosed: previousClosed,
            currentLidClosed: currentClosed,
            hasMatchingExternalDisplay: hasExternal
        )

        if action == .lockScreen {
            Self.log.log("lid closed with external display connected; locking screen")
            Self.lockScreen()
        }
    }

    // MARK: - External / HDMI display detection

    static func hasMatchingExternalDisplay(includeNonHDMI: Bool) -> Bool {
        var count: UInt32 = 0
        guard CGGetOnlineDisplayList(0, nil, &count) == .success, count > 0 else { return false }
        var ids = [CGDirectDisplayID](repeating: 0, count: Int(count))
        guard CGGetOnlineDisplayList(count, &ids, &count) == .success else { return false }

        let externalIDs = ids.prefix(Int(count)).filter { CGDisplayIsBuiltin($0) == 0 }
        guard !externalIDs.isEmpty else { return false }
        if includeNonHDMI { return true }

        return hasHDMIInIORegistry()
    }

    private static func hasHDMIInIORegistry() -> Bool {
        let root = IORegistryGetRootEntry(kIOMainPortDefault)
        guard root != 0 else { return false }
        defer { IOObjectRelease(root) }

        var iterator = io_iterator_t()
        guard IORegistryEntryCreateIterator(
            root,
            kIOServicePlane,
            IOOptionBits(kIORegistryIterateRecursively),
            &iterator
        ) == KERN_SUCCESS else { return false }
        defer { IOObjectRelease(iterator) }

        var currentExternalFramebuffer = false
        while true {
            let entry = IOIteratorNext(iterator)
            guard entry != IO_OBJECT_NULL else { break }
            defer { IOObjectRelease(entry) }

            var nameBuffer = [CChar](repeating: 0, count: 128)
            guard IORegistryEntryGetName(entry, &nameBuffer) == KERN_SUCCESS else { continue }
            let name = String(cString: nameBuffer)

            if name.contains("AppleCLCD2") || name.contains("IOMobileFramebufferShim") {
                let isExternal = (registryProperty(entry, "External") as? Bool) ?? false
                currentExternalFramebuffer = isExternal
                if isExternal, entryHasHDMITransport(entry) {
                    return true
                }
            } else if name == "DCPAVServiceProxy" {
                let location = registryProperty(entry, "Location") as? String
                if location == "External" || currentExternalFramebuffer, entryHasHDMITransport(entry) {
                    return true
                }
            } else if name == "IODisplayConnect" || name.contains("IOFramebuffer") {
                if entryHasHDMITransport(entry) {
                    return true
                }
            }
        }
        return false
    }

    private static func entryHasHDMITransport(_ entry: io_registry_entry_t) -> Bool {
        if let transport = registryProperty(entry, "Transport") {
            if let str = transport as? String, LidLockSupport.isHDMITransport(str) {
                return true
            }
            if let dict = transport as? NSDictionary {
                for (_, value) in dict {
                    if let str = value as? String, LidLockSupport.isHDMITransport(str) {
                        return true
                    }
                }
            }
        }
        for key in ["DisplayTransportType", "ConnectorType", "PortType", "Downstream"] {
            if let str = registryProperty(entry, key) as? String, LidLockSupport.isHDMITransport(str) {
                return true
            }
        }
        if let connectorData = registryProperty(entry, "AAPL,connector-type") as? Data,
           LidLockSupport.isHDMIConnectorType(connectorData) {
            return true
        }
        return false
    }

    private static func registryProperty(_ entry: io_registry_entry_t, _ key: String) -> AnyObject? {
        IORegistryEntryCreateCFProperty(entry, key as CFString, kCFAllocatorDefault, 0)?.takeRetainedValue()
    }

    // MARK: - Lock screen

    private static func lockScreen() {
        if let lock = lockScreenFunction {
            _ = lock()
        } else {
            let url = URL(fileURLWithPath: "/System/Library/CoreServices/ScreenSaverEngine.app")
            NSWorkspace.shared.openApplication(at: url, configuration: NSWorkspace.OpenConfiguration())
        }
    }

    private static let lockScreenFunction: (@convention(c) () -> Int32)? = {
        let path = "/System/Library/PrivateFrameworks/login.framework/login"
        guard let handle = dlopen(path, RTLD_LAZY),
              let symbol = dlsym(handle, "SACLockScreenImmediate") else { return nil }
        return unsafeBitCast(symbol, to: (@convention(c) () -> Int32).self)
    }()
}

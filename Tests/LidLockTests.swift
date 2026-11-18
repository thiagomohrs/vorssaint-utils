// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2026 Vorssaint

import Foundation

/// Unit tests for `LidLockSupport` pure transition and HDMI matching logic.
enum LidLockTests {
    static func run(expect: (Bool, String) -> Void) {
        // 1) Rising edge (false -> true) when enabled and HDMI connected
        expect(
            LidLockSupport.evaluateLidTransition(
                enabled: true,
                previousLidClosed: false,
                currentLidClosed: true,
                hasMatchingExternalDisplay: true
            ) == .lockScreen,
            "evaluateLidTransition locks on open->closed when enabled with matching display"
        )

        // 2) Disabled -> .none
        expect(
            LidLockSupport.evaluateLidTransition(
                enabled: false,
                previousLidClosed: false,
                currentLidClosed: true,
                hasMatchingExternalDisplay: true
            ) == .none,
            "evaluateLidTransition does not lock when disabled"
        )

        // 3) No matching external display -> .none
        expect(
            LidLockSupport.evaluateLidTransition(
                enabled: true,
                previousLidClosed: false,
                currentLidClosed: true,
                hasMatchingExternalDisplay: false
            ) == .none,
            "evaluateLidTransition does not lock without matching external display"
        )

        // 4) Already closed on arming (previousLidClosed == nil) -> .none
        expect(
            LidLockSupport.evaluateLidTransition(
                enabled: true,
                previousLidClosed: nil,
                currentLidClosed: true,
                hasMatchingExternalDisplay: true
            ) == .none,
            "evaluateLidTransition does not lock when armed while lid is already closed"
        )

        // 5) Repeated notifications while closed (true -> true) -> .none
        expect(
            LidLockSupport.evaluateLidTransition(
                enabled: true,
                previousLidClosed: true,
                currentLidClosed: true,
                hasMatchingExternalDisplay: true
            ) == .none,
            "evaluateLidTransition does not re-lock on repeated closed notifications"
        )

        // 6) Lid opens (true -> false) -> .none
        expect(
            LidLockSupport.evaluateLidTransition(
                enabled: true,
                previousLidClosed: true,
                currentLidClosed: false,
                hasMatchingExternalDisplay: true
            ) == .none,
            "evaluateLidTransition does not lock when lid opens"
        )

        // 7) Transport string detection
        expect(LidLockSupport.isHDMITransport("HDMI"), "isHDMITransport matches HDMI")
        expect(LidLockSupport.isHDMITransport("hdmi-1"), "isHDMITransport matches lowercase hdmi-1")
        expect(LidLockSupport.isHDMITransport("TMDS"), "isHDMITransport matches TMDS")
        expect(!LidLockSupport.isHDMITransport(nil), "isHDMITransport rejects nil")
        expect(!LidLockSupport.isHDMITransport(""), "isHDMITransport rejects empty string")
        expect(!LidLockSupport.isHDMITransport("DisplayPort"), "isHDMITransport rejects DisplayPort")
        expect(!LidLockSupport.isHDMITransport("Embedded"), "isHDMITransport rejects Embedded")

        // 8) Connector type data (0x00000800 little-endian)
        let hdmiConnector = Data([0x00, 0x08, 0x00, 0x00])
        let dpConnector = Data([0x00, 0x04, 0x00, 0x00])
        let shortData = Data([0x00, 0x08])
        expect(LidLockSupport.isHDMIConnectorType(hdmiConnector), "isHDMIConnectorType matches 0x00000800")
        expect(!LidLockSupport.isHDMIConnectorType(dpConnector), "isHDMIConnectorType rejects 0x00000400")
        expect(!LidLockSupport.isHDMIConnectorType(shortData), "isHDMIConnectorType rejects < 4 bytes")
        expect(!LidLockSupport.isHDMIConnectorType(nil), "isHDMIConnectorType rejects nil")

        // 9) External display descriptor filtering
        let builtInOnly = [LidLockSupport.ExternalDisplayDescriptor(isBuiltIn: true, isHDMI: false)]
        let builtInPlusDP = [
            LidLockSupport.ExternalDisplayDescriptor(isBuiltIn: true, isHDMI: false),
            LidLockSupport.ExternalDisplayDescriptor(isBuiltIn: false, isHDMI: false)
        ]
        let builtInPlusHDMI = [
            LidLockSupport.ExternalDisplayDescriptor(isBuiltIn: true, isHDMI: false),
            LidLockSupport.ExternalDisplayDescriptor(isBuiltIn: false, isHDMI: true)
        ]

        expect(!LidLockSupport.hasMatchingExternalDisplay(displays: builtInOnly, includeNonHDMI: false),
               "built-in only does not match (HDMI only)")
        expect(!LidLockSupport.hasMatchingExternalDisplay(displays: builtInOnly, includeNonHDMI: true),
               "built-in only does not match (includeNonHDMI)")
        expect(!LidLockSupport.hasMatchingExternalDisplay(displays: builtInPlusDP, includeNonHDMI: false),
               "DisplayPort external does not match when includeNonHDMI is false")
        expect(LidLockSupport.hasMatchingExternalDisplay(displays: builtInPlusDP, includeNonHDMI: true),
               "DisplayPort external matches when includeNonHDMI is true")
        expect(LidLockSupport.hasMatchingExternalDisplay(displays: builtInPlusHDMI, includeNonHDMI: false),
               "HDMI external matches when includeNonHDMI is false")
        expect(LidLockSupport.hasMatchingExternalDisplay(displays: builtInPlusHDMI, includeNonHDMI: true),
               "HDMI external matches when includeNonHDMI is true")
    }
}

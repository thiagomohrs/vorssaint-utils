// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2026 Vorssaint

import Foundation

/// Pure decision logic for locking the screen when the lid closes while an
/// external display is connected. `LidLockService` is the only caller and
/// performs the actual screen-lock side effect.
enum LidLockSupport {
    enum Action: Equatable {
        case lockScreen
        case none
    }

    /// Minimal view of an external display needed for matching.
    struct ExternalDisplayDescriptor: Equatable {
        let isBuiltIn: Bool
        let isHDMI: Bool
    }

    /// Returns `.lockScreen` only on the rising edge of lid-closed (open ->
    /// closed) when the feature is enabled and a matching external display is
    /// present; every other combination yields `.none`.
    static func evaluateLidTransition(
        enabled: Bool,
        previousLidClosed: Bool?,
        currentLidClosed: Bool,
        hasMatchingExternalDisplay: Bool
    ) -> Action {
        guard enabled,
              hasMatchingExternalDisplay,
              previousLidClosed == false,
              currentLidClosed
        else { return .none }
        return .lockScreen
    }

    /// Case-insensitive check whether a transport string names HDMI or its
    /// legacy TMDS alias. Returns false for nil, empty, or DisplayPort-only
    /// strings.
    static func isHDMITransport(_ value: String?) -> Bool {
        guard let value, !value.isEmpty else { return false }
        let lower = value.lowercased()
        return lower.contains("hdmi") || lower.contains("tmds")
    }

    /// Returns true when `data` carries at least four bytes whose
    /// little-endian UInt32 equals 0x00000800 (the IOKit HDMI connector
    /// type constant).
    static func isHDMIConnectorType(_ data: Data?) -> Bool {
        guard let data, data.count >= 4 else { return false }
        let bytes = [UInt8](data.prefix(4))
        let value: UInt32 = UInt32(bytes[0])
            | (UInt32(bytes[1]) << 8)
            | (UInt32(bytes[2]) << 16)
            | (UInt32(bytes[3]) << 24)
        return value == 0x0000_0800
    }

    /// True when at least one non-built-in display satisfies the HDMI filter
    /// (or the filter is bypassed via `includeNonHDMI`).
    static func hasMatchingExternalDisplay(
        displays: [ExternalDisplayDescriptor],
        includeNonHDMI: Bool
    ) -> Bool {
        displays.contains { !$0.isBuiltIn && (includeNonHDMI || $0.isHDMI) }
    }
}

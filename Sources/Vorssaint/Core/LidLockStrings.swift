// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2026 Vorssaint

import Foundation

/// Strings for the lid-lock feature. Same contract as the other
/// FeatureStrings structs: memberwise init with labeled arguments in
/// declaration order, one static per language, all in this file.
struct LidLockStrings {
    let pageTitle: String
    let enable: String
    let enableCaption: String
    let includeNonHDMI: String
    let includeNonHDMICaption: String
    let unsupported: String
}

extension FeatureStrings {
    static func lidLock(_ language: AppLanguage) -> LidLockStrings {
        switch language {
        case .enUS: return .enUS
        case .ptBR: return .ptBR
        case .tr: return .tr
        case .ru: return .ru
        case .es: return .es
        case .sk: return .sk
        case .de: return .de
        case .fr: return .fr
        case .it: return .it
        case .ja: return .ja
        case .ko: return .ko
        case .zhHans: return .zhHans
        case .zhTW: return .zhTW
        case .zhHK: return .zhHK
        case .uk: return .uk
        }
    }
}

extension LidLockStrings {
    static let enUS = LidLockStrings(
        pageTitle: "Lock screen on lid close",
        enable: "Lock screen when closing lid on HDMI",
        enableCaption: "Automatically locks the Mac when you close the lid while connected to an external HDMI display.",
        includeNonHDMI: "Also lock for other external displays",
        includeNonHDMICaption: "Includes DisplayPort and USB-C monitors, useful if an HDMI adapter reports as DisplayPort.",
        unsupported: "This Mac has no built-in lid sensor."
    )

    static let ptBR = LidLockStrings(
        pageTitle: "Bloquear tela ao fechar a tampa",
        enable: "Bloquear tela ao fechar a tampa com HDMI",
        enableCaption: "Bloqueia o Mac automaticamente ao fechar a tampa enquanto estiver conectado a um monitor externo via HDMI.",
        includeNonHDMI: "Também bloquear com outros monitores externos",
        includeNonHDMICaption: "Inclui monitores DisplayPort e USB-C, útil se um adaptador HDMI for reconhecido como DisplayPort.",
        unsupported: "Este Mac não possui sensor de tampa integrado."
    )

    static let tr = LidLockStrings(
        pageTitle: "Kapak kapatıldığında ekran kilidi",
        enable: "HDMI bağlıyken kapak kapatılınca ekran kilidi",
        enableCaption: "Dış bir HDMI ekrana bağlıyken kapağı kapattığınızda Mac’i otomatik olarak kilitle.",
        includeNonHDMI: "Diğer dış ekranlar için de kilitle",
        includeNonHDMICaption: "DisplayPort ve USB-C monitörleri de kapsar; bir HDMI adaptörü DisplayPort olarak algılanırsa işe yarar.",
        unsupported: "Bu Mac’te yerleşik kapak sensörü yok."
    )

    static let ru = LidLockStrings(
        pageTitle: "Блокировка экрана при закрытии крышки",
        enable: "Блокировать экран при закрытии крышки с HDMI",
        enableCaption: "Автоматически блокирует Mac при закрытии крышки, если подключён внешний HDMI-дисплей.",
        includeNonHDMI: "Также блокировать для других внешних дисплеев",
        includeNonHDMICaption: "Включает мониторы DisplayPort и USB-C, полезно, если HDMI-адаптер определяется как DisplayPort.",
        unsupported: "На этом Mac нет встроенного датчика крышки."
    )

    static let es = LidLockStrings(
        pageTitle: "Bloqueo de pantalla al cerrar la tapa",
        enable: "Bloquear pantalla al cerrar la tapa con HDMI",
        enableCaption: "Bloquea el Mac automáticamente al cerrar la tapa mientras esté conectado a un monitor externo HDMI.",
        includeNonHDMI: "También bloquear con otros monitores externos",
        includeNonHDMICaption: "Incluye monitores DisplayPort y USB-C, útil si un adaptador HDMI se detecta como DisplayPort.",
        unsupported: "Este Mac no tiene sensor de tapa integrado."
    )

    static let sk = LidLockStrings(
        pageTitle: "Zámok obrazovky pri zatvorení krytu",
        enable: "Zamknúť obrazovku pri zatvorení krytu s HDMI",
        enableCaption: "Automaticky zamkne Mac pri zatvorení krytu, keď je pripojený externý HDMI monitor.",
        includeNonHDMI: "Zamknúť aj pre iné externé monitory",
        includeNonHDMICaption: "Zahŕňa monitory DisplayPort a USB-C, užitočné, ak sa HDMI adaptér zobrazí ako DisplayPort.",
        unsupported: "Tento Mac nemá zabudovaný senzor krytu."
    )

    static let de = LidLockStrings(
        pageTitle: "Bildschirmsperre beim Zuklappen",
        enable: "Bildschirmsperre beim Zuklappen mit HDMI",
        enableCaption: "Sperren den Mac automatisch, wenn der Deckel bei einem angeschlossenen externen HDMI-Display geschlossen wird.",
        includeNonHDMI: "Auch für andere externe Displays sperren",
        includeNonHDMICaption: "Umfasst DisplayPort- und USB-C-Monitore, nützlich, wenn ein HDMI-Adapter als DisplayPort erkannt wird.",
        unsupported: "Dieser Mac hat keinen eingebauten Deckelsensor."
    )

    static let fr = LidLockStrings(
        pageTitle: "Verrouillage à la fermeture du couvercle",
        enable: "Verrouiller l’écran en fermant le couvercle avec HDMI",
        enableCaption: "Verrouille le Mac automatiquement à la fermeture du couvercle lorsqu’il est connecté à un écran HDMI externe.",
        includeNonHDMI: "Verrouiller aussi pour d’autres écrans externes",
        includeNonHDMICaption: "Inclut les moniteurs DisplayPort et USB-C, utile si un adaptateur HDMI est détecté comme DisplayPort.",
        unsupported: "Ce Mac ne dispose pas de capteur de couvercle intégré."
    )

    static let it = LidLockStrings(
        pageTitle: "Blocco schermo in chiusura coperchio",
        enable: "Blocca lo schermo in chiusura coperchio con HDMI",
        enableCaption: "Blocca automaticamente il Mac quando si chiude il coperchio mentre è collegato a un monitor HDMI esterno.",
        includeNonHDMI: "Blocca anche per altri monitor esterni",
        includeNonHDMICaption: "Include monitor DisplayPort e USB-C, utile se un adattatore HDMI viene rilevato come DisplayPort.",
        unsupported: "Questo Mac non ha un sensore del coperchio integrato."
    )

    static let ja = LidLockStrings(
        pageTitle: "蓋を閉じたときの画面ロック",
        enable: "HDMI接続時に蓋を閉じたら画面をロック",
        enableCaption: "外部HDMIディスプレイに接続中に蓋を閉じると、Macが自動的にロックされます。",
        includeNonHDMI: "他の外部ディスプレイでもロックする",
        includeNonHDMICaption: "DisplayPortおよびUSB-Cモニターも対象。HDMIアダプタがDisplayPortとして認識される場合に便利です。",
        unsupported: "このMacには内蔵の蓋センサーがありません。"
    )

    static let ko = LidLockStrings(
        pageTitle: "뚜껑 닫을 때 화면 잠금",
        enable: "HDMI 연결 시 뚜껑 닫으면 화면 잠금",
        enableCaption: "외부 HDMI 디스플레이에 연결된 상태에서 뚜껑을 닫으면 Mac이 자동으로 잠깁니다.",
        includeNonHDMI: "다른 외부 디스플레이에서도 잠금",
        includeNonHDMICaption: "DisplayPort 및 USB-C 모니터도 포함. HDMI 어댑터가 DisplayPort로 인식되는 경우 유용합니다.",
        unsupported: "이 Mac에는 내장 뚜껑 센서가 없습니다."
    )

    static let zhHans = LidLockStrings(
        pageTitle: "合盖时锁定屏幕",
        enable: "连接 HDMI 时合盖锁定屏幕",
        enableCaption: "连接外部 HDMI 显示器时合盖，自动锁定 Mac。",
        includeNonHDMI: "其他外部显示器也锁定",
        includeNonHDMICaption: "包含 DisplayPort 和 USB-C 显示器，适用于 HDMI 转接头被识别为 DisplayPort 的情况。",
        unsupported: "这台 Mac 没有内置合盖传感器。"
    )

    static let zhTW = LidLockStrings(
        pageTitle: "合蓋時鎖定螢幕",
        enable: "連接 HDMI 時合蓋鎖定螢幕",
        enableCaption: "連接外部 HDMI 顯示器時合蓋，自動鎖定 Mac。",
        includeNonHDMI: "其他外部顯示器也鎖定",
        includeNonHDMICaption: "包含 DisplayPort 和 USB-C 顯示器，適用於 HDMI 轉接頭被識別為 DisplayPort 的情況。",
        unsupported: "這台 Mac 沒有內建合蓋感測器。"
    )

    static let zhHK = LidLockStrings(
        pageTitle: "合蓋時鎖定螢幕",
        enable: "接 HDMI 時合蓋鎖定螢幕",
        enableCaption: "接住外部 HDMI 顯示器時合蓋，自動鎖定 Mac。",
        includeNonHDMI: "其他外部顯示器都鎖定",
        includeNonHDMICaption: "包括 DisplayPort 同 USB-C 顯示器，HDMI 轉接頭被認做 DisplayPort 嗰陣有用。",
        unsupported: "呢部 Mac 冇內建合蓋感測器。"
    )

    static let uk = LidLockStrings(
        pageTitle: "Блокування екрана при закритті кришки",
        enable: "Блокувати екран при закритті кришки з HDMI",
        enableCaption: "Автоматично блокує Mac при закритті кришки, якщо підключено зовнішній HDMI-монітор.",
        includeNonHDMI: "Також блокувати для інших зовнішніх моніторів",
        includeNonHDMICaption: "Включає монітори DisplayPort та USB-C, корисно, якщо HDMI-адаптер визначається як DisplayPort.",
        unsupported: "На цьому Mac немає вбудованого датчика кришки."
    )
}

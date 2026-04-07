import SwiftUI

enum AppTheme: String, CaseIterable, Identifiable {
    case system, light, dark
    var id: Self { self }

    var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light:  return .light
        case .dark:   return .dark
        }
    }

    var label: LocalizedStringKey {
        switch self {
        case .system: return "settings.themeSystem"
        case .light:  return "settings.themeLight"
        case .dark:   return "settings.themeDark"
        }
    }
}

enum AppLanguage: String, CaseIterable, Identifiable {
    case system = ""
    case en, ru, kk
    var id: Self { self }

    var label: LocalizedStringKey {
        switch self {
        case .system: return "settings.languageSystem"
        case .en:     return "settings.languageEnglish"
        case .ru:     return "settings.languageRussian"
        case .kk:     return "settings.languageKazakh"
        }
    }

    var locale: Locale? {
        rawValue.isEmpty ? nil : Locale(identifier: rawValue)
    }
}

@MainActor
final class AppPreferences: ObservableObject {
    @AppStorage("appTheme")    private var themeRaw: String = AppTheme.system.rawValue
    @AppStorage("appLanguage") private var langRaw:  String = AppLanguage.system.rawValue

    var theme: AppTheme {
        get { AppTheme(rawValue: themeRaw) ?? .system }
        set { themeRaw = newValue.rawValue; objectWillChange.send() }
    }

    var language: AppLanguage {
        get { AppLanguage(rawValue: langRaw) ?? .system }
        set { langRaw = newValue.rawValue; objectWillChange.send() }
    }
}

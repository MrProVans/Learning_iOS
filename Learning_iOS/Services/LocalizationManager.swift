import Foundation
import Combine

enum AppLanguage: String, CaseIterable, Identifiable {
    case en
    case ru

    var id: String { rawValue }

    var titleKey: String {
        switch self {
        case .en: return "language_english"
        case .ru: return "language_russian"
        }
    }
}

final class LocalizationManager: ObservableObject {
    static let shared = LocalizationManager()

    @Published var currentLanguage: AppLanguage {
        didSet {
            UserDefaults.standard.set(currentLanguage.rawValue, forKey: languageKey)
        }
    }

    private let languageKey = "app_language"

    private init() {
        if let stored = UserDefaults.standard.string(forKey: languageKey), let language = AppLanguage(rawValue: stored) {
            currentLanguage = language
        } else {
            let prefersRussian = Locale.preferredLanguages.first?.lowercased().hasPrefix("ru") ?? false
            currentLanguage = prefersRussian ? .ru : .en
        }
    }

    func localized(_ key: String) -> String {
        let bundle = localizedBundle(for: currentLanguage)
        return NSLocalizedString(key, tableName: "Localizable", bundle: bundle, value: key, comment: "")
    }

    private func localizedBundle(for language: AppLanguage) -> Bundle {
        guard
            let path = Bundle.main.path(forResource: language.rawValue, ofType: "lproj"),
            let bundle = Bundle(path: path)
        else {
            return .main
        }
        return bundle
    }
}

func L(_ key: String) -> String {
    LocalizationManager.shared.localized(key)
}

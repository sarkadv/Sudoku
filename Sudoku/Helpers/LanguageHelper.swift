import SwiftUI

class LanguageHelper {
    public static func languageToLocale(language: Language) -> Locale {
        switch language {
        case .english:
            return Locale(identifier: "en")
        case .czech:
            return Locale(identifier: "cs")
        }
    }
}


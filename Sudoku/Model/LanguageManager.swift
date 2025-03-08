import SwiftUI

/// správa jazyka aplikace
class LanguageManager: ObservableObject {
    /// jazyk aplikace
    @Published var locale: Locale
    
    init () {
        let language: Language = StorageManager.getLanguage()
        self.locale = LanguageHelper.languageToLocale(language: language)
    }
    
    
    /// Nastaví jazyk aplikace a uloží hodnotu do perzistentního úložiště.
    /// - Parameter language: jazyk aplikace
    public func setLocale(language: Language) -> Void {
        StorageManager.setLanguage(language: language)
        self.locale = LanguageHelper.languageToLocale(language: language)
    }
}


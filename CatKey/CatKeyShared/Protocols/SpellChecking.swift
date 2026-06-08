import Foundation

protocol SpellChecking {
    func isWordCorrect(_ word: String, language: AppConstants.Language) -> Bool
    func suggestions(for word: String, language: AppConstants.Language, maxResults: Int) -> [String]
}

protocol Autocompleting {
    func predictions(for prefix: String, previousWords: [String], language: AppConstants.Language) -> [String]
}

protocol LanguageDetecting {
    func detectLanguage(for word: String, previousWords: [String]) -> AppConstants.Language
}

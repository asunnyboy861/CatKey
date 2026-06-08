import Foundation

class AutocorrectEngine {
    private let spellChecker: SpellChecker
    
    init(spellChecker: SpellChecker) {
        self.spellChecker = spellChecker
    }
    
    func autocorrect(word: String, language: AppConstants.Language) -> String? {
        guard UserDefaults.appGroup.autocorrectEnabled else { return nil }
        guard !spellChecker.isWordCorrect(word, language: language) else { return nil }
        
        let suggestions = spellChecker.suggestions(for: word, language: language, maxResults: 1)
        guard let correction = suggestions.first else { return nil }
        
        let distance = word.lowercased().levenshteinDistance(to: correction)
        let isPremium = UserDefaults.appGroup.isPremium
        let maxDistance = isPremium ? 2 : 1
        
        guard distance <= maxDistance else { return nil }
        guard distance <= word.count / 2 + 1 else { return nil }
        
        return correction
    }
}

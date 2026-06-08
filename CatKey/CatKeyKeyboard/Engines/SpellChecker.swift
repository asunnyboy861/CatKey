import Foundation

class SpellChecker: SpellChecking {
    private let dictionaryManager = DictionaryManager.shared
    private let maxEditDistance: Int
    
    init(maxEditDistance: Int = 2) {
        self.maxEditDistance = maxEditDistance
    }
    
    func isWordCorrect(_ word: String, language: AppConstants.Language) -> Bool {
        guard !word.isEmpty else { return true }
        if word.count == 1 && word.isWordBoundary { return true }
        return dictionaryManager.isWordInDictionary(word, language: language)
    }
    
    func suggestions(for word: String, language: AppConstants.Language, maxResults: Int = 3) -> [String] {
        guard !word.isEmpty else { return [] }
        
        if isWordCorrect(word, language: language) { return [] }
        
        let isPremium = UserDefaults.appGroup.isPremium
        let effectiveMaxDistance = isPremium ? maxEditDistance : 1
        
        var candidates: [(word: String, distance: Int, frequency: Int)] = []
        let allWords = dictionaryManager.allWords(language: language)
        
        for candidate in allWords {
            let distance = word.lowercased().levenshteinDistance(to: candidate)
            if distance <= effectiveMaxDistance && distance > 0 {
                let freq = dictionaryManager.frequency(for: candidate, language: language)
                candidates.append((candidate, distance, freq))
            }
        }
        
        candidates.sort { a, b in
            if a.distance != b.distance { return a.distance < b.distance }
            return a.frequency > b.frequency
        }
        
        return Array(candidates.prefix(maxResults)).map { $0.word }
    }
}

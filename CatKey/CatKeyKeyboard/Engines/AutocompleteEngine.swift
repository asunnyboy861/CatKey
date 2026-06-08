import Foundation

class AutocompleteEngine: Autocompleting {
    private let dictionaryManager = DictionaryManager.shared
    
    func predictions(for prefix: String, previousWords: [String], language: AppConstants.Language) -> [String] {
        guard prefix.count >= AppConstants.Keyboard.minPredictionPrefix else { return [] }
        
        let isPremium = UserDefaults.appGroup.isPremium
        let maxResults = isPremium ? AppConstants.Keyboard.maxSuggestions : 3
        
        let matchingWords = dictionaryManager.wordsWithPrefix(prefix, language: language)
        
        var scored: [(word: String, score: Double)] = []
        for word in matchingWords {
            let freq = dictionaryManager.frequency(for: word, language: language)
            let prefixScore = Double(prefix.count) / Double(word.count)
            let freqScore = min(Double(freq) / 1000.0, 1.0)
            let totalScore = prefixScore * 0.4 + freqScore * 0.6
            scored.append((word, totalScore))
        }
        
        scored.sort { $0.score > $1.score }
        
        return Array(scored.prefix(maxResults)).map { $0.word }
    }
}

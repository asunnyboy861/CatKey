import Foundation

class LanguageDetector: LanguageDetecting {
    func detectLanguage(for word: String, previousWords: [String]) -> AppConstants.Language {
        if word.isCatalanMarker { return .catalan }
        if word.isSpanishMarker { return .spanish }
        
        let dictManager = DictionaryManager.shared
        let inCatalan = dictManager.isWordInDictionary(word, language: .catalan)
        let inSpanish = dictManager.isWordInDictionary(word, language: .spanish)
        
        if inCatalan && !inSpanish { return .catalan }
        if inSpanish && !inCatalan { return .spanish }
        
        if !UserDefaults.appGroup.bilingualModeEnabled {
            return AppConstants.Language(rawValue: UserDefaults.appGroup.activeLanguage) ?? .catalan
        }
        
        if let lastWord = previousWords.last {
            if lastWord.isCatalanMarker { return .catalan }
            if lastWord.isSpanishMarker { return .spanish }
        }
        
        let catalanFreq = dictManager.frequency(for: word, language: .catalan)
        let spanishFreq = dictManager.frequency(for: word, language: .spanish)
        if catalanFreq > spanishFreq { return .catalan }
        if spanishFreq > catalanFreq { return .spanish }
        
        return .catalan
    }
}

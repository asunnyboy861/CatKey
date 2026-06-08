import Foundation

class DictionaryManager {
    static let shared = DictionaryManager()
    
    private var catalanWords: Set<String> = []
    private var spanishWords: Set<String> = []
    private var catalanFrequency: [String: Int] = [:]
    private var spanishFrequency: [String: Int] = [:]
    private var userWords: Set<String> = []
    
    private init() {
        loadDictionaries()
        loadUserDictionary()
    }
    
    private func loadDictionaries() {
        catalanWords = loadWordSet(from: "ca_ES")
        spanishWords = loadWordSet(from: "es_ES")
        catalanFrequency = loadFrequency(from: "ca_ES_freq")
        spanishFrequency = loadFrequency(from: "es_ES_freq")
    }
    
    private func loadWordSet(from filename: String) -> Set<String> {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "txt") else {
            return buildWordSetFromDic(filename)
        }
        guard let content = try? String(contentsOf: url, encoding: .utf8) else { return [] }
        return Set(content.components(separatedBy: .newlines).filter { !$0.isEmpty && $0.count > 1 })
    }
    
    private func buildWordSetFromDic(_ filename: String) -> Set<String> {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "dic") else { return [] }
        guard let content = try? String(contentsOf: url, encoding: .utf8) else { return [] }
        let lines = content.components(separatedBy: .newlines)
        var words = Set<String>()
        for line in lines.dropFirst() {
            let word = line.split(separator: "/").first.map(String.init) ?? ""
            if word.count > 1 { words.insert(word.lowercased()) }
        }
        return words
    }
    
    private func loadFrequency(from filename: String) -> [String: Int] {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "txt") else { return [:] }
        guard let content = try? String(contentsOf: url, encoding: .utf8) else { return [:] }
        var freq: [String: Int] = [:]
        for line in content.components(separatedBy: .newlines) {
            let parts = line.split(separator: " ")
            guard parts.count >= 2, let count = Int(parts[1]) else { continue }
            freq[String(parts[0]).lowercased()] = count
        }
        return freq
    }
    
    private func loadUserDictionary() {
        let defaults = UserDefaults.appGroup
        let saved = defaults.stringArray(forKey: "userDictionaryWords") ?? []
        userWords = Set(saved.map { $0.lowercased() })
    }
    
    func saveUserDictionary() {
        let defaults = UserDefaults.appGroup
        defaults.set(Array(userWords), forKey: "userDictionaryWords")
    }
    
    func addWord(_ word: String, language: AppConstants.Language) {
        userWords.insert(word.lowercased())
        saveUserDictionary()
    }
    
    func removeWord(_ word: String) {
        userWords.remove(word.lowercased())
        saveUserDictionary()
    }
    
    func userWordList() -> [String] {
        return Array(userWords).sorted()
    }
    
    func isWordInDictionary(_ word: String, language: AppConstants.Language) -> Bool {
        let lower = word.lowercased()
        if userWords.contains(lower) { return true }
        switch language {
        case .catalan: return catalanWords.contains(lower)
        case .spanish: return spanishWords.contains(lower)
        case .english: return spanishWords.contains(lower) || catalanWords.contains(lower)
        }
    }
    
    func frequency(for word: String, language: AppConstants.Language) -> Int {
        let lower = word.lowercased()
        switch language {
        case .catalan: return catalanFrequency[lower] ?? 0
        case .spanish: return spanishFrequency[lower] ?? 0
        case .english: return max(catalanFrequency[lower] ?? 0, spanishFrequency[lower] ?? 0)
        }
    }
    
    func allWords(language: AppConstants.Language) -> Set<String> {
        switch language {
        case .catalan: return catalanWords.union(userWords)
        case .spanish: return spanishWords.union(userWords)
        case .english: return catalanWords.union(spanishWords).union(userWords)
        }
    }
    
    func wordsWithPrefix(_ prefix: String, language: AppConstants.Language) -> [String] {
        let lower = prefix.lowercased()
        let words = allWords(language: language)
        return words.filter { $0.hasPrefix(lower) }
    }
}

import SwiftUI

struct CustomDictionaryView: View {
    @AppStorage("isPremium") private var isPremium = false
    @State private var words: [String] = []
    @State private var newWord = ""
    @State private var selectedLanguage: AppConstants.Language = .catalan
    
    var body: some View {
        Group {
            if isPremium {
                dictionaryContent
            } else {
                paywallContent
            }
        }
        .navigationTitle("Custom Dictionary")
        .onAppear { loadWords() }
    }
    
    private var dictionaryContent: some View {
        List {
            Section {
                HStack {
                    TextField("Add a word...", text: $newWord)
                        .textInputAutocapitalization(.none)
                        .autocorrectionDisabled()
                    
                    Picker("", selection: $selectedLanguage) {
                        ForEach(AppConstants.Language.allCases, id: \.self) { lang in
                            Text(lang.displayName).tag(lang)
                        }
                    }
                    .labelsHidden()
                    
                    Button(action: addWord) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundStyle(Color(red: 0.18, green: 0.49, blue: 0.82))
                    }
                    .disabled(newWord.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            
            Section("Your Words") {
                if words.isEmpty {
                    Text("No custom words yet")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(words, id: \.self) { word in
                        Text(word)
                    }
                    .onDelete(perform: deleteWord)
                }
            }
        }
    }
    
    private var paywallContent: some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: "lock.fill")
                .font(.system(size: 48))
                .foregroundStyle(Color(red: 0.85, green: 0.65, blue: 0.13))
            Text("Pro Feature")
                .font(.title2.bold())
            Text("Custom Dictionary is available with CatKey Pro")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            NavigationLink(destination: PremiumView()) {
                Text("Upgrade to Pro")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color(red: 0.18, green: 0.49, blue: 0.82))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(.horizontal, 32)
            Spacer()
        }
    }
    
    private func loadWords() {
        words = UserDefaults.appGroup.stringArray(forKey: "userDictionaryWords") ?? []
    }
    
    private func addWord() {
        let trimmed = newWord.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        var words = UserDefaults.appGroup.stringArray(forKey: "userDictionaryWords") ?? []
        if !words.contains(trimmed.lowercased()) {
            words.append(trimmed.lowercased())
            UserDefaults.appGroup.set(words, forKey: "userDictionaryWords")
        }
        newWord = ""
        loadWords()
    }
    
    private func deleteWord(at offsets: IndexSet) {
        var savedWords = UserDefaults.appGroup.stringArray(forKey: "userDictionaryWords") ?? []
        let wordsToRemove = offsets.map { words[$0] }
        savedWords.removeAll { word in wordsToRemove.contains(word) }
        UserDefaults.appGroup.set(savedWords, forKey: "userDictionaryWords")
        loadWords()
    }
}

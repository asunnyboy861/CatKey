import SwiftUI

struct KeyboardTheme {
    let background: Color
    let keyBackground: Color
    let keyForeground: Color
    let specialKeyBackground: Color
    let specialKeyForeground: Color
    let suggestionBackground: Color
    let suggestionForeground: Color
    let border: Color
    
    static func current() -> KeyboardTheme {
        let themeRaw = UserDefaults.appGroup.theme
        let theme = AppConstants.Theme(rawValue: themeRaw) ?? .system
        let isPro = UserDefaults.appGroup.isPremium
        let effectiveTheme: AppConstants.Theme
        if theme.isPro && !isPro {
            effectiveTheme = .system
        } else {
            effectiveTheme = theme
        }
        
        switch effectiveTheme {
        case .system:
            return KeyboardTheme(
                background: Color(UIColor.systemGray6),
                keyBackground: Color.white,
                keyForeground: Color.black,
                specialKeyBackground: Color(UIColor.systemGray3),
                specialKeyForeground: Color.darkGray,
                suggestionBackground: Color.white,
                suggestionForeground: Color(UIColor.darkText),
                border: Color(UIColor.systemGray4)
            )
        case .light:
            return KeyboardTheme(
                background: Color(UIColor.systemGray6),
                keyBackground: Color.white,
                keyForeground: Color.black,
                specialKeyBackground: Color(UIColor.systemGray3),
                specialKeyForeground: Color.darkGray,
                suggestionBackground: Color.white,
                suggestionForeground: Color(UIColor.darkText),
                border: Color(UIColor.systemGray4)
            )
        case .dark:
            return KeyboardTheme(
                background: Color(UIColor.systemGray),
                keyBackground: Color(UIColor.systemGray2),
                keyForeground: Color.white,
                specialKeyBackground: Color(UIColor.systemGray3),
                specialKeyForeground: Color.white,
                suggestionBackground: Color(UIColor.systemGray2),
                suggestionForeground: Color.white,
                border: Color(UIColor.systemGray4)
            )
        case .modernisme:
            return KeyboardTheme(
                background: Color(red: 0.18, green: 0.49, blue: 0.82),
                keyBackground: Color.white.opacity(0.95),
                keyForeground: Color(red: 0.18, green: 0.49, blue: 0.82),
                specialKeyBackground: Color(red: 0.85, green: 0.65, blue: 0.13),
                specialKeyForeground: Color.white,
                suggestionBackground: Color.white.opacity(0.9),
                suggestionForeground: Color(red: 0.18, green: 0.49, blue: 0.82),
                border: Color(red: 0.85, green: 0.65, blue: 0.13)
            )
        case .mediterranean:
            return KeyboardTheme(
                background: Color(red: 0.0, green: 0.48, blue: 0.65),
                keyBackground: Color.white.opacity(0.95),
                keyForeground: Color(red: 0.0, green: 0.32, blue: 0.48),
                specialKeyBackground: Color(red: 0.0, green: 0.75, blue: 0.85),
                specialKeyForeground: Color.white,
                suggestionBackground: Color.white.opacity(0.9),
                suggestionForeground: Color(red: 0.0, green: 0.32, blue: 0.48),
                border: Color(red: 0.0, green: 0.75, blue: 0.85)
            )
        case .trencadis:
            return KeyboardTheme(
                background: Color(red: 0.95, green: 0.90, blue: 0.80),
                keyBackground: Color.white,
                keyForeground: Color(red: 0.55, green: 0.27, blue: 0.07),
                specialKeyBackground: Color(red: 0.55, green: 0.27, blue: 0.07),
                specialKeyForeground: Color.white,
                suggestionBackground: Color.white,
                suggestionForeground: Color(red: 0.55, green: 0.27, blue: 0.07),
                border: Color(red: 0.55, green: 0.27, blue: 0.07).opacity(0.3)
            )
        }
    }
}

enum KeyboardState {
    case letters
    case numbers
    case symbols
}

struct CatKeyKeyboardView: View {
    let proxy: UITextDocumentProxy?
    let onSwitchKeyboard: () -> Void
    
    @State private var keyboardState: KeyboardState = .letters
    @State private var shiftEnabled = false
    @State private var capsLock = false
    @State private var currentWord = ""
    @State private var previousWords: [String] = []
    @State private var suggestions: [String] = []
    @State private var detectedLanguage: AppConstants.Language = .catalan
    @State private var autocorrectReplacement: (original: String, replacement: String)? = nil
    
    private let spellChecker = SpellChecker()
    private let autocompleteEngine = AutocompleteEngine()
    private let autocorrectEngine: AutocorrectEngine
    private let languageDetector = LanguageDetector()
    private let theme = KeyboardTheme.current()
    
    private let keyHeight: CGFloat = 42
    private let keySpacing: CGFloat = 5
    private let topPadding: CGFloat = 6
    
    init(proxy: UITextDocumentProxy?, onSwitchKeyboard: @escaping () -> Void) {
        self.proxy = proxy
        self.onSwitchKeyboard = onSwitchKeyboard
        self.autocorrectEngine = AutocorrectEngine(spellChecker: spellChecker)
    }
    
    var body: some View {
        VStack(spacing: 4) {
            suggestionBar
            keyboardContent
        }
        .padding(.horizontal, 4)
        .padding(.vertical, 2)
        .background(theme.background)
    }
    
    private var suggestionBar: some View {
        HStack(spacing: 0) {
            ForEach(suggestions.prefix(3), id: \.self) { suggestion in
                Button(action: { insertSuggestion(suggestion) }) {
                    Text(suggestion)
                        .font(.system(size: 16))
                        .foregroundStyle(theme.suggestionForeground)
                        .frame(maxWidth: .infinity)
                        .frame(height: AppConstants.Keyboard.predictionBarHeight - 8)
                        .background(theme.suggestionBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                }
            }
            if suggestions.isEmpty {
                Spacer()
            }
        }
        .frame(height: AppConstants.Keyboard.predictionBarHeight)
    }
    
    private var keyboardContent: some View {
        VStack(spacing: keySpacing) {
            switch keyboardState {
            case .letters: letterRows
            case .numbers: numberRows
            case .symbols: symbolRows
            }
        }
    }
    
    private var letterRows: some View {
        VStack(spacing: keySpacing) {
            keyRow(["q","w","e","r","t","y","u","i","o","p"], widthMultiplier: 1.0)
            keyRow(["a","s","d","f","g","h","j","k","l"], widthMultiplier: 1.05)
            HStack(spacing: keySpacing) {
                shiftKey
                keyRow(["z","x","c","v","b","n","m"], widthMultiplier: 1.05, inHStack: false)
                deleteKey
            }
            bottomRow
        }
    }
    
    private var numberRows: some View {
        VStack(spacing: keySpacing) {
            keyRow(["1","2","3","4","5","6","7","8","9","0"], widthMultiplier: 1.0)
            keyRow(["-","/",":",";","(",")","€","&","@","\""], widthMultiplier: 1.0)
            HStack(spacing: keySpacing) {
                symbolSwitchKey
                keyRow([".",",","?","!","'"], widthMultiplier: 1.1, inHStack: false)
                deleteKey
            }
            bottomRow
        }
    }
    
    private var symbolRows: some View {
        VStack(spacing: keySpacing) {
            keyRow(["[","]","{","}","#","%","^","*","+","="], widthMultiplier: 1.0)
            keyRow(["_","\\","|","~","<",">","$","£","¥","·"], widthMultiplier: 1.0)
            HStack(spacing: keySpacing) {
                numberSwitchKey
                keyRow([".",",","?","!","'"], widthMultiplier: 1.1, inHStack: false)
                deleteKey
            }
            bottomRow
        }
    }
    
    private var bottomRow: some View {
        HStack(spacing: keySpacing) {
            globeKey
            spaceKey
            returnKey
        }
    }
    
    private func keyRow(_ keys: [String], widthMultiplier: CGFloat = 1.0, inHStack: Bool = true) -> some View {
        HStack(spacing: keySpacing) {
            ForEach(keys, id: \.self) { key in
                characterKey(key, widthMultiplier: widthMultiplier)
            }
        }
    }
    
    private func characterKey(_ character: String, widthMultiplier: CGFloat = 1.0) -> some View {
        let displayChar = (shiftEnabled || capsLock) && character.count == 1 && character.allSatisfy({ $0.isLetter }) ? character.uppercased() : character
        
        return LongPressKey(
            character: displayChar,
            alternates: alternates(for: character),
            theme: theme,
            keyHeight: keyHeight,
            widthMultiplier: widthMultiplier,
            onTap: { handleKeyPress(displayChar) },
            onAlternateSelect: { handleKeyPress($0) }
        )
    }
    
    private var shiftKey: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.1)) {
                if capsLock {
                    capsLock = false
                    shiftEnabled = false
                } else if shiftEnabled {
                    capsLock = true
                } else {
                    shiftEnabled = true
                }
            }
        }) {
            Image(systemName: shiftEnabled ? (capsLock ? "capslock.fill" : "shift.fill") : "shift")
                .font(.system(size: 18))
                .foregroundStyle(theme.specialKeyForeground)
                .frame(width: 52, height: keyHeight)
                .background(theme.specialKeyBackground)
                .clipShape(RoundedRectangle(cornerRadius: 5))
        }
    }
    
    private var deleteKey: some View {
        Button(action: handleDelete) {
            Image(systemName: "delete.left")
                .font(.system(size: 18))
                .foregroundStyle(theme.specialKeyForeground)
                .frame(width: 52, height: keyHeight)
                .background(theme.specialKeyBackground)
                .clipShape(RoundedRectangle(cornerRadius: 5))
        }
    }
    
    private var globeKey: some View {
        Button(action: onSwitchKeyboard) {
            Image(systemName: "globe")
                .font(.system(size: 18))
                .foregroundStyle(theme.specialKeyForeground)
                .frame(width: 44, height: keyHeight)
                .background(theme.specialKeyBackground)
                .clipShape(RoundedRectangle(cornerRadius: 5))
        }
    }
    
    private var spaceKey: some View {
        Button(action: handleSpace) {
            Text(detectedLanguage.spaceBarLabel)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(theme.specialKeyForeground)
                .frame(maxWidth: .infinity)
                .frame(height: keyHeight)
                .background(theme.specialKeyBackground)
                .clipShape(RoundedRectangle(cornerRadius: 5))
        }
    }
    
    private var returnKey: some View {
        Button(action: handleReturn) {
            Image(systemName: "return")
                .font(.system(size: 18))
                .foregroundStyle(theme.specialKeyForeground)
                .frame(width: 60, height: keyHeight)
                .background(theme.specialKeyBackground)
                .clipShape(RoundedRectangle(cornerRadius: 5))
        }
    }
    
    private var symbolSwitchKey: some View {
        Button(action: { keyboardState = .symbols }) {
            Text("#+=")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(theme.specialKeyForeground)
                .frame(width: 52, height: keyHeight)
                .background(theme.specialKeyBackground)
                .clipShape(RoundedRectangle(cornerRadius: 5))
        }
    }
    
    private var numberSwitchKey: some View {
        Button(action: { keyboardState = .numbers }) {
            Text("123")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(theme.specialKeyForeground)
                .frame(width: 52, height: keyHeight)
                .background(theme.specialKeyBackground)
                .clipShape(RoundedRectangle(cornerRadius: 5))
        }
    }
    
    private func alternates(for key: String) -> [String] {
        switch key.lowercased() {
        case "a": return ["à","á","â","ä","ã","å"]
        case "e": return ["è","é","ê","ë"]
        case "i": return ["ï","í","î","ì"]
        case "o": return ["ò","ó","ô","ö","õ"]
        case "u": return ["ü","ú","û","ù"]
        case "c": return ["ç"]
        case "n": return ["ñ"]
        case "s": return ["ß"]
        default: return []
        }
    }
    
    private func handleKeyPress(_ character: String) {
        performHaptic()
        proxy?.insertText(character)
        
        if character.isWordBoundary || character == "'" {
            handleWordBoundary()
        } else {
            currentWord += character
            updateSuggestions()
        }
        
        if shiftEnabled && !capsLock {
            shiftEnabled = false
        }
    }
    
    private func handleSpace() {
        performHaptic()
        
        if !currentWord.isEmpty {
            if let correction = autocorrectEngine.autocorrect(word: currentWord, language: detectedLanguage) {
                if let before = proxy?.documentContextBeforeInput {
                    let deleteCount = currentWord.count
                    for _ in 0..<deleteCount {
                        proxy?.deleteBackward()
                    }
                    proxy?.insertText(correction)
                    autocorrectReplacement = (currentWord, correction)
                }
            }
            previousWords.append(currentWord)
            if previousWords.count > 3 { previousWords.removeFirst() }
            currentWord = ""
        }
        
        proxy?.insertText(" ")
        suggestions = []
    }
    
    private func handleDelete() {
        performHaptic()
        
        if !currentWord.isEmpty {
            currentWord.removeLast()
            proxy?.deleteBackward()
            if currentWord.isEmpty {
                suggestions = []
            } else {
                updateSuggestions()
            }
        } else {
            proxy?.deleteBackward()
        }
    }
    
    private func handleReturn() {
        performHaptic()
        if !currentWord.isEmpty {
            previousWords.append(currentWord)
            currentWord = ""
            suggestions = []
        }
        proxy?.insertText("\n")
    }
    
    private func handleWordBoundary() {
        if !currentWord.isEmpty {
            previousWords.append(currentWord)
            if previousWords.count > 3 { previousWords.removeFirst() }
            currentWord = ""
        }
        suggestions = []
    }
    
    private func insertSuggestion(_ suggestion: String) {
        performHaptic()
        
        if !currentWord.isEmpty {
            let deleteCount = currentWord.count
            for _ in 0..<deleteCount {
                proxy?.deleteBackward()
            }
        }
        
        proxy?.insertText(suggestion)
        currentWord = ""
        suggestions = []
        previousWords.append(suggestion)
        if previousWords.count > 3 { previousWords.removeFirst() }
    }
    
    private func updateSuggestions() {
        guard UserDefaults.appGroup.predictiveTextEnabled else {
            suggestions = []
            return
        }
        
        detectedLanguage = languageDetector.detectLanguage(for: currentWord, previousWords: previousWords)
        
        if UserDefaults.appGroup.spellCheckEnabled && !spellChecker.isWordCorrect(currentWord, language: detectedLanguage) {
            let corrections = spellChecker.suggestions(for: currentWord, language: detectedLanguage, maxResults: 3)
            if !corrections.isEmpty {
                suggestions = corrections
                return
            }
        }
        
        suggestions = autocompleteEngine.predictions(for: currentWord, previousWords: previousWords, language: detectedLanguage)
    }
    
    private func performHaptic() {
        let level = AppConstants.HapticLevel(rawValue: UserDefaults.appGroup.hapticLevel) ?? .medium
        switch level {
        case .off: break
        case .light: UIImpactFeedbackGenerator(style: .light).impactOccurred()
        case .medium: UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        case .heavy: UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        }
    }
}

struct LongPressKey: View {
    let character: String
    let alternates: [String]
    let theme: KeyboardTheme
    let keyHeight: CGFloat
    let widthMultiplier: CGFloat
    let onTap: () -> Void
    let onAlternateSelect: (String) -> Void
    
    @State private var showAlternates = false
    
    var body: some View {
        ZStack {
            Button(action: onTap) {
                Text(character)
                    .font(.system(size: 20, weight: .regular))
                    .foregroundStyle(theme.keyForeground)
                    .frame(maxWidth: .infinity)
                    .frame(height: keyHeight)
                    .background(theme.keyBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(theme.border, lineWidth: 0.5)
                    )
            }
            .simultaneousGesture(
                LongPressGesture(minimumDuration: 0.4)
                    .onEnded { _ in
                        if !alternates.isEmpty {
                            showAlternates = true
                        }
                    }
            )
            
            if showAlternates {
                alternatePopup
            }
        }
    }
    
    private var alternatePopup: some View {
        VStack(spacing: 2) {
            ForEach(alternates, id: \.self) { alt in
                Button(action: {
                    onAlternateSelect(alt)
                    showAlternates = false
                }) {
                    Text(alt)
                        .font(.system(size: 20))
                        .foregroundStyle(theme.keyForeground)
                        .frame(width: 40, height: keyHeight)
                        .background(theme.keyBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                }
            }
        }
        .offset(y: -CGFloat(alternates.count) * (keyHeight + 2) - 8)
        .onTapOutside { showAlternates = false }
    }
}

extension View {
    func onTapOutside(perform action: @escaping () -> Void) -> some View {
        self.background(
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture { action() }
        )
    }
}

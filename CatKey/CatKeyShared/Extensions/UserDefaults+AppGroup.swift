import Foundation

extension UserDefaults {
    static var appGroup: UserDefaults {
        UserDefaults(suiteName: AppConstants.appGroupId) ?? .standard
    }
    
    private enum Keys {
        static let isPremium = "isPremium"
        static let spellCheckEnabled = "spellCheckEnabled"
        static let autocorrectEnabled = "autocorrectEnabled"
        static let predictiveTextEnabled = "predictiveTextEnabled"
        static let dialect = "dialect"
        static let keyboardHeight = "keyboardHeight"
        static let hapticLevel = "hapticLevel"
        static let theme = "theme"
        static let activeLanguage = "activeLanguage"
        static let bilingualModeEnabled = "bilingualModeEnabled"
        static let onboardingCompleted = "onboardingCompleted"
        static let soundEnabled = "soundEnabled"
    }
    
    var isPremium: Bool {
        get { bool(forKey: Keys.isPremium) }
        set { set(newValue, forKey: Keys.isPremium) }
    }
    
    var spellCheckEnabled: Bool {
        get { object(forKey: Keys.spellCheckEnabled) as? Bool ?? true }
        set { set(newValue, forKey: Keys.spellCheckEnabled) }
    }
    
    var autocorrectEnabled: Bool {
        get { object(forKey: Keys.autocorrectEnabled) as? Bool ?? true }
        set { set(newValue, forKey: Keys.autocorrectEnabled) }
    }
    
    var predictiveTextEnabled: Bool {
        get { object(forKey: Keys.predictiveTextEnabled) as? Bool ?? true }
        set { set(newValue, forKey: Keys.predictiveTextEnabled) }
    }
    
    var dialect: String {
        get { string(forKey: Keys.dialect) ?? AppConstants.Dialect.standard.rawValue }
        set { set(newValue, forKey: Keys.dialect) }
    }
    
    var keyboardHeight: String {
        get { string(forKey: Keys.keyboardHeight) ?? AppConstants.KeyboardHeight.standard.rawValue }
        set { set(newValue, forKey: Keys.keyboardHeight) }
    }
    
    var hapticLevel: String {
        get { string(forKey: Keys.hapticLevel) ?? AppConstants.HapticLevel.medium.rawValue }
        set { set(newValue, forKey: Keys.hapticLevel) }
    }
    
    var theme: String {
        get { string(forKey: Keys.theme) ?? AppConstants.Theme.system.rawValue }
        set { set(newValue, forKey: Keys.theme) }
    }
    
    var activeLanguage: String {
        get { string(forKey: Keys.activeLanguage) ?? AppConstants.Language.catalan.rawValue }
        set { set(newValue, forKey: Keys.activeLanguage) }
    }
    
    var bilingualModeEnabled: Bool {
        get { object(forKey: Keys.bilingualModeEnabled) as? Bool ?? true }
        set { set(newValue, forKey: Keys.bilingualModeEnabled) }
    }
    
    var onboardingCompleted: Bool {
        get { bool(forKey: Keys.onboardingCompleted) }
        set { set(newValue, forKey: Keys.onboardingCompleted) }
    }
    
    var soundEnabled: Bool {
        get { object(forKey: Keys.soundEnabled) as? Bool ?? true }
        set { set(newValue, forKey: Keys.soundEnabled) }
    }
}

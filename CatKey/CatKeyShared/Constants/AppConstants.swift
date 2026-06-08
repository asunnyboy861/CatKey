import Foundation

enum AppConstants {
    static let appName = "CatKey"
    static let bundleId = "com.zzoutuo.CatKey"
    static let keyboardBundleId = "com.zzoutuo.CatKey.Keyboard"
    static let appGroupId = "group.com.zzoutuo.CatKey.shared"
    static let proProductId = "com.zzoutuo.CatKey.pro"
    
    static let githubUser = "asunnyboy861"
    static let supportURL = "https://\(githubUser).github.io/CatKey/support.html"
    static let privacyURL = "https://\(githubUser).github.io/CatKey/privacy.html"
    static let termsURL = "https://\(githubUser).github.io/CatKey/terms.html"
    static let feedbackBackendURL = "https://feedback-board.iocompile67692.workers.dev"
    
    enum Keyboard {
        static let maxSuggestions = 5
        static let minPredictionPrefix = 2
        static let autocorrectMaxEditDistance = 2
        static let predictionBarHeight: CGFloat = 40
    }
    
    enum Language: String, CaseIterable {
        case catalan = "ca"
        case spanish = "es"
        case english = "en"
        
        var displayName: String {
            switch self {
            case .catalan: return "Català"
            case .spanish: return "Español"
            case .english: return "English"
            }
        }
        
        var spaceBarLabel: String {
            switch self {
            case .catalan: return "Català"
            case .spanish: return "Español"
            case .english: return "English"
            }
        }
    }
    
    enum Dialect: String, CaseIterable {
        case standard = "standard"
        case balearic = "balearic"
        case valencian = "valencian"
        
        var displayName: String {
            switch self {
            case .standard: return "Standard"
            case .balearic: return "Balearic"
            case .valencian: return "Valencian"
            }
        }
    }
    
    enum KeyboardHeight: String, CaseIterable {
        case compact = "compact"
        case standard = "standard"
        case tall = "tall"
        
        var displayName: String {
            switch self {
            case .compact: return "Compact"
            case .standard: return "Standard"
            case .tall: return "Tall"
            }
        }
        
        var heightMultiplier: CGFloat {
            switch self {
            case .compact: return 0.85
            case .standard: return 1.0
            case .tall: return 1.15
            }
        }
    }
    
    enum HapticLevel: String, CaseIterable {
        case off = "off"
        case light = "light"
        case medium = "medium"
        case heavy = "heavy"
        
        var displayName: String {
            switch self {
            case .off: return "Off"
            case .light: return "Light"
            case .medium: return "Medium"
            case .heavy: return "Heavy"
            }
        }
    }
    
    enum Theme: String, CaseIterable {
        case system = "system"
        case light = "light"
        case dark = "dark"
        case modernisme = "modernisme"
        case mediterranean = "mediterranean"
        case trencadis = "trencadis"
        
        var displayName: String {
            switch self {
            case .system: return "System"
            case .light: return "Light"
            case .dark: return "Dark"
            case .modernisme: return "Modernisme"
            case .mediterranean: return "Mediterranean"
            case .trencadis: return "Trencadís"
            }
        }
        
        var isPro: Bool {
            switch self {
            case .system, .light, .dark: return false
            case .modernisme, .mediterranean, .trencadis: return true
            }
        }
    }
}

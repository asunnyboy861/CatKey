import SwiftUI

struct SettingsView: View {
    @AppStorage("spellCheckEnabled") private var spellCheckEnabled = true
    @AppStorage("autocorrectEnabled") private var autocorrectEnabled = true
    @AppStorage("predictiveTextEnabled") private var predictiveTextEnabled = true
    @AppStorage("bilingualModeEnabled") private var bilingualModeEnabled = true
    @AppStorage("soundEnabled") private var soundEnabled = true
    @AppStorage("dialect") private var dialect = AppConstants.Dialect.standard.rawValue
    @AppStorage("keyboardHeight") private var keyboardHeight = AppConstants.KeyboardHeight.standard.rawValue
    @AppStorage("hapticLevel") private var hapticLevel = AppConstants.HapticLevel.medium.rawValue
    @AppStorage("theme") private var theme = AppConstants.Theme.system.rawValue
    @AppStorage("isPremium") private var isPremium = false
    
    @State private var showCustomDictionary = false
    
    var body: some View {
        NavigationStack {
            Form {
                keyboardSection
                spellCheckSection
                appearanceSection
                if isPremium { proFeaturesSection }
                dictionarySection
                legalSection
                aboutSection
            }
            .navigationTitle("Settings")
        }
    }
    
    private var keyboardSection: some View {
        Section("Keyboard") {
            Toggle("Spell Check", isOn: $spellCheckEnabled)
            Toggle("Autocorrect", isOn: $autocorrectEnabled)
            Toggle("Predictive Text", isOn: $predictiveTextEnabled)
            Toggle("Bilingual Mode", isOn: $bilingualModeEnabled)
            Toggle("Key Sounds", isOn: $soundEnabled)
            
            Picker("Haptic Feedback", selection: $hapticLevel) {
                ForEach(AppConstants.HapticLevel.allCases, id: \.rawValue) { level in
                    Text(level.displayName).tag(level.rawValue)
                }
            }
            
            Picker("Keyboard Height", selection: $keyboardHeight) {
                ForEach(AppConstants.KeyboardHeight.allCases, id: \.rawValue) { height in
                    Text(height.displayName).tag(height.rawValue)
                }
            }
        }
    }
    
    private var spellCheckSection: some View {
        Section("Spell Check") {
            Picker("Dialect", selection: $dialect) {
                ForEach(AppConstants.Dialect.allCases, id: \.rawValue) { d in
                    HStack {
                        Text(d.displayName)
                        if d != .standard && !isPremium {
                            Image(systemName: "lock.fill")
                                .foregroundStyle(.yellow)
                                .font(.caption)
                        }
                    }
                    .tag(d.rawValue)
                }
            }
            .onChange(of: dialect) { _, newValue in
                let selected = AppConstants.Dialect(rawValue: newValue) ?? .standard
                if selected != .standard && !isPremium {
                    dialect = AppConstants.Dialect.standard.rawValue
                }
            }
        }
    }
    
    private var appearanceSection: some View {
        Section("Appearance") {
            Picker("Theme", selection: $theme) {
                ForEach(AppConstants.Theme.allCases, id: \.rawValue) { t in
                    HStack {
                        Text(t.displayName)
                        if t.isPro && !isPremium {
                            Image(systemName: "lock.fill")
                                .foregroundStyle(.yellow)
                                .font(.caption)
                        }
                    }
                    .tag(t.rawValue)
                }
            }
            .onChange(of: theme) { _, newValue in
                let selected = AppConstants.Theme(rawValue: newValue) ?? .system
                if selected.isPro && !isPremium {
                    theme = AppConstants.Theme.system.rawValue
                }
            }
        }
    }
    
    private var proFeaturesSection: some View {
        Section("Pro Features") {
            Label("Dialect Support", systemImage: "text.badge.checkmark")
            Label("Professional Dictionaries", systemImage: "book.fill")
            Label("Custom Dictionary", systemImage: "plus.circle.fill")
            Label("Advanced Autocorrect", systemImage: "wand.and.stars")
            Label("Theme Customization", systemImage: "paintpalette.fill")
        }
    }
    
    private var dictionarySection: some View {
        Section("Dictionary") {
            NavigationLink(destination: CustomDictionaryView()) {
                Label("Custom Dictionary", systemImage: "text.book.closed")
            }
            if !isPremium {
                HStack {
                    Text("Custom Dictionary")
                    Spacer()
                    Image(systemName: "lock.fill")
                        .foregroundStyle(.yellow)
                        .font(.caption)
                }
            }
        }
    }
    
    private var legalSection: some View {
        Section("Legal") {
            Link("Support", destination: URL(string: AppConstants.supportURL)!)
            Link("Privacy Policy", destination: URL(string: AppConstants.privacyURL)!)
            Link("Terms of Use", destination: URL(string: AppConstants.termsURL)!)
            NavigationLink(destination: ContactSupportView()) {
                Label("Contact Support", systemImage: "envelope")
            }
        }
    }
    
    private var aboutSection: some View {
        Section("About") {
            HStack {
                Text("Version")
                Spacer()
                Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")
                    .foregroundStyle(.secondary)
            }
            
            if !isPremium {
                NavigationLink(destination: PremiumView()) {
                    HStack {
                        Image(systemName: "star.circle.fill")
                            .foregroundStyle(Color(red: 0.85, green: 0.65, blue: 0.13))
                        Text("Upgrade to Pro")
                            .foregroundStyle(Color(red: 0.85, green: 0.65, blue: 0.13))
                    }
                }
            }
            
            if isPremium {
                RestorePurchasesButton()
            }
        }
    }
}

struct RestorePurchasesButton: View {
    @StateObject private var purchaseManager = PurchaseManager()
    
    var body: some View {
        Button(action: {
            Task { await purchaseManager.restorePurchases() }
        }) {
            Text("Restore Purchases")
        }
    }
}

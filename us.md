# CatKey - iOS Development Guide

## Executive Summary

**CatKey** is a custom keyboard extension for iOS that provides Catalan language spell checking, autocorrect, and word prediction — capabilities removed from iOS since version 17.4. With 7.5 million+ Catalan speakers and zero dedicated competitors on the App Store, CatKey fills a critical market gap.

**Product Vision**: CatKey is not just a keyboard — it is a symbol of linguistic rights. Catalan speakers have a strong sense of language preservation, and CatKey represents "someone cares about us" after Apple removed native Catalan support.

**Key Differentiators**:
- Only App Store app dedicated to Catalan spell checking + autocorrect + word prediction
- Pure offline operation — no data collection, privacy-first
- Bilingual Catalan-Spanish seamless switching with automatic language detection
- Catalan Modernisme (Gaudí-inspired) design language for cultural identity
- Freemium model: free core features + $3.99 one-time Pro upgrade

**Target Market**: USA (420K+ Catalan diaspora) and Spain (Catalonia region, 7.5M+ speakers)

**Interface Languages**: Spanish + Catalan

## Competitive Analysis

| App | Strengths | Weaknesses | Our Advantage |
|-----|-----------|------------|---------------|
| iOS Native Keyboard | System integration, fast | Removed Catalan spell check in iOS 17.4 | CatKey restores what Apple removed |
| Gboard (Google) | 75+ languages, Glide typing, search | No Catalan spell check/autocorrect | CatKey has dedicated Catalan engine |
| SwiftKey (Microsoft) | Multilingual prediction | No Catalan spell check support | CatKey is Catalan-first, not afterthought |
| KeyboardKit App | 75 languages including Catalan, themes | Generic keyboard, shallow Catalan support | CatKey has deep Catalan-specific dictionaries + N-gram model |
| LanguageTool | Grammar checking, Catalan support | Not a keyboard extension — must switch apps | CatKey works inline in any app |
| Polyglotte | Special character keyboard with Catalan | No spell check, no autocorrect, $22.99, iPad only | CatKey is full keyboard with spell check at $3.99 |
| A.I.type Catalan | Catalan keyboard with prediction | Android-focused, outdated, limited iOS support | CatKey is modern SwiftUI, iOS-native |

## Feature Inventory

### Primary Features

| # | Feature | User Operation Flow | Data Input | Processing | Data Output | Persistence | Acceptance Criteria |
|---|---------|--------------------|------------|------------|-------------|-------------|---------------------|
| 1 | Catalan QWERTY Keyboard | 1. User switches to CatKey keyboard → 2. Types on QWERTY layout → 3. Special Catalan chars via long-press (à, è, é, í, ï, ó, ò, ú, ü, ç, ·) | Key taps, long-press gestures | Keyboard layout engine maps input to characters, handles shift/caps states | Characters inserted into text field | UserDefaults (App Group) for keyboard state | All Catalan-specific characters accessible; keyboard responds <50ms per key |
| 2 | Spell Checking | 1. User types a word → 2. System checks spelling in real-time → 3. Incorrect words get red underline → 4. Correction suggestions appear in prediction bar | Current word being typed | Hunspell engine: dictionary lookup → morphological analysis → edit distance calculation → suggestion ranking | isCorrect: Bool, suggestions: [Word] | Hunspell .dic/.aff files (Bundle, read-only) | >95% accuracy on Catalan words; <30ms per word check |
| 3 | Autocorrect | 1. User types misspelled word → 2. System auto-replaces with top suggestion → 3. Underline shows replacement → 4. User can tap to revert | Misspelled word + context | Edit distance (Levenshtein ≤2) + keyboard adjacency awareness + context scoring | Auto-replaced text with revert option | App Group UserDefaults for autocorrect on/off | >90% correction accuracy; respects user revert |
| 4 | Word Prediction | 1. User types 2+ characters → 2. Prediction bar shows 3-5 word candidates → 3. User taps to accept or continues typing | Current word prefix + previous 1-2 words | Prefix trie search + N-gram context scoring + frequency ranking | Up to 5 candidate words in prediction bar | N-gram model files (Bundle, read-only) | Relevant predictions within <50ms; top-3 accuracy >60% |
| 5 | Bilingual Switching (Catalan-Spanish) | 1. User types in mixed Catalan/Spanish → 2. System auto-detects language per word → 3. Spell check applies correct dictionary → 4. Space bar shows detected language | Current word + previous 2 words context | Character marker detection (à,ç,ï→Catalan; ñ,á→Spanish) + dictionary lookup + statistical model | Language label on space bar (.catalan / .spanish / .english) | App Group UserDefaults for bilingual mode | Correct language detection >85%; seamless per-word switching |
| 6 | Onboarding Guide | 1. User opens CatKey app → 2. Welcome page → 3. Spell check info → 4. Bilingual info → 5. 3-step keyboard setup guide | None (read-only flow) | Keyboard status detection via UITextInputMode | Step completion status (enabled/not, full access/not) | None | User can enable keyboard and grant full access through guided steps |
| 7 | Settings | 1. User opens CatKey app → 2. Taps Settings → 3. Toggles features / selects options | Toggle switches, picker selections | Settings written to App Group UserDefaults | Updated settings reflected in keyboard extension | App Group UserDefaults | All settings sync to keyboard extension within 1 second |
| 8 | Premium / IAP | 1. User taps Pro upgrade → 2. Paywall shows features → 3. User purchases $3.99 one-time → 4. Pro features unlocked | Purchase button tap | StoreKit transaction verification → premium flag set | Premium status synced to keyboard extension | App Group UserDefaults (isPremium) | Pro features unlock immediately after purchase; persists across reinstalls |
| 9 | Custom Dictionary | 1. User adds word in Settings → 2. Word saved to user dictionary → 3. Keyboard recognizes word as valid | Word text + language selection | Core Data insert → dictionary manager reload | Word appears in spell check as valid | Core Data (App Group container) | Custom words recognized within next keyboard session |
| 10 | Keyboard Themes | 1. User selects theme in Settings → 2. Theme preference saved → 3. Keyboard renders with selected theme | Theme name selection | Theme engine applies colors/fonts to keyboard view | Styled keyboard | App Group UserDefaults (themePreference) | Theme change reflected in keyboard without restart |

### Sub-Features & Detail Interactions

| # | Parent Feature | Sub-Feature | Detail Description | Interaction Pattern |
|---|---------------|-------------|-------------------|--------------------|
| 1.1 | QWERTY Keyboard | Long-press character variants | Long-press e shows: è, é, ê; long-press a shows: à, á, â; long-press c shows: ç; long-press i shows: ï, í | Long-press → popup → drag to select |
| 1.2 | QWERTY Keyboard | Number/Symbol keyboard | Tap "123" key to switch to number/symbol layout | Tap toggle |
| 1.3 | QWERTY Keyboard | Globe key language switch | Tap globe key to cycle between Catalan/Spanish/English | Tap cycle |
| 1.4 | QWERTY Keyboard | Haptic & sound feedback | Key press triggers haptic tap + optional sound | Automatic on key press |
| 2.1 | Spell Checking | Dialect support (Pro) | Standard / Balearic / Valencian dictionary variants | Settings picker |
| 2.2 | Spell Checking | Professional dictionaries (Pro) | Legal, medical, education specialized vocabularies | Settings toggle |
| 5.1 | Bilingual Switching | Mixed-language input | Both Catalan and Spanish words checked in their respective dictionaries within same sentence | Automatic per-word |
| 7.1 | Settings | Spell check toggle | Enable/disable spell checking | Toggle switch |
| 7.2 | Settings | Autocorrect toggle | Enable/disable autocorrect | Toggle switch |
| 7.3 | Settings | Predictive text toggle | Enable/disable word prediction | Toggle switch |
| 7.4 | Settings | Dialect selection | Choose Standard/Balearic/Valencian | Picker |
| 7.5 | Settings | Keyboard height | Adjust keyboard height (compact/standard/tall) | Picker |
| 7.6 | Settings | Haptic feedback level | Light/medium/heavy/off | Picker |
| 9.1 | Custom Dictionary | Add word | Type word + select language → save | Text input + button |
| 9.2 | Custom Dictionary | Delete word | Swipe to delete from list | Swipe left |
| 9.3 | Custom Dictionary | Ignore list | Add words to spell check ignore list | Text input + button |

### Cross-Feature Dependencies

| Dependency | Source Feature | Target Feature | Data Passed | Trigger Condition |
|------------|---------------|----------------|-------------|-------------------|
| Spell check feeds predictions | Spell Checking | Word Prediction | isCorrect flag + suggestions | Every word boundary |
| Language detection drives spell check | Bilingual Switching | Spell Checking | Detected language enum | Every word boundary |
| Language detection drives predictions | Bilingual Switching | Word Prediction | Detected language enum | Every word boundary |
| Settings sync to keyboard | Settings | All keyboard features | All toggle/selection values | On settings change |
| Premium unlocks features | Premium / IAP | Spell Checking, Word Prediction, Custom Dictionary, Themes | isPremium flag | On purchase completion |
| Custom dictionary enriches spell check | Custom Dictionary | Spell Checking | User word list | On dictionary change |
| Autocorrect uses spell check results | Spell Checking | Autocorrect | Top suggestion | When isCorrect == false |

## Apple Design Guidelines Compliance

### Custom Keyboard Extension Requirements (Guideline 4.4)
- **Must provide keyboard input functionality**: CatKey provides full QWERTY keyboard with Catalan character support
- **Must provide way to switch to next keyboard**: Globe key included (respects needsInputModeSwitchKey)
- **Must work without network connection**: CatKey is 100% offline — no network required
- **Must not include marketing/ads in keyboard extension**: Keyboard extension is clean, no ads
- **Must not initiate network requests from keyboard**: CatKey never makes network calls
- **Full Access disclosure**: App clearly explains why Full Access is needed (spell check + autocorrect)

### Privacy Compliance (Guideline 5.1)
- No user data collected or transmitted
- No network requests
- All data stays on-device
- Privacy policy clearly states zero data collection
- Custom dictionary data stored locally only

### App Completeness (Guideline 2.1)
- Free version provides full core functionality (spell check + autocorrect + prediction)
- No broken or placeholder features
- Keyboard extension works reliably across all apps

### IAP Compliance (Guideline 3.1)
- Pro upgrade is one-time purchase (non-consumable)
- Free version is fully functional, not a trial
- Paywall clearly lists Pro features
- No subscriptions

## Technical Architecture

- **Language**: Swift 5.9+
- **Framework**: SwiftUI (primary), UIKit (keyboard extension base)
- **Keyboard Extension**: UIInputViewController with custom SwiftUI view
- **Data**: Core Data (user dictionary) + UserDefaults/App Group (settings sync)
- **Spell Check**: Hunspell engine (C bridge) with Catalan/Spanish dictionaries
- **Autocomplete**: Custom N-gram model + Prefix Trie
- **Networking**: None (pure offline)
- **Dependency Management**: Swift Package Manager
- **Architecture**: MVVM

## Module Structure

```
CatKey/
├── CatKeyApp/                    Main App Target
│   ├── CatKeyApp.swift           App entry point
│   ├── Views/
│   │   ├── OnboardingView.swift  4-page onboarding
│   │   ├── SettingsView.swift    Settings screen
│   │   ├── KeyboardStatusView.swift
│   │   └── PremiumView.swift     Paywall
│   ├── ViewModels/
│   │   ├── SettingsViewModel.swift
│   │   └── PremiumViewModel.swift
│   └── Resources/
│       ├── Assets.xcassets
│       └── Localizable.xcstrings
│
├── CatKeyKeyboard/               Keyboard Extension Target
│   ├── KeyboardViewController.swift
│   ├── Views/
│   │   └── CatKeyKeyboardView.swift
│   ├── Engines/
│   │   ├── SpellChecker.swift
│   │   ├── AutocompleteEngine.swift
│   │   ├── LanguageDetector.swift
│   │   └── HunspellBridge.swift
│   ├── Models/
│   │   ├── DictionaryManager.swift
│   │   ├── NGramModel.swift
│   │   └── UserDictionary.swift
│   └── Resources/
│       ├── ca_ES.dic
│       ├── ca_ES.aff
│       ├── es_ES.dic
│       └── es_ES.aff
│
├── CatKeyShared/                 Shared Code
│   ├── Extensions/
│   │   ├── String+EditingDistance.swift
│   │   └── UserDefaults+AppGroup.swift
│   ├── Protocols/
│   │   ├── SpellChecking.swift
│   │   └── Autocompleting.swift
│   └── Constants/
│       └── AppConstants.swift
│
└── CatKeyTests/                  Test Target
    ├── SpellCheckerTests.swift
    ├── AutocompleteEngineTests.swift
    └── LanguageDetectorTests.swift
```

## Data Flow Diagram

### Feature 1: Catalan QWERTY Keyboard
```
┌───────────────────────────────────────────────────────────┐
│  User Input                                               │
│  └── Key tap / long-press gesture on keyboard view        │
│       │                                                   │
│  KeyboardViewController Processing                        │
│  └── CatKeyKeyboardView.swift → identify key → insert    │
│       character into textDocumentProxy                    │
│       │                                                   │
│  Display Output                                           │
│  └── Character appears in host app text field             │
│       │                                                   │
│  Cross-Feature Output                                     │
│  └── Current word context passed to Spell Check +         │
│     Autocomplete engines on word boundary (space/punct)   │
└───────────────────────────────────────────────────────────┘
```

### Feature 2: Spell Checking
```
┌───────────────────────────────────────────────────────────┐
│  User Input                                               │
│  └── Types word (triggers on each character or boundary)  │
│       │                                                   │
│  SpellChecker Processing                                  │
│  └── SpellChecker.swift → HunspellBridge → lookup word   │
│     in ca_ES.dic + ca_ES.aff (or es_ES for Spanish)      │
│     → if not found: calculate edit distance suggestions   │
│       │                                                   │
│  Model/Persistence                                        │
│  └── Hunspell dictionaries (Bundle, read-only)            │
│  └── UserDictionary (Core Data, read-write)               │
│       │                                                   │
│  Display Output                                           │
│  └── Red underline on misspelled words                    │
│  └── Correction suggestions in prediction bar             │
│       │                                                   │
│  Cross-Feature Output                                     │
│  └── isCorrect + suggestions → Autocorrect engine         │
│  └── suggestions → merged with Autocomplete results       │
└───────────────────────────────────────────────────────────┘
```

### Feature 3: Autocorrect
```
┌───────────────────────────────────────────────────────────┐
│  User Input                                               │
│  └── Continues typing after misspelled word (space/punct) │
│       │                                                   │
│  Autocorrect Processing                                   │
│  └── SpellChecker result → top suggestion selected        │
│  └── Edit distance + keyboard adjacency scoring           │
│  └── Replace word in textDocumentProxy                    │
│       │                                                   │
│  Display Output                                           │
│  └── Auto-replaced text with underline (revertible)       │
│  └── User taps underline → original text restored         │
│       │                                                   │
│  Persistence                                              │
│  └── App Group UserDefaults: autocorrectEnabled toggle    │
└───────────────────────────────────────────────────────────┘
```

### Feature 4: Word Prediction
```
┌───────────────────────────────────────────────────────────┐
│  User Input                                               │
│  └── Types 2+ characters (prefix) + previous word context │
│       │                                                   │
│  AutocompleteEngine Processing                            │
│  └── AutocompleteEngine.swift → prefix trie search        │
│  └── N-gram context scoring (previous 1-2 words)          │
│  └── Frequency ranking → top 3-5 candidates               │
│       │                                                   │
│  Model/Persistence                                        │
│  └── N-gram model files (Bundle, read-only)               │
│  └── Prefix trie index (Bundle, read-only)                │
│  └── UserDictionary frequency data (Core Data)            │
│       │                                                   │
│  Display Output                                           │
│  └── Prediction bar: [candidate1] [candidate2] [candidate3]│
│  └── User taps candidate → word inserted                  │
│       │                                                   │
│  Cross-Feature Output                                     │
│  └── Merged with spell check suggestions (corrections     │
│     prioritized over predictions)                         │
└───────────────────────────────────────────────────────────┘
```

### Feature 5: Bilingual Switching
```
┌───────────────────────────────────────────────────────────┐
│  User Input                                               │
│  └── Types in mixed Catalan/Spanish text                  │
│       │                                                   │
│  LanguageDetector Processing                              │
│  └── LanguageDetector.swift → character markers check      │
│  └── Dictionary lookup (which dict contains the word)      │
│  └── Statistical context model (previous words language)   │
│       │                                                   │
│  Output                                                   │
│  └── Language enum: .catalan / .spanish / .english        │
│  └── Space bar label updates: "català" / "español"        │
│       │                                                   │
│  Cross-Feature Output                                     │
│  └── Drives SpellChecker: which dictionary to use          │
│  └── Drives AutocompleteEngine: which N-gram model        │
└───────────────────────────────────────────────────────────┘
```

### Feature 7: Settings
```
┌───────────────────────────────────────────────────────────┐
│  User Input                                               │
│  └── Toggle switch / picker selection in Settings screen   │
│       │                                                   │
│  SettingsViewModel Processing                             │
│  └── SettingsViewModel.swift → validate → write to        │
│     App Group UserDefaults                                │
│       │                                                   │
│  Persistence                                              │
│  └── App Group UserDefaults (shared between app + keyboard)│
│     Keys: spellCheckEnabled, autocorrectEnabled,           │
│     predictiveTextEnabled, dialectMode, bilingualMode,     │
│     isPremium, themePreference, keyboardHeight,            │
│     hapticFeedbackLevel, soundFeedbackType                 │
│       │                                                   │
│  Cross-Feature Output                                     │
│  └── Keyboard extension reads same UserDefaults → applies │
│     settings in real-time                                 │
└───────────────────────────────────────────────────────────┘
```

### Feature 8: Premium / IAP
```
┌───────────────────────────────────────────────────────────┐
│  User Input                                               │
│  └── Taps "Upgrade to Pro" button in PremiumView          │
│       │                                                   │
│  PremiumViewModel Processing                              │
│  └── PremiumViewModel.swift → StoreKit purchase flow      │
│  └── Transaction verification → set isPremium = true      │
│       │                                                   │
│  Persistence                                              │
│  └── App Group UserDefaults: isPremium (Bool)             │
│  └── StoreKit transaction receipt                         │
│       │                                                   │
│  Cross-Feature Output                                     │
│  └── Keyboard extension reads isPremium → unlock:         │
│     - Full dictionary (50K+ words)                        │
│     - Advanced autocorrect (edit distance 2)               │
│     - 5-word predictions                                  │
│     - Dialect support                                     │
│     - Professional dictionaries                           │
│     - Custom dictionary                                   │
│     - Theme customization                                 │
│     - Keyboard height adjustment                          │
└───────────────────────────────────────────────────────────┘
```

## Implementation Flow

1. Create Xcode project with Main App + Keyboard Extension targets
2. Configure App Group for data sharing between targets
3. Implement shared constants and App Group UserDefaults
4. Build keyboard extension with Catalan QWERTY layout
5. Integrate Hunspell engine with Catalan/Spanish dictionaries
6. Implement spell checking engine
7. Implement autocomplete engine with prefix trie + N-gram
8. Implement language detector for bilingual switching
9. Build main app: onboarding flow (4 pages)
10. Build settings screen with all toggles/pickers
11. Implement IAP with StoreKit (non-consumable Pro upgrade)
12. Implement custom dictionary (Core Data)
13. Implement keyboard themes
14. Test and optimize performance (<50ms response, <30MB memory)

## UI/UX Design Specifications

### Color System
- **Primary**: Trencadis Blue #2D7DD2 (keyboard top bar, brand color)
- **Secondary**: Mediterranean Sand #F2E8CF (keyboard background)
- **Accent**: Gaudí Gold #E8A838 (Pro badge, CTA buttons)
- **Error**: Senyera Red #CC3333 (spell check error underline)
- **Background**: #FFFFFF (Light) / #1C1C1E (Dark)
- **Text**: #000000 (Light) / #FFFFFF (Dark)
- **Separator**: #E5E5EA (Light) / #38383A (Dark)

### Typography
- System font (SF Pro) throughout
- Large Title: 34pt bold (app title)
- Title 2: 22pt bold (section headers)
- Headline: 17pt semibold (button text)
- Body: 17pt regular (descriptions)
- Caption: 12pt regular (keyboard space bar label)

### Layout
- Keyboard follows standard iOS keyboard dimensions
- Prediction bar: 44pt height above keyboard
- Key size: standard iOS key dimensions
- Safe area respected for home indicator

### Animations
- Key press: subtle scale animation (0.95 → 1.0)
- Prediction bar: fade-in on new suggestions
- Language switch: smooth crossfade on space bar label
- Onboarding: page-style transition

### App Icon
- Cat paw print + keyboard key fusion
- Trencadis Blue gradient background (#2D7DD2 → #1A5FA0)
- Subtle Gaudí mosaic texture
- 4 cat toes = 4 keyboard keys, paw pad = spacebar

## Code Generation Rules

- One feature per module, high cohesion, low coupling
- Semantic naming, clear file structure
- Never add comments in code unless asked
- Apple native first: prioritize SwiftUI/Swift
- MVVM architecture throughout
- Swift Concurrency (async/await + Actor) for async operations
- Core Data for user dictionary, UserDefaults (App Group) for settings
- Swift Package Manager for dependencies
- Memory limit: keyboard extension must stay under 50MB
- Performance: key response <50ms, spell check <30ms/word
- Security: no data collection, no network, pure offline

## Build & Deployment Checklist

- [ ] Xcode project with Main App + Keyboard Extension targets
- [ ] App Group configured (group.com.zzoutuo.CatKey.shared)
- [ ] Keyboard extension Info.plist with RequestsOpenAccess = YES
- [ ] Hunspell dictionaries bundled in keyboard extension target
- [ ] N-gram model files bundled in keyboard extension target
- [ ] App Store icon 1024x1024
- [ ] Screenshots for 6.7", 6.5", 5.5" devices
- [ ] Privacy policy page (no data collection)
- [ ] App Store metadata in Spanish + Catalan + English
- [ ] Age rating: 4+
- [ ] IAP non-consumable product configured in App Store Connect

import SwiftUI
import StoreKit

@main
struct CatKeyApp: App {
    @AppStorage("onboardingCompleted") private var onboardingCompleted = false
    
    var body: some Scene {
        WindowGroup {
            if onboardingCompleted {
                MainTabView()
            } else {
                OnboardingView()
            }
        }
    }
}

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            KeyboardStatusView()
                .tabItem {
                    Label("Keyboard", systemImage: "keyboard")
                }
                .tag(0)
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
                .tag(1)
        }
    }
}

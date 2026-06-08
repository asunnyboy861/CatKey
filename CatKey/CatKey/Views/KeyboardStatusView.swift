import SwiftUI

struct KeyboardStatusView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    statusCard
                    quickActions
                    Spacer(minLength: 40)
                }
                .padding()
            }
            .navigationTitle("CatKey")
        }
    }
    
    private var statusCard: some View {
        VStack(spacing: 16) {
            Image(systemName: "keyboard")
                .font(.system(size: 48))
                .foregroundStyle(Color(red: 0.18, green: 0.49, blue: 0.82))
            
            Text("Catalan Keyboard")
                .font(.title2.bold())
            
            Text("Your keyboard is ready to use. Switch to CatKey in any app by tapping the globe key.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            
            NavigationLink(destination: OnboardingView()) {
                Text("Setup Guide")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(Color(red: 0.18, green: 0.49, blue: 0.82))
            }
        }
        .padding(24)
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private var quickActions: some View {
        VStack(spacing: 12) {
            NavigationLink(destination: SettingsView()) {
                HStack {
                    Image(systemName: "gearshape")
                        .foregroundStyle(Color(red: 0.18, green: 0.49, blue: 0.82))
                    Text("Keyboard Settings")
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.tertiary)
                }
                .padding()
                .background(Color(UIColor.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .buttonStyle(.plain)
            
            NavigationLink(destination: PremiumView()) {
                HStack {
                    Image(systemName: "star.circle")
                        .foregroundStyle(Color(red: 0.85, green: 0.65, blue: 0.13))
                    Text("Upgrade to Pro")
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.tertiary)
                }
                .padding()
                .background(Color(UIColor.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .buttonStyle(.plain)
        }
    }
}

import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @AppStorage("onboardingCompleted") private var onboardingCompleted = false
    
    var body: some View {
        TabView(selection: $currentPage) {
            welcomePage().tag(0)
            spellCheckPage().tag(1)
            bilingualPage().tag(2)
            setupPage().tag(3)
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }
    
    private func welcomePage() -> some View {
        VStack(spacing: 24) {
            Spacer()
            Image(systemName: "keyboard")
                .font(.system(size: 72))
                .foregroundStyle(Color(red: 0.18, green: 0.49, blue: 0.82))
            Text("Welcome to CatKey")
                .font(.largeTitle.bold())
            Text("The Catalan keyboard that brings back what Apple removed — spell checking, autocorrect, and word prediction for Catalan.")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            Spacer()
            onboardingButton("Next")
        }
        .padding()
    }
    
    private func spellCheckPage() -> some View {
        VStack(spacing: 24) {
            Spacer()
            Image(systemName: "text.badge.checkmark")
                .font(.system(size: 72))
                .foregroundStyle(Color(red: 0.18, green: 0.49, blue: 0.82))
            Text("Catalan Spell Check")
                .font(.largeTitle.bold())
            VStack(alignment: .leading, spacing: 12) {
                featureRow("Real-time spell checking")
                featureRow("Smart autocorrect")
                featureRow("Word prediction")
                featureRow("Works in any app")
            }
            .padding(.horizontal, 32)
            Spacer()
            onboardingButton("Next")
        }
        .padding()
    }
    
    private func bilingualPage() -> some View {
        VStack(spacing: 24) {
            Spacer()
            Image(systemName: "text.bubble")
                .font(.system(size: 72))
                .foregroundStyle(Color(red: 0.18, green: 0.49, blue: 0.82))
            Text("Bilingual Support")
                .font(.largeTitle.bold())
            Text("Seamlessly switch between Catalan and Spanish. CatKey automatically detects which language you're typing and applies the correct dictionary.")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            Spacer()
            onboardingButton("Next")
        }
        .padding()
    }
    
    private func setupPage() -> some View {
        VStack(spacing: 24) {
            Spacer()
            Image(systemName: "gear")
                .font(.system(size: 72))
                .foregroundStyle(Color(red: 0.18, green: 0.49, blue: 0.82))
            Text("3-Step Setup")
                .font(.largeTitle.bold())
            VStack(alignment: .leading, spacing: 16) {
                stepRow("1", "Go to Settings → General → Keyboard → Keyboards")
                stepRow("2", "Tap \"Add New Keyboard\" and select CatKey")
                stepRow("3", "Tap CatKey and enable \"Full Access\"")
            }
            .padding(.horizontal, 24)
            Spacer()
            Button(action: { onboardingCompleted = true }) {
                Text("Get Started")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color(red: 0.18, green: 0.49, blue: 0.82))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(.horizontal, 32)
            Spacer(minLength: 16)
        }
        .padding()
    }
    
    private func featureRow(_ text: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(Color(red: 0.18, green: 0.49, blue: 0.82))
            Text(text)
                .font(.body)
            Spacer()
        }
    }
    
    private func stepRow(_ number: String, _ text: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text(number)
                .font(.headline)
                .foregroundStyle(.white)
                .frame(width: 28, height: 28)
                .background(Color(red: 0.18, green: 0.49, blue: 0.82))
                .clipShape(Circle())
            Text(text)
                .font(.body)
            Spacer()
        }
    }
    
    private func onboardingButton(_ title: String) -> some View {
        Button(action: { withAnimation { currentPage += 1 } }) {
            Text(title)
                .font(.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color(red: 0.18, green: 0.49, blue: 0.82))
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding(.horizontal, 32)
    }
}

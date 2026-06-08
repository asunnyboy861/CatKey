import SwiftUI
import StoreKit

struct PremiumView: View {
    @StateObject private var purchaseManager = PurchaseManager()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                header
                featuresList
                purchaseButton
                legalLinks
            }
            .padding()
        }
        .navigationTitle("CatKey Pro")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var header: some View {
        VStack(spacing: 12) {
            Image(systemName: "star.circle.fill")
                .font(.system(size: 56))
                .foregroundStyle(Color(red: 0.85, green: 0.65, blue: 0.13))
            Text("Unlock CatKey Pro")
                .font(.title.bold())
            Text("One-time purchase. Yours forever.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
    
    private var featuresList: some View {
        VStack(spacing: 0) {
            proFeatureRow("Complete Dictionary", "50,000+ words with advanced autocorrect", "text.book.closed.fill")
            Divider().padding(.leading, 44)
            proFeatureRow("Dialect Support", "Balearic & Valencian variants", "globe")
            Divider().padding(.leading, 44)
            proFeatureRow("Professional Dictionaries", "Legal, medical, education vocabularies", "briefcase.fill")
            Divider().padding(.leading, 44)
            proFeatureRow("Custom Dictionary", "Add your own words and terms", "plus.circle.fill")
            Divider().padding(.leading, 44)
            proFeatureRow("Theme Customization", "Modernisme, Mediterranean, Trencadís", "paintpalette.fill")
            Divider().padding(.leading, 44)
            proFeatureRow("Keyboard Height", "Compact, standard, or tall layout", "arrow.up.and.down.text.horizontal")
        }
        .padding()
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private func proFeatureRow(_ title: String, _ subtitle: String, _ icon: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(Color(red: 0.18, green: 0.49, blue: 0.82))
                .frame(width: 28)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body.weight(.medium))
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Image(systemName: "checkmark")
                .foregroundStyle(Color(red: 0.18, green: 0.49, blue: 0.82))
        }
        .padding(.vertical, 8)
    }
    
    private var purchaseButton: some View {
        VStack(spacing: 8) {
            if purchaseManager.isPremium {
                Label("You have CatKey Pro", systemImage: "checkmark.circle.fill")
                    .font(.headline)
                    .foregroundStyle(.green)
            } else {
                Button(action: {
                    Task { await purchaseManager.purchase() }
                }) {
                    Group {
                        if purchaseManager.isLoading {
                            ProgressView()
                                .tint(.white)
                        } else {
                            if let product = purchaseManager.product {
                                Text("Buy CatKey Pro — \(product.displayPrice)")
                                    .font(.headline)
                            } else {
                                Text("Buy CatKey Pro — $3.99")
                                    .font(.headline)
                            }
                        }
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color(red: 0.18, green: 0.49, blue: 0.82))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .disabled(purchaseManager.isLoading)
                
                Button(action: {
                    Task { await purchaseManager.restorePurchases() }
                }) {
                    Text("Restore Purchases")
                        .font(.subheadline)
                        .foregroundStyle(Color(red: 0.18, green: 0.49, blue: 0.82))
                }
            }
            
            if let error = purchaseManager.purchaseError {
                Text(error)
                    .font(.caption)
                    .foregroundStyle(.red)
            }
        }
    }
    
    private var legalLinks: some View {
        HStack(spacing: 16) {
            Link("Privacy Policy", destination: URL(string: AppConstants.privacyURL)!)
                .font(.caption2)
                .foregroundStyle(Color(red: 0.18, green: 0.49, blue: 0.82))
            Link("Terms of Use", destination: URL(string: AppConstants.termsURL)!)
                .font(.caption2)
                .foregroundStyle(Color(red: 0.18, green: 0.49, blue: 0.82))
        }
        .padding(.top, 4)
    }
}

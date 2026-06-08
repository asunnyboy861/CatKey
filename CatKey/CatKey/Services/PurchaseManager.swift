import SwiftUI
import StoreKit
import Combine

@MainActor
class PurchaseManager: ObservableObject {
    @Published var isPremium = false
    @Published var isLoading = false
    @Published var product: Product?
    @Published var purchaseError: String?
    
    private let productId = AppConstants.proProductId
    
    init() {
        isPremium = UserDefaults.appGroup.isPremium
        Task { await loadProduct() }
        Task { await listenForTransactions() }
    }
    
    func loadProduct() async {
        do {
            let products = try await Product.products(for: [productId])
            product = products.first
        } catch {
            purchaseError = error.localizedDescription
        }
    }
    
    func purchase() async {
        guard let product = product else { return }
        isLoading = true
        defer { isLoading = false }
        
        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                let transaction = try checkVerified(verification)
                isPremium = true
                UserDefaults.appGroup.isPremium = true
                await transaction.finish()
            case .userCancelled:
                break
            case .pending:
                break
            @unknown default:
                break
            }
        } catch {
            purchaseError = error.localizedDescription
        }
    }
    
    func restorePurchases() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await AppStore.sync()
            for await result in Transaction.currentEntitlements {
                if case .verified(let transaction) = result {
                    if transaction.productID == productId {
                        isPremium = true
                        UserDefaults.appGroup.isPremium = true
                        await transaction.finish()
                    }
                }
            }
        } catch {
            purchaseError = error.localizedDescription
        }
    }
    
    private func listenForTransactions() async {
        for await result in Transaction.updates {
            if case .verified(let transaction) = result {
                if transaction.productID == productId {
                    isPremium = true
                    UserDefaults.appGroup.isPremium = true
                }
                await transaction.finish()
            }
        }
    }
    
    private func checkVerified(_ result: VerificationResult<StoreKit.Transaction>) throws -> StoreKit.Transaction {
        switch result {
        case .unverified:
            throw StoreError.failedVerification
        case .verified(let transaction):
            return transaction
        }
    }
}

enum StoreError: Error {
    case failedVerification
}

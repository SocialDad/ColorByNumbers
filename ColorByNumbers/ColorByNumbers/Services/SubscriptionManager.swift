import StoreKit
import SwiftUI

@MainActor
class SubscriptionManager: ObservableObject {
    @Published var isSubscribed = false
    @Published var products: [Product] = []
    @Published var purchaseError: String?
    @Published var isLoading = false

    static let weeklyProductId = "com.colorbynumbers.weekly"
    static let monthlyProductId = "com.colorbynumbers.monthly"
    static let yearlyProductId = "com.colorbynumbers.yearly"

    private var updateListenerTask: Task<Void, Error>?

    init() {
        updateListenerTask = listenForTransactions()
        Task { await loadProducts() }
        Task { await updateSubscriptionStatus() }
    }

    deinit {
        updateListenerTask?.cancel()
    }

    // MARK: - Load Products

    func loadProducts() async {
        isLoading = true
        do {
            let productIds = [
                Self.weeklyProductId,
                Self.monthlyProductId,
                Self.yearlyProductId
            ]
            products = try await Product.products(for: productIds)
            products.sort { $0.price < $1.price }
        } catch {
            purchaseError = "Failed to load subscription options."
        }
        isLoading = false
    }

    // MARK: - Purchase

    func purchase(_ product: Product) async -> Bool {
        isLoading = true
        purchaseError = nil

        do {
            let result = try await product.purchase()

            switch result {
            case .success(let verification):
                let transaction = try checkVerified(verification)
                await transaction.finish()
                await updateSubscriptionStatus()
                isLoading = false
                return true

            case .userCancelled:
                isLoading = false
                return false

            case .pending:
                purchaseError = "Purchase is pending approval."
                isLoading = false
                return false

            @unknown default:
                isLoading = false
                return false
            }
        } catch {
            purchaseError = "Purchase failed. Please try again."
            isLoading = false
            return false
        }
    }

    // MARK: - Restore Purchases

    func restorePurchases() async {
        isLoading = true
        try? await AppStore.sync()
        await updateSubscriptionStatus()
        isLoading = false
    }

    // MARK: - Check Subscription Status

    func updateSubscriptionStatus() async {
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result {
                if transaction.productType == .autoRenewable {
                    isSubscribed = true
                    return
                }
            }
        }
        isSubscribed = false
    }

    // MARK: - Transaction Listener

    private func listenForTransactions() -> Task<Void, Error> {
        Task.detached {
            for await result in Transaction.updates {
                if let transaction = try? self.checkVerified(result) {
                    await transaction.finish()
                    await self.updateSubscriptionStatus()
                }
            }
        }
    }

    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreError.failedVerification
        case .verified(let safe):
            return safe
        }
    }

    // MARK: - Helper Properties

    var weeklyProduct: Product? {
        products.first { $0.id == Self.weeklyProductId }
    }

    var monthlyProduct: Product? {
        products.first { $0.id == Self.monthlyProductId }
    }

    var yearlyProduct: Product? {
        products.first { $0.id == Self.yearlyProductId }
    }

    func hasAccessTo(artwork: Artwork) -> Bool {
        artwork.isFree || isSubscribed
    }
}

enum StoreError: Error {
    case failedVerification
}

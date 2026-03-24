import SwiftUI

@main
struct ColorByNumbersApp: App {
    @StateObject private var subscriptionManager = SubscriptionManager()
    @StateObject private var artworkStore = ArtworkStore()
    @StateObject private var userProgress = UserProgress()
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    var body: some Scene {
        WindowGroup {
            if hasCompletedOnboarding {
                MainTabView()
                    .environmentObject(subscriptionManager)
                    .environmentObject(artworkStore)
                    .environmentObject(userProgress)
            } else {
                OnboardingView(hasCompletedOnboarding: $hasCompletedOnboarding)
                    .environmentObject(subscriptionManager)
            }
        }
    }
}

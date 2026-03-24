import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var artworkStore: ArtworkStore
    @EnvironmentObject var userProgress: UserProgress
    @EnvironmentObject var subscriptionManager: SubscriptionManager
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Gallery", systemImage: "square.grid.2x2.fill")
                }
                .tag(0)

            DailyView()
                .tabItem {
                    Label("Daily", systemImage: "calendar")
                }
                .tag(1)

            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(2)
        }
        .tint(.appPrimary)
    }
}

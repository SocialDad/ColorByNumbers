import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var userProgress: UserProgress
    @EnvironmentObject var subscriptionManager: SubscriptionManager
    @EnvironmentObject var artworkStore: ArtworkStore

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Stats card
                    statsCard

                    // Achievements
                    achievementsSection

                    // Completed artworks
                    completedSection

                    // Settings
                    settingsSection
                }
                .padding(.vertical, 16)
            }
            .background(Color.appBackground.ignoresSafeArea())
            .navigationTitle("Profile")
        }
    }

    // MARK: - Stats

    private var statsCard: some View {
        VStack(spacing: 16) {
            HStack(spacing: 20) {
                statItem(value: "\(userProgress.completedArtworks.count)", label: "Completed", color: .appSuccess)
                statItem(value: "\(userProgress.totalColorsPlaced)", label: "Colors Placed", color: .appPrimary)
                statItem(value: "\(userProgress.currentStreak)", label: "Day Streak", color: .appAccent)
            }

            // Subscription status
            HStack {
                Image(systemName: subscriptionManager.isSubscribed ? "crown.fill" : "crown")
                    .foregroundColor(.appGold)
                Text(subscriptionManager.isSubscribed ? "Premium Member" : "Free Plan")
                    .font(.subheadline.bold())
                    .foregroundColor(.appDark)
                Spacer()
                if !subscriptionManager.isSubscribed {
                    Text("Upgrade")
                        .font(.caption.bold())
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            LinearGradient(
                                colors: [.premiumGradientStart, .premiumGradientEnd],
                                startPoint: .leading, endPoint: .trailing
                            )
                        )
                        .cornerRadius(8)
                }
            }
        }
        .padding(20)
        .background(Color.appCard)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.05), radius: 8)
        .padding(.horizontal, 16)
    }

    private func statItem(value: String, label: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title2.bold())
                .foregroundColor(color)
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Achievements

    private var achievementsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Achievements")
                .font(.title3.bold())
                .foregroundColor(.appDark)
                .padding(.horizontal, 16)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                achievementBadge(
                    icon: "paintbrush.fill",
                    title: "First Color",
                    unlocked: userProgress.totalColorsPlaced > 0
                )
                achievementBadge(
                    icon: "star.fill",
                    title: "First Complete",
                    unlocked: userProgress.completedArtworks.count >= 1
                )
                achievementBadge(
                    icon: "flame.fill",
                    title: "3 Day Streak",
                    unlocked: userProgress.currentStreak >= 3
                )
                achievementBadge(
                    icon: "trophy.fill",
                    title: "5 Artworks",
                    unlocked: userProgress.completedArtworks.count >= 5
                )
                achievementBadge(
                    icon: "sparkles",
                    title: "100 Colors",
                    unlocked: userProgress.totalColorsPlaced >= 100
                )
                achievementBadge(
                    icon: "crown.fill",
                    title: "7 Day Streak",
                    unlocked: userProgress.currentStreak >= 7
                )
            }
            .padding(.horizontal, 16)
        }
    }

    private func achievementBadge(icon: String, title: String, unlocked: Bool) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(unlocked ? .appGold : .gray.opacity(0.4))
            Text(title)
                .font(.caption2)
                .foregroundColor(unlocked ? .appDark : .secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(unlocked ? Color.appGold.opacity(0.1) : Color.gray.opacity(0.05))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(unlocked ? Color.appGold.opacity(0.3) : Color.clear, lineWidth: 1)
        )
    }

    // MARK: - Completed

    private var completedSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Completed Artworks")
                .font(.title3.bold())
                .foregroundColor(.appDark)
                .padding(.horizontal, 16)

            if userProgress.completedArtworks.isEmpty {
                HStack {
                    Spacer()
                    VStack(spacing: 8) {
                        Image(systemName: "photo.on.rectangle.angled")
                            .font(.largeTitle)
                            .foregroundColor(.secondary.opacity(0.5))
                        Text("No completed artworks yet")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("Start coloring to see your gallery grow!")
                            .font(.caption)
                            .foregroundColor(.secondary.opacity(0.7))
                    }
                    Spacer()
                }
                .padding(.vertical, 32)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 12) {
                        ForEach(userProgress.completedArtworks, id: \.self) { artworkId in
                            if let artwork = artworkStore.artwork(byId: artworkId) {
                                VStack(spacing: 6) {
                                    ArtworkPreviewGrid(artwork: artwork)
                                        .frame(width: 100, height: 100)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                    Text(artwork.title)
                                        .font(.caption2)
                                        .foregroundColor(.appDark)
                                        .lineLimit(1)
                                }
                                .frame(width: 100)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
        }
    }

    // MARK: - Settings

    private var settingsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Settings")
                .font(.title3.bold())
                .foregroundColor(.appDark)
                .padding(.horizontal, 16)

            VStack(spacing: 0) {
                settingsRow(icon: "bell.fill", title: "Notifications", color: .appAccent)
                Divider().padding(.leading, 48)
                settingsRow(icon: "questionmark.circle.fill", title: "Help & Support", color: .appPrimary)
                Divider().padding(.leading, 48)
                settingsRow(icon: "star.fill", title: "Rate the App", color: .appGold)
                Divider().padding(.leading, 48)
                settingsRow(icon: "arrow.counterclockwise", title: "Restore Purchases", color: .appSuccess)
            }
            .background(Color.appCard)
            .cornerRadius(16)
            .padding(.horizontal, 16)
        }
    }

    private func settingsRow(icon: String, title: String, color: Color) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 24)
            Text(title)
                .font(.subheadline)
                .foregroundColor(.appDark)
            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }
}

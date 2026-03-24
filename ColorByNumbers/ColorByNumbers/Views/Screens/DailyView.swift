import SwiftUI

struct DailyView: View {
    @EnvironmentObject var artworkStore: ArtworkStore
    @EnvironmentObject var userProgress: UserProgress

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    if let daily = artworkStore.dailyArtwork {
                        // Daily artwork hero
                        VStack(spacing: 16) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Today's Artwork")
                                        .font(.title2.bold())
                                        .foregroundColor(.appDark)
                                    Text(dateString())
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                Image(systemName: "calendar.badge.clock")
                                    .font(.title2)
                                    .foregroundColor(.appPrimary)
                            }
                            .padding(.horizontal, 24)

                            NavigationLink(value: daily.id) {
                                VStack(spacing: 12) {
                                    ArtworkPreviewGrid(artwork: daily)
                                        .frame(height: 280)
                                        .clipShape(RoundedRectangle(cornerRadius: 20))
                                        .shadow(color: .black.opacity(0.1), radius: 10, y: 4)

                                    Text(daily.title)
                                        .font(.headline)
                                        .foregroundColor(.appDark)

                                    HStack(spacing: 16) {
                                        Label(daily.difficulty.rawValue, systemImage: daily.difficulty.icon)
                                        Label("\(daily.colorCount) colors", systemImage: "paintpalette")
                                        Label("\(daily.totalRegions) regions", systemImage: "square.grid.3x3")
                                    }
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                }
                            }
                            .padding(.horizontal, 24)
                        }

                        // Streak
                        HStack(spacing: 16) {
                            VStack(spacing: 4) {
                                Text("\(userProgress.currentStreak)")
                                    .font(.title.bold())
                                    .foregroundColor(.appPrimary)
                                Text("Day Streak")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.appCard)
                            .cornerRadius(16)
                            .shadow(color: .black.opacity(0.05), radius: 4)

                            VStack(spacing: 4) {
                                Text("\(userProgress.completedArtworks.count)")
                                    .font(.title.bold())
                                    .foregroundColor(.appSuccess)
                                Text("Completed")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.appCard)
                            .cornerRadius(16)
                            .shadow(color: .black.opacity(0.05), radius: 4)

                            VStack(spacing: 4) {
                                Text("\(userProgress.totalColorsPlaced)")
                                    .font(.title.bold())
                                    .foregroundColor(.appAccent)
                                Text("Colors Placed")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.appCard)
                            .cornerRadius(16)
                            .shadow(color: .black.opacity(0.05), radius: 4)
                        }
                        .padding(.horizontal, 24)

                        // Easy picks section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Quick & Easy")
                                .font(.title3.bold())
                                .foregroundColor(.appDark)
                                .padding(.horizontal, 24)

                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHStack(spacing: 12) {
                                    ForEach(artworkStore.artworks(for: .easy)) { artwork in
                                        NavigationLink(value: artwork.id) {
                                            ArtworkCard(artwork: artwork)
                                        }
                                    }
                                }
                                .padding(.horizontal, 24)
                            }
                        }
                    }
                }
                .padding(.vertical, 16)
            }
            .background(Color.appBackground.ignoresSafeArea())
            .navigationTitle("Daily")
            .navigationDestination(for: String.self) { artworkId in
                if let artwork = artworkStore.artwork(byId: artworkId) {
                    ArtworkDetailView(artwork: artwork)
                }
            }
        }
    }

    private func dateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        return formatter.string(from: Date())
    }
}

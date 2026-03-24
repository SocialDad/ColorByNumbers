import SwiftUI

struct ArtworkDetailView: View {
    let artwork: Artwork
    @EnvironmentObject var userProgress: UserProgress
    @EnvironmentObject var subscriptionManager: SubscriptionManager
    @State private var navigateToColoring = false

    private var hasAccess: Bool {
        subscriptionManager.hasAccessTo(artwork: artwork)
    }

    private var progress: ColoringProgress? {
        userProgress.getProgress(for: artwork.id)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Preview
                ArtworkPreviewGrid(artwork: artwork)
                    .frame(height: 300)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(color: .black.opacity(0.1), radius: 10, y: 4)
                    .padding(.horizontal, 24)

                // Info
                VStack(spacing: 12) {
                    Text(artwork.title)
                        .font(.title2.bold())
                        .foregroundColor(.appDark)

                    HStack(spacing: 16) {
                        Label(artwork.category.rawValue, systemImage: artwork.category.icon)
                        Label(artwork.difficulty.rawValue, systemImage: artwork.difficulty.icon)
                        Label("\(artwork.colorCount) colors", systemImage: "paintpalette")
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                }

                // Progress if started
                if let p = progress, !p.filledRegions.isEmpty {
                    VStack(spacing: 8) {
                        let pct = Double(p.filledRegions.count) / Double(artwork.totalRegions)
                        HStack {
                            Text("Progress")
                                .font(.subheadline.bold())
                            Spacer()
                            Text("\(Int(pct * 100))%")
                                .font(.subheadline.bold())
                                .foregroundColor(.appPrimary)
                        }

                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.appPrimary.opacity(0.2))
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(
                                        LinearGradient(
                                            colors: [.appPrimary, .appSecondary],
                                            startPoint: .leading, endPoint: .trailing
                                        )
                                    )
                                    .frame(width: geo.size.width * pct)
                            }
                        }
                        .frame(height: 8)
                    }
                    .padding(.horizontal, 24)
                }

                // Color palette preview
                VStack(alignment: .leading, spacing: 8) {
                    Text("Colors")
                        .font(.subheadline.bold())
                        .foregroundColor(.appDark)

                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 6), spacing: 8) {
                        ForEach(artwork.palette) { color in
                            VStack(spacing: 2) {
                                Circle()
                                    .fill(color.color)
                                    .frame(width: 36, height: 36)
                                    .overlay(
                                        Text("\(color.id + 1)")
                                            .font(.caption2.bold())
                                            .foregroundColor(.white)
                                            .shadow(color: .black.opacity(0.5), radius: 1)
                                    )
                                Text(color.name)
                                    .font(.system(size: 8))
                                    .foregroundColor(.secondary)
                                    .lineLimit(1)
                            }
                        }
                    }
                }
                .padding(.horizontal, 24)

                Spacer(minLength: 20)
            }
            .padding(.top, 16)
        }
        .background(Color.appBackground.ignoresSafeArea())
        .safeAreaInset(edge: .bottom) {
            if hasAccess {
                NavigationLink {
                    ColoringCanvasView(artwork: artwork)
                } label: {
                    HStack {
                        Image(systemName: progress != nil ? "play.fill" : "paintbrush.fill")
                        Text(progress != nil ? "Continue Coloring" : "Start Coloring")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(
                            colors: [.appPrimary, .appSecondary],
                            startPoint: .leading, endPoint: .trailing
                        )
                    )
                    .cornerRadius(16)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 8)
                }
            } else {
                VStack(spacing: 8) {
                    HStack {
                        Image(systemName: "lock.fill")
                        Text("Premium Artwork")
                    }
                    .font(.subheadline.bold())
                    .foregroundColor(.appPrimary)

                    Text("Subscribe to unlock all artworks")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.appCard.shadow(color: .black.opacity(0.05), radius: 4, y: -2))
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

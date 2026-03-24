import SwiftUI

struct HomeView: View {
    @EnvironmentObject var artworkStore: ArtworkStore
    @EnvironmentObject var userProgress: UserProgress
    @EnvironmentObject var subscriptionManager: SubscriptionManager
    @State private var searchText = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Featured section
                    if !artworkStore.featuredArtworks.isEmpty {
                        sectionHeader("New & Featured", icon: "sparkles")
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack(spacing: 16) {
                                ForEach(artworkStore.featuredArtworks) { artwork in
                                    NavigationLink(value: artwork.id) {
                                        FeaturedArtworkCard(artwork: artwork)
                                    }
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                    }

                    // In progress
                    let inProgress = artworkStore.allArtworks.filter { artwork in
                        if let progress = userProgress.getProgress(for: artwork.id) {
                            return !progress.isCompleted && !progress.filledRegions.isEmpty
                        }
                        return false
                    }
                    if !inProgress.isEmpty {
                        sectionHeader("Continue Coloring", icon: "play.fill")
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack(spacing: 12) {
                                ForEach(inProgress) { artwork in
                                    NavigationLink(value: artwork.id) {
                                        ArtworkCard(artwork: artwork)
                                    }
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                    }

                    // Categories
                    ForEach(artworkStore.categories) { category in
                        let artworks = artworkStore.artworks(for: category)
                        if !artworks.isEmpty {
                            sectionHeader(category.rawValue, icon: category.icon)
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHStack(spacing: 12) {
                                    ForEach(artworks) { artwork in
                                        NavigationLink(value: artwork.id) {
                                            ArtworkCard(artwork: artwork)
                                        }
                                    }
                                }
                                .padding(.horizontal, 16)
                            }
                        }
                    }
                }
                .padding(.vertical, 16)
            }
            .background(Color.appBackground.ignoresSafeArea())
            .navigationTitle("Color by Numbers")
            .searchable(text: $searchText, prompt: "Search artworks")
            .navigationDestination(for: String.self) { artworkId in
                if let artwork = artworkStore.artwork(byId: artworkId) {
                    ArtworkDetailView(artwork: artwork)
                }
            }
        }
    }

    private func sectionHeader(_ title: String, icon: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .foregroundColor(.appPrimary)
                .font(.subheadline)
            Text(title)
                .font(.title3.bold())
                .foregroundColor(.appDark)
        }
        .padding(.horizontal, 16)
    }
}

// MARK: - Featured Card

struct FeaturedArtworkCard: View {
    let artwork: Artwork

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ArtworkPreviewGrid(artwork: artwork)
                .frame(width: 200, height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 16))

            Text(artwork.title)
                .font(.subheadline.bold())
                .foregroundColor(.appDark)

            HStack(spacing: 4) {
                Image(systemName: artwork.difficulty.icon)
                    .font(.caption2)
                Text(artwork.difficulty.rawValue)
                    .font(.caption)
                Spacer()
                if artwork.isNew {
                    Text("NEW")
                        .font(.caption2.bold())
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.appAccent)
                        .cornerRadius(4)
                }
            }
            .foregroundColor(.secondary)
        }
        .frame(width: 200)
    }
}

// MARK: - Standard Card

struct ArtworkCard: View {
    let artwork: Artwork
    @EnvironmentObject var userProgress: UserProgress

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            ZStack(alignment: .topTrailing) {
                ArtworkPreviewGrid(artwork: artwork)
                    .frame(width: 140, height: 140)
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                if !artwork.isFree {
                    Image(systemName: "lock.fill")
                        .font(.caption)
                        .foregroundColor(.white)
                        .padding(6)
                        .background(Color.black.opacity(0.5))
                        .clipShape(Circle())
                        .padding(6)
                }
            }

            Text(artwork.title)
                .font(.caption.bold())
                .foregroundColor(.appDark)
                .lineLimit(1)

            // Progress bar if started
            if let progress = userProgress.getProgress(for: artwork.id),
               !progress.filledRegions.isEmpty {
                let pct = Double(progress.filledRegions.count) / Double(artwork.totalRegions)
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color.appPrimary.opacity(0.2))
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color.appPrimary)
                            .frame(width: geo.size.width * pct)
                    }
                }
                .frame(height: 4)
            }
        }
        .frame(width: 140)
    }
}

// MARK: - Preview Grid

struct ArtworkPreviewGrid: View {
    let artwork: Artwork

    var body: some View {
        GeometryReader { geo in
            let cellW = geo.size.width / CGFloat(artwork.gridWidth)
            let cellH = geo.size.height / CGFloat(artwork.gridHeight)

            Canvas { context, _ in
                for (rowIndex, row) in artwork.thumbnailData.enumerated() {
                    for (colIndex, colorIdx) in row.enumerated() {
                        let color: Color = (colorIdx >= 0 && colorIdx < artwork.palette.count)
                            ? artwork.palette[colorIdx].color : .gray
                        let rect = CGRect(
                            x: CGFloat(colIndex) * cellW,
                            y: CGFloat(rowIndex) * cellH,
                            width: cellW + 0.5,
                            height: cellH + 0.5
                        )
                        context.fill(Path(rect), with: .color(color))
                    }
                }
            }
        }
    }
}

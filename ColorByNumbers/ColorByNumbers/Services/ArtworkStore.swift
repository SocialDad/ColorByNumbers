import SwiftUI

@MainActor
class ArtworkStore: ObservableObject {
    @Published var allArtworks: [Artwork] = []
    @Published var featuredArtworks: [Artwork] = []
    @Published var dailyArtwork: Artwork?
    @Published var categories: [ArtworkCategory] = ArtworkCategory.allCases

    init() {
        loadArtworks()
    }

    func loadArtworks() {
        allArtworks = ArtworkGenerator.generateAllArtworks()
        featuredArtworks = Array(allArtworks.filter { $0.isNew }.prefix(6))
        updateDailyArtwork()
    }

    func artworks(for category: ArtworkCategory) -> [Artwork] {
        allArtworks.filter { $0.category == category }
    }

    func freeArtworks() -> [Artwork] {
        allArtworks.filter { $0.isFree }
    }

    func artwork(byId id: String) -> Artwork? {
        allArtworks.first { $0.id == id }
    }

    func artworks(for difficulty: ArtworkDifficulty) -> [Artwork] {
        allArtworks.filter { $0.difficulty == difficulty }
    }

    func searchArtworks(query: String) -> [Artwork] {
        guard !query.isEmpty else { return allArtworks }
        let lowered = query.lowercased()
        return allArtworks.filter {
            $0.title.lowercased().contains(lowered) ||
            $0.category.rawValue.lowercased().contains(lowered)
        }
    }

    private func updateDailyArtwork() {
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 0
        let index = dayOfYear % allArtworks.count
        dailyArtwork = allArtworks[index]
    }
}

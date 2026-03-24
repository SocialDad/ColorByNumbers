import SwiftUI

class UserProgress: ObservableObject {
    @Published var progress: [String: ColoringProgress] = [:]
    @Published var completedArtworks: [String] = []
    @Published var totalColorsPlaced: Int = 0
    @Published var currentStreak: Int = 0

    private let defaults = UserDefaults.standard
    private let progressKey = "coloringProgress"
    private let completedKey = "completedArtworks"
    private let colorsPlacedKey = "totalColorsPlaced"
    private let lastActiveKey = "lastActiveDate"

    init() {
        loadProgress()
        updateStreak()
    }

    // MARK: - Progress Management

    func getProgress(for artworkId: String) -> ColoringProgress? {
        progress[artworkId]
    }

    func startArtwork(_ artwork: Artwork) -> ColoringProgress {
        if let existing = progress[artwork.id] {
            return existing
        }
        let newProgress = ColoringProgress(
            id: artwork.id,
            filledRegions: [],
            startedAt: Date(),
            lastModified: Date(),
            isCompleted: false,
            timeSpentSeconds: 0
        )
        progress[artwork.id] = newProgress
        saveProgress()
        return newProgress
    }

    func fillRegion(artworkId: String, regionId: Int, totalRegions: Int) {
        guard var artworkProgress = progress[artworkId] else { return }
        artworkProgress.fillRegion(regionId)
        totalColorsPlaced += 1

        if artworkProgress.filledRegions.count >= totalRegions {
            artworkProgress.isCompleted = true
            if !completedArtworks.contains(artworkId) {
                completedArtworks.append(artworkId)
            }
        }

        progress[artworkId] = artworkProgress
        saveProgress()
    }

    func unfillRegion(artworkId: String, regionId: Int) {
        guard var artworkProgress = progress[artworkId] else { return }
        artworkProgress.filledRegions.remove(regionId)
        artworkProgress.isCompleted = false
        artworkProgress.lastModified = Date()
        completedArtworks.removeAll { $0 == artworkId }
        progress[artworkId] = artworkProgress
        saveProgress()
    }

    func completionPercentage(for artworkId: String, totalRegions: Int) -> Double {
        guard let artworkProgress = progress[artworkId], totalRegions > 0 else { return 0 }
        return Double(artworkProgress.filledRegions.count) / Double(totalRegions) * 100
    }

    func isRegionFilled(artworkId: String, regionId: Int) -> Bool {
        progress[artworkId]?.filledRegions.contains(regionId) ?? false
    }

    // MARK: - Streak

    private func updateStreak() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        if let lastActive = defaults.object(forKey: lastActiveKey) as? Date {
            let lastActiveDay = calendar.startOfDay(for: lastActive)
            let daysDiff = calendar.dateComponents([.day], from: lastActiveDay, to: today).day ?? 0

            if daysDiff == 1 {
                currentStreak += 1
            } else if daysDiff > 1 {
                currentStreak = 1
            }
        } else {
            currentStreak = 1
        }

        defaults.set(today, forKey: lastActiveKey)
        defaults.set(currentStreak, forKey: "currentStreak")
    }

    // MARK: - Persistence

    private func saveProgress() {
        if let data = try? JSONEncoder().encode(progress) {
            defaults.set(data, forKey: progressKey)
        }
        defaults.set(completedArtworks, forKey: completedKey)
        defaults.set(totalColorsPlaced, forKey: colorsPlacedKey)
    }

    private func loadProgress() {
        if let data = defaults.data(forKey: progressKey),
           let decoded = try? JSONDecoder().decode([String: ColoringProgress].self, from: data) {
            progress = decoded
        }
        completedArtworks = defaults.stringArray(forKey: completedKey) ?? []
        totalColorsPlaced = defaults.integer(forKey: colorsPlacedKey)
        currentStreak = defaults.integer(forKey: "currentStreak")
    }
}

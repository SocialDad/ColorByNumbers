import SwiftUI
import Combine

@MainActor
class ColoringViewModel: ObservableObject {
    let artwork: Artwork

    @Published var selectedColorIndex: Int = 0
    @Published var filledRegions: Set<Int> = []
    @Published var isCompleted = false
    @Published var showCompletion = false
    @Published var scale: CGFloat = 1.0
    @Published var offset: CGSize = .zero

    // Maps grid cell (row, col) -> region ID for fast tap lookup
    private var cellToRegion: [String: Int] = [:]
    // Maps region ID -> color index
    private var regionColorMap: [Int: Int] = [:]

    private var userProgress: UserProgress?

    init(artwork: Artwork) {
        self.artwork = artwork

        // Build lookup tables
        for region in artwork.regions {
            regionColorMap[region.id] = region.colorIndex
            if let cells = region.gridCells {
                for cell in cells {
                    cellToRegion["\(cell.row),\(cell.col)"] = region.id
                }
            }
        }
    }

    func setup(userProgress: UserProgress) {
        self.userProgress = userProgress
        let progress = userProgress.startArtwork(artwork)
        filledRegions = progress.filledRegions
        isCompleted = progress.isCompleted

        // Auto-select first unfilled color
        selectNextUnfilledColor()
    }

    // MARK: - Actions

    func tapCell(row: Int, col: Int) {
        guard let regionId = cellToRegion["\(row),\(col)"] else { return }
        guard let colorIndex = regionColorMap[regionId] else { return }

        // Only fill if correct color is selected
        guard colorIndex == selectedColorIndex else {
            HapticManager.shared.error()
            return
        }

        // Already filled
        guard !filledRegions.contains(regionId) else { return }

        filledRegions.insert(regionId)
        userProgress?.fillRegion(artworkId: artwork.id, regionId: regionId, totalRegions: artwork.totalRegions)
        HapticManager.shared.colorPlaced()

        // Check if all regions of this color are done
        let allOfColor = artwork.regions.filter { $0.colorIndex == selectedColorIndex }
        let allFilled = allOfColor.allSatisfy { filledRegions.contains($0.id) }
        if allFilled {
            HapticManager.shared.regionCompleted()
            // Auto-advance to next unfilled color
            selectNextUnfilledColor()
        }

        // Check completion
        if filledRegions.count >= artwork.totalRegions {
            isCompleted = true
            HapticManager.shared.artworkCompleted()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    self.showCompletion = true
                }
            }
        }
    }

    func selectColor(_ index: Int) {
        selectedColorIndex = index
        HapticManager.shared.colorSelected()
    }

    func undoRegion(_ regionId: Int) {
        filledRegions.remove(regionId)
        userProgress?.unfillRegion(artworkId: artwork.id, regionId: regionId)
        isCompleted = false
        showCompletion = false
    }

    // MARK: - Queries

    func isRegionFilled(_ regionId: Int) -> Bool {
        filledRegions.contains(regionId)
    }

    func regionId(at row: Int, col: Int) -> Int? {
        cellToRegion["\(row),\(col)"]
    }

    func colorIndex(for regionId: Int) -> Int? {
        regionColorMap[regionId]
    }

    func regionsForSelectedColor() -> [ColorRegion] {
        artwork.regions.filter { $0.colorIndex == selectedColorIndex && !filledRegions.contains($0.id) }
    }

    func filledCount(for colorIndex: Int) -> Int {
        artwork.regions.filter { $0.colorIndex == colorIndex && filledRegions.contains($0.id) }.count
    }

    func totalCount(for colorIndex: Int) -> Int {
        artwork.regions.filter { $0.colorIndex == colorIndex }.count
    }

    func completionPercentage() -> Double {
        guard artwork.totalRegions > 0 else { return 0 }
        return Double(filledRegions.count) / Double(artwork.totalRegions)
    }

    // MARK: - Private

    private func selectNextUnfilledColor() {
        for (index, _) in artwork.palette.enumerated() {
            let regionsOfColor = artwork.regions.filter { $0.colorIndex == index }
            let allFilled = regionsOfColor.allSatisfy { filledRegions.contains($0.id) }
            if !allFilled {
                selectedColorIndex = index
                return
            }
        }
    }
}

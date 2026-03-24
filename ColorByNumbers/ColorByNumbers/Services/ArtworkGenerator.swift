import SwiftUI

struct ArtworkGenerator {

    // MARK: - Public API

    static func generateAllArtworks() -> [Artwork] {
        var artworks: [Artwork] = []

        artworks.append(contentsOf: generateNatureArtworks())
        artworks.append(contentsOf: generateAnimalArtworks())
        artworks.append(contentsOf: generateFoodArtworks())
        artworks.append(contentsOf: generateFantasyArtworks())
        artworks.append(contentsOf: generateMandalaArtworks())
        artworks.append(contentsOf: generateVehicleArtworks())
        artworks.append(contentsOf: generateHolidayArtworks())
        artworks.append(contentsOf: generateSceneryArtworks())

        return artworks
    }

    // MARK: - Nature

    private static func generateNatureArtworks() -> [Artwork] {
        let sunsetPalette = makePalette([
            ("FF6B35", "Sunset Orange"),
            ("F7C948", "Golden Sun"),
            ("004E89", "Deep Sky"),
            ("1A936F", "Forest Green"),
            ("88D498", "Light Green"),
            ("2D3436", "Dark Ground"),
        ])

        // 10x10 sunset landscape
        let sunsetGrid: [[Int]] = [
            [2, 2, 2, 1, 1, 1, 1, 2, 2, 2],
            [2, 2, 1, 1, 0, 0, 1, 1, 2, 2],
            [2, 1, 0, 0, 0, 0, 0, 0, 1, 2],
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
            [3, 3, 4, 3, 3, 3, 4, 3, 3, 3],
            [3, 4, 4, 3, 3, 4, 4, 4, 3, 3],
            [3, 3, 4, 4, 3, 3, 4, 3, 3, 3],
            [5, 5, 5, 5, 5, 5, 5, 5, 5, 5],
            [5, 5, 5, 5, 5, 5, 5, 5, 5, 5],
        ]

        let flowerPalette = makePalette([
            ("E84393", "Rose Pink"),
            ("FD79A8", "Light Pink"),
            ("00B894", "Stem Green"),
            ("55EFC4", "Light Green"),
            ("FDCB6E", "Pollen Yellow"),
            ("6C5CE7", "Lavender"),
            ("DFE6E9", "Background"),
        ])

        let flowerGrid: [[Int]] = [
            [6, 6, 6, 4, 4, 6, 6, 6, 6, 6],
            [6, 6, 1, 0, 0, 1, 6, 5, 5, 6],
            [6, 1, 0, 4, 0, 0, 6, 5, 5, 6],
            [6, 1, 0, 0, 4, 0, 1, 6, 6, 6],
            [6, 6, 1, 0, 0, 1, 6, 6, 6, 6],
            [6, 6, 6, 2, 2, 6, 6, 6, 6, 6],
            [6, 6, 3, 2, 2, 3, 6, 6, 6, 6],
            [6, 3, 6, 2, 2, 6, 3, 6, 6, 6],
            [6, 6, 6, 2, 2, 6, 6, 6, 6, 6],
            [6, 6, 6, 2, 2, 6, 6, 6, 6, 6],
        ]

        return [
            buildArtwork(id: "nature_sunset", title: "Golden Sunset", category: .nature,
                         difficulty: .easy, isFree: true, isNew: true,
                         grid: sunsetGrid, palette: sunsetPalette),
            buildArtwork(id: "nature_flower", title: "Rose Garden", category: .nature,
                         difficulty: .medium, isFree: true, isNew: false,
                         grid: flowerGrid, palette: flowerPalette),
        ]
    }

    // MARK: - Animals

    private static func generateAnimalArtworks() -> [Artwork] {
        let catPalette = makePalette([
            ("F39C12", "Orange Fur"),
            ("E67E22", "Dark Orange"),
            ("2D3436", "Black"),
            ("FDCB6E", "Light Orange"),
            ("55EFC4", "Green Eyes"),
            ("DFE6E9", "Background"),
        ])

        let catGrid: [[Int]] = [
            [5, 0, 5, 5, 5, 5, 5, 5, 0, 5],
            [5, 0, 0, 5, 5, 5, 5, 0, 0, 5],
            [5, 0, 0, 0, 0, 0, 0, 0, 0, 5],
            [5, 0, 4, 0, 0, 0, 0, 4, 0, 5],
            [5, 0, 0, 0, 2, 2, 0, 0, 0, 5],
            [5, 1, 0, 0, 0, 0, 0, 0, 1, 5],
            [5, 1, 1, 0, 2, 0, 0, 1, 1, 5],
            [5, 5, 1, 1, 0, 0, 1, 1, 5, 5],
            [5, 5, 5, 1, 1, 1, 1, 5, 5, 5],
            [5, 5, 5, 5, 1, 1, 5, 5, 5, 5],
        ]

        let fishPalette = makePalette([
            ("0984E3", "Ocean Blue"),
            ("74B9FF", "Light Blue"),
            ("F39C12", "Fish Orange"),
            ("E17055", "Fish Red"),
            ("FDCB6E", "Fish Yellow"),
            ("DFE6E9", "Fin White"),
            ("00CEC9", "Teal Water"),
        ])

        let fishGrid: [[Int]] = [
            [0, 0, 1, 1, 0, 0, 0, 1, 1, 0],
            [0, 1, 1, 6, 6, 1, 1, 6, 1, 0],
            [0, 1, 3, 3, 4, 4, 2, 6, 6, 0],
            [5, 3, 3, 2, 4, 4, 2, 2, 6, 5],
            [3, 3, 2, 2, 4, 4, 2, 2, 2, 5],
            [5, 3, 3, 2, 4, 4, 2, 2, 6, 5],
            [0, 1, 3, 3, 4, 4, 2, 6, 6, 0],
            [0, 1, 1, 6, 6, 1, 1, 6, 1, 0],
            [0, 0, 1, 1, 0, 0, 0, 1, 1, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        ]

        let butterflyPalette = makePalette([
            ("6C5CE7", "Purple"),
            ("A29BFE", "Light Purple"),
            ("FD79A8", "Pink"),
            ("E84393", "Deep Pink"),
            ("2D3436", "Body Black"),
            ("FDCB6E", "Yellow Spots"),
            ("DFE6E9", "Background"),
        ])

        let butterflyGrid: [[Int]] = [
            [6, 6, 0, 1, 6, 6, 1, 0, 6, 6],
            [6, 0, 1, 5, 1, 1, 5, 1, 0, 6],
            [0, 1, 2, 5, 1, 1, 5, 2, 1, 0],
            [0, 1, 2, 3, 4, 4, 3, 2, 1, 0],
            [6, 0, 1, 1, 4, 4, 1, 1, 0, 6],
            [6, 0, 1, 1, 4, 4, 1, 1, 0, 6],
            [0, 1, 2, 3, 4, 4, 3, 2, 1, 0],
            [0, 1, 2, 5, 1, 1, 5, 2, 1, 0],
            [6, 0, 1, 5, 1, 1, 5, 1, 0, 6],
            [6, 6, 0, 1, 6, 6, 1, 0, 6, 6],
        ]

        return [
            buildArtwork(id: "animal_cat", title: "Orange Tabby", category: .animals,
                         difficulty: .easy, isFree: true, isNew: true,
                         grid: catGrid, palette: catPalette),
            buildArtwork(id: "animal_fish", title: "Tropical Fish", category: .animals,
                         difficulty: .medium, isFree: true, isNew: false,
                         grid: fishGrid, palette: fishPalette),
            buildArtwork(id: "animal_butterfly", title: "Butterfly Wings", category: .animals,
                         difficulty: .medium, isFree: false, isNew: true,
                         grid: butterflyGrid, palette: butterflyPalette),
        ]
    }

    // MARK: - Food

    private static func generateFoodArtworks() -> [Artwork] {
        let cupcakePalette = makePalette([
            ("E84393", "Frosting Pink"),
            ("FD79A8", "Light Pink"),
            ("D63031", "Cherry Red"),
            ("FDCB6E", "Cake Yellow"),
            ("E17055", "Cake Orange"),
            ("FFEAA7", "Wrapper Cream"),
            ("DFE6E9", "Background"),
        ])

        let cupcakeGrid: [[Int]] = [
            [6, 6, 6, 6, 2, 6, 6, 6, 6, 6],
            [6, 6, 6, 0, 0, 0, 6, 6, 6, 6],
            [6, 6, 0, 1, 0, 1, 0, 6, 6, 6],
            [6, 0, 1, 0, 1, 0, 1, 0, 6, 6],
            [6, 0, 0, 0, 0, 0, 0, 0, 6, 6],
            [6, 6, 3, 3, 3, 3, 3, 6, 6, 6],
            [6, 6, 5, 4, 4, 4, 5, 6, 6, 6],
            [6, 6, 6, 5, 4, 5, 6, 6, 6, 6],
            [6, 6, 6, 5, 5, 5, 6, 6, 6, 6],
            [6, 6, 6, 6, 6, 6, 6, 6, 6, 6],
        ]

        return [
            buildArtwork(id: "food_cupcake", title: "Sweet Cupcake", category: .food,
                         difficulty: .medium, isFree: true, isNew: false,
                         grid: cupcakeGrid, palette: cupcakePalette),
        ]
    }

    // MARK: - Fantasy

    private static func generateFantasyArtworks() -> [Artwork] {
        let dragonPalette = makePalette([
            ("D63031", "Dragon Red"),
            ("E17055", "Light Red"),
            ("FDCB6E", "Gold"),
            ("F39C12", "Orange"),
            ("2D3436", "Dark"),
            ("636E72", "Gray"),
            ("B2BEC3", "Light Gray"),
        ])

        let dragonGrid: [[Int]] = [
            [6, 6, 6, 0, 6, 6, 0, 6, 6, 6],
            [6, 6, 0, 0, 0, 0, 0, 0, 6, 6],
            [6, 0, 1, 4, 0, 0, 4, 1, 0, 6],
            [6, 0, 0, 0, 0, 0, 0, 0, 0, 6],
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 1, 0, 2, 2, 2, 2, 0, 1, 0],
            [6, 0, 0, 0, 0, 0, 0, 0, 0, 6],
            [6, 6, 0, 0, 3, 3, 0, 0, 6, 6],
            [6, 6, 6, 0, 0, 0, 0, 6, 6, 6],
            [6, 6, 6, 6, 5, 5, 6, 6, 6, 6],
        ]

        let unicornPalette = makePalette([
            ("DFE6E9", "White Body"),
            ("FD79A8", "Pink Mane"),
            ("A29BFE", "Purple Mane"),
            ("FDCB6E", "Gold Horn"),
            ("6C5CE7", "Deep Purple"),
            ("2D3436", "Eye Black"),
            ("B2BEC3", "Background"),
        ])

        let unicornGrid: [[Int]] = [
            [6, 6, 6, 3, 6, 6, 6, 6, 6, 6],
            [6, 6, 3, 3, 1, 2, 6, 6, 6, 6],
            [6, 6, 0, 0, 1, 2, 4, 6, 6, 6],
            [6, 0, 0, 5, 0, 1, 2, 6, 6, 6],
            [6, 0, 0, 0, 0, 0, 1, 2, 6, 6],
            [6, 6, 0, 0, 0, 0, 0, 0, 6, 6],
            [6, 0, 6, 0, 0, 0, 0, 6, 0, 6],
            [6, 0, 6, 0, 0, 0, 0, 6, 0, 6],
            [6, 0, 6, 0, 6, 6, 0, 6, 0, 6],
            [6, 0, 6, 0, 6, 6, 0, 6, 0, 6],
        ]

        return [
            buildArtwork(id: "fantasy_dragon", title: "Fire Dragon", category: .fantasy,
                         difficulty: .medium, isFree: false, isNew: true,
                         grid: dragonGrid, palette: dragonPalette),
            buildArtwork(id: "fantasy_unicorn", title: "Magical Unicorn", category: .fantasy,
                         difficulty: .medium, isFree: true, isNew: true,
                         grid: unicornGrid, palette: unicornPalette),
        ]
    }

    // MARK: - Mandala

    private static func generateMandalaArtworks() -> [Artwork] {
        let mandalaPalette = makePalette([
            ("6C5CE7", "Deep Purple"),
            ("A29BFE", "Light Purple"),
            ("FD79A8", "Pink"),
            ("FDCB6E", "Gold"),
            ("00B894", "Teal"),
            ("DFE6E9", "Background"),
        ])

        let mandalaGrid: [[Int]] = [
            [5, 5, 0, 1, 3, 3, 1, 0, 5, 5],
            [5, 0, 4, 1, 2, 2, 1, 4, 0, 5],
            [0, 4, 1, 3, 2, 2, 3, 1, 4, 0],
            [1, 1, 3, 0, 3, 3, 0, 3, 1, 1],
            [3, 2, 2, 3, 0, 0, 3, 2, 2, 3],
            [3, 2, 2, 3, 0, 0, 3, 2, 2, 3],
            [1, 1, 3, 0, 3, 3, 0, 3, 1, 1],
            [0, 4, 1, 3, 2, 2, 3, 1, 4, 0],
            [5, 0, 4, 1, 2, 2, 1, 4, 0, 5],
            [5, 5, 0, 1, 3, 3, 1, 0, 5, 5],
        ]

        return [
            buildArtwork(id: "mandala_classic", title: "Classic Mandala", category: .mandala,
                         difficulty: .easy, isFree: true, isNew: false,
                         grid: mandalaGrid, palette: mandalaPalette),
        ]
    }

    // MARK: - Vehicles

    private static func generateVehicleArtworks() -> [Artwork] {
        let carPalette = makePalette([
            ("D63031", "Car Red"),
            ("2D3436", "Tire Black"),
            ("636E72", "Window Gray"),
            ("B2BEC3", "Chrome"),
            ("FDCB6E", "Headlight"),
            ("74B9FF", "Sky Blue"),
        ])

        let carGrid: [[Int]] = [
            [5, 5, 5, 5, 5, 5, 5, 5, 5, 5],
            [5, 5, 5, 5, 5, 5, 5, 5, 5, 5],
            [5, 5, 2, 2, 2, 2, 2, 5, 5, 5],
            [5, 2, 2, 2, 2, 2, 2, 2, 5, 5],
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 4],
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 3, 0, 0, 0, 0, 0, 0, 3, 0],
            [3, 1, 3, 3, 3, 3, 3, 3, 1, 3],
            [5, 1, 1, 5, 5, 5, 5, 1, 1, 5],
            [5, 5, 5, 5, 5, 5, 5, 5, 5, 5],
        ]

        return [
            buildArtwork(id: "vehicle_car", title: "Red Racer", category: .vehicles,
                         difficulty: .easy, isFree: true, isNew: false,
                         grid: carGrid, palette: carPalette),
        ]
    }

    // MARK: - Holidays

    private static func generateHolidayArtworks() -> [Artwork] {
        let treePalette = makePalette([
            ("27AE60", "Tree Green"),
            ("2ECC71", "Light Green"),
            ("E74C3C", "Ornament Red"),
            ("F1C40F", "Star Gold"),
            ("8B4513", "Trunk Brown"),
            ("FDCB6E", "Ornament Gold"),
            ("DFE6E9", "Background"),
        ])

        let treeGrid: [[Int]] = [
            [6, 6, 6, 6, 3, 6, 6, 6, 6, 6],
            [6, 6, 6, 0, 3, 0, 6, 6, 6, 6],
            [6, 6, 0, 1, 2, 1, 0, 6, 6, 6],
            [6, 0, 1, 0, 5, 0, 1, 0, 6, 6],
            [6, 6, 0, 2, 0, 1, 0, 6, 6, 6],
            [6, 0, 1, 0, 5, 0, 2, 0, 6, 6],
            [0, 1, 0, 2, 0, 1, 0, 5, 0, 6],
            [6, 6, 6, 6, 4, 6, 6, 6, 6, 6],
            [6, 6, 6, 6, 4, 6, 6, 6, 6, 6],
            [6, 6, 6, 4, 4, 4, 6, 6, 6, 6],
        ]

        return [
            buildArtwork(id: "holiday_tree", title: "Christmas Tree", category: .holidays,
                         difficulty: .medium, isFree: false, isNew: true,
                         grid: treeGrid, palette: treePalette),
        ]
    }

    // MARK: - Scenery

    private static func generateSceneryArtworks() -> [Artwork] {
        let beachPalette = makePalette([
            ("0984E3", "Ocean Blue"),
            ("74B9FF", "Light Blue"),
            ("FFEAA7", "Sand Yellow"),
            ("FDCB6E", "Dark Sand"),
            ("F39C12", "Sun Orange"),
            ("00CEC9", "Teal Water"),
            ("E17055", "Coral"),
        ])

        let beachGrid: [[Int]] = [
            [1, 1, 1, 1, 4, 4, 1, 1, 1, 1],
            [1, 1, 1, 4, 4, 4, 4, 1, 1, 1],
            [1, 1, 1, 1, 4, 4, 1, 1, 1, 1],
            [0, 0, 5, 0, 0, 0, 0, 5, 0, 0],
            [0, 5, 0, 0, 0, 0, 0, 0, 5, 0],
            [5, 0, 0, 0, 0, 0, 0, 0, 0, 5],
            [2, 2, 3, 2, 2, 2, 3, 2, 2, 2],
            [2, 3, 3, 3, 2, 3, 3, 3, 2, 2],
            [3, 3, 6, 3, 3, 3, 6, 3, 3, 3],
            [3, 3, 3, 3, 3, 3, 3, 3, 3, 3],
        ]

        let mountainPalette = makePalette([
            ("636E72", "Mountain Gray"),
            ("B2BEC3", "Light Gray"),
            ("DFE6E9", "Snow White"),
            ("2D3436", "Dark Peak"),
            ("00B894", "Forest Green"),
            ("55EFC4", "Light Green"),
            ("74B9FF", "Sky Blue"),
        ])

        let mountainGrid: [[Int]] = [
            [6, 6, 6, 6, 6, 6, 6, 6, 6, 6],
            [6, 6, 6, 6, 2, 6, 6, 6, 6, 6],
            [6, 6, 6, 3, 2, 3, 6, 6, 2, 6],
            [6, 6, 3, 0, 1, 0, 3, 1, 0, 6],
            [6, 3, 0, 0, 1, 0, 0, 0, 0, 6],
            [6, 0, 0, 0, 0, 0, 0, 0, 0, 6],
            [4, 4, 5, 4, 4, 5, 4, 4, 5, 4],
            [4, 5, 5, 5, 4, 5, 5, 4, 5, 5],
            [4, 4, 5, 4, 4, 4, 5, 5, 4, 4],
            [4, 4, 4, 4, 4, 4, 4, 4, 4, 4],
        ]

        return [
            buildArtwork(id: "scenery_beach", title: "Sunset Beach", category: .scenery,
                         difficulty: .medium, isFree: true, isNew: false,
                         grid: beachGrid, palette: beachPalette),
            buildArtwork(id: "scenery_mountain", title: "Mountain Peaks", category: .scenery,
                         difficulty: .medium, isFree: false, isNew: false,
                         grid: mountainGrid, palette: mountainPalette),
        ]
    }

    // MARK: - Helpers

    private static func makePalette(_ entries: [(String, String)]) -> [PaletteColor] {
        entries.enumerated().map { index, entry in
            PaletteColor(id: index, hex: entry.0, name: entry.1)
        }
    }

    private static func buildArtwork(
        id: String, title: String, category: ArtworkCategory,
        difficulty: ArtworkDifficulty, isFree: Bool, isNew: Bool,
        grid: [[Int]], palette: [PaletteColor]
    ) -> Artwork {
        let height = grid.count
        let width = grid[0].count
        let regions = buildRegions(from: grid, width: width, height: height)

        return Artwork(
            id: id,
            title: title,
            category: category,
            difficulty: difficulty,
            isFree: isFree,
            isNew: isNew,
            gridWidth: width,
            gridHeight: height,
            regions: regions,
            palette: palette,
            thumbnailData: grid
        )
    }

    /// Groups contiguous cells of the same color index into regions using flood-fill.
    private static func buildRegions(from grid: [[Int]], width: Int, height: Int) -> [ColorRegion] {
        var visited = Array(repeating: Array(repeating: false, count: width), count: height)
        var regions: [ColorRegion] = []
        var regionId = 0

        for row in 0..<height {
            for col in 0..<width {
                guard !visited[row][col] else { continue }
                let colorIndex = grid[row][col]
                var cells: [ColorRegion.GridCell] = []
                var pathPoints: [CGPoint] = []

                // BFS flood-fill
                var queue: [(Int, Int)] = [(row, col)]
                visited[row][col] = true

                while !queue.isEmpty {
                    let (r, c) = queue.removeFirst()
                    cells.append(ColorRegion.GridCell(row: r, col: c))
                    pathPoints.append(CGPoint(x: Double(c), y: Double(r)))

                    for (dr, dc) in [(0, 1), (0, -1), (1, 0), (-1, 0)] {
                        let nr = r + dr
                        let nc = c + dc
                        if nr >= 0 && nr < height && nc >= 0 && nc < width
                            && !visited[nr][nc] && grid[nr][nc] == colorIndex {
                            visited[nr][nc] = true
                            queue.append((nr, nc))
                        }
                    }
                }

                // Center of mass for number label
                let avgX = pathPoints.map(\.x).reduce(0, +) / Double(pathPoints.count)
                let avgY = pathPoints.map(\.y).reduce(0, +) / Double(pathPoints.count)

                regions.append(ColorRegion(
                    id: regionId,
                    colorIndex: colorIndex,
                    path: pathPoints,
                    numberPosition: CGPoint(x: avgX, y: avgY),
                    isFilled: false,
                    gridCells: cells
                ))
                regionId += 1
            }
        }
        return regions
    }
}

import SwiftUI

// MARK: - Artwork Category
enum ArtworkCategory: String, CaseIterable, Identifiable, Codable {
    case nature = "Nature"
    case animals = "Animals"
    case characters = "Characters"
    case food = "Food & Drinks"
    case music = "Music"
    case scenery = "Scenery"
    case makeup = "Beauty & Makeup"
    case sports = "Sports"
    case mandala = "Mandala"
    case holidays = "Holidays"
    case fantasy = "Fantasy"
    case vehicles = "Vehicles"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .nature: return "leaf.fill"
        case .animals: return "pawprint.fill"
        case .characters: return "person.fill"
        case .food: return "fork.knife"
        case .music: return "music.note"
        case .scenery: return "mountain.2.fill"
        case .makeup: return "paintpalette.fill"
        case .sports: return "sportscourt.fill"
        case .mandala: return "circle.hexagongrid.fill"
        case .holidays: return "gift.fill"
        case .fantasy: return "sparkles"
        case .vehicles: return "car.fill"
        }
    }

    var gradient: [Color] {
        switch self {
        case .nature: return [Color(hex: "43A047"), Color(hex: "66BB6A")]
        case .animals: return [Color(hex: "F4511E"), Color(hex: "FF7043")]
        case .characters: return [Color(hex: "5C6BC0"), Color(hex: "7986CB")]
        case .food: return [Color(hex: "FB8C00"), Color(hex: "FFA726")]
        case .music: return [Color(hex: "8E24AA"), Color(hex: "AB47BC")]
        case .scenery: return [Color(hex: "0097A7"), Color(hex: "26C6DA")]
        case .makeup: return [Color(hex: "EC407A"), Color(hex: "F48FB1")]
        case .sports: return [Color(hex: "2E7D32"), Color(hex: "4CAF50")]
        case .mandala: return [Color(hex: "6A1B9A"), Color(hex: "9C27B0")]
        case .holidays: return [Color(hex: "C62828"), Color(hex: "EF5350")]
        case .fantasy: return [Color(hex: "283593"), Color(hex: "5C6BC0")]
        case .vehicles: return [Color(hex: "37474F"), Color(hex: "78909C")]
        }
    }
}

// MARK: - Difficulty
enum ArtworkDifficulty: String, CaseIterable, Codable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
    case expert = "Expert"

    var colorCount: ClosedRange<Int> {
        switch self {
        case .easy: return 5...8
        case .medium: return 9...15
        case .hard: return 16...24
        case .expert: return 25...36
        }
    }

    var icon: String {
        switch self {
        case .easy: return "star"
        case .medium: return "star.leadinghalf.filled"
        case .hard: return "star.fill"
        case .expert: return "star.circle.fill"
        }
    }
}

// MARK: - Color Region
struct ColorRegion: Identifiable, Codable, Equatable {
    let id: Int
    let colorIndex: Int
    let path: [CGPoint]
    let numberPosition: CGPoint
    var isFilled: Bool = false

    // For simple grid-based regions
    let gridCells: [GridCell]?

    struct GridCell: Codable, Equatable {
        let row: Int
        let col: Int
    }

    static func == (lhs: ColorRegion, rhs: ColorRegion) -> Bool {
        lhs.id == rhs.id && lhs.isFilled == rhs.isFilled
    }
}

// MARK: - Color Palette
struct ColorPalette: Identifiable, Codable {
    let id: String
    let name: String
    let colors: [PaletteColor]
    let isPremium: Bool
}

struct PaletteColor: Identifiable, Codable, Equatable {
    let id: Int
    let hex: String
    let name: String

    var color: Color {
        Color(hex: hex)
    }
}

// MARK: - Artwork
struct Artwork: Identifiable, Codable {
    let id: String
    let title: String
    let category: ArtworkCategory
    let difficulty: ArtworkDifficulty
    let isFree: Bool
    let isNew: Bool
    let gridWidth: Int
    let gridHeight: Int
    let regions: [ColorRegion]
    let palette: [PaletteColor]
    let thumbnailData: [[Int]] // Grid of color indices for preview

    var totalRegions: Int { regions.count }
    var colorCount: Int { palette.count }

    // Computed preview image from grid data
    var previewColors: [[Color]] {
        thumbnailData.map { row in
            row.map { index in
                if index >= 0 && index < palette.count {
                    return palette[index].color
                }
                return .gray
            }
        }
    }
}

// MARK: - Coloring Progress
struct ColoringProgress: Codable, Identifiable {
    let id: String // Same as artwork ID
    var filledRegions: Set<Int>
    var startedAt: Date
    var lastModified: Date
    var isCompleted: Bool
    var timeSpentSeconds: Int

    var completionPercentage: Double {
        guard filledRegions.count > 0 else { return 0 }
        return Double(filledRegions.count)
    }

    mutating func fillRegion(_ regionId: Int) {
        filledRegions.insert(regionId)
        lastModified = Date()
    }
}

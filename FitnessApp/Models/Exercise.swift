import Foundation
import SwiftData

// Static exercise definition (not stored in SwiftData - seeded from JSON)
struct Exercise: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let muscleGroups: [MuscleGroup]
    let primaryMuscle: MuscleGroup
    let equipment: [Equipment]
    let difficulty: ExperienceLevel
    let category: ExerciseCategory
    let instructions: [String]
    let tips: [String]
    let commonMistakes: [String]
    let videoURL: String?
    let thumbnailName: String?
    let isCompound: Bool
    let alternatives: [String] // Exercise IDs

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Exercise, rhs: Exercise) -> Bool {
        lhs.id == rhs.id
    }
}

enum MuscleGroup: String, Codable, CaseIterable {
    case chest = "Chest"
    case back = "Back"
    case shoulders = "Shoulders"
    case biceps = "Biceps"
    case triceps = "Triceps"
    case forearms = "Forearms"
    case quads = "Quads"
    case hamstrings = "Hamstrings"
    case glutes = "Glutes"
    case calves = "Calves"
    case abs = "Abs"
    case obliques = "Obliques"
    case lowerBack = "Lower Back"
    case traps = "Traps"
    case lats = "Lats"

    var bodyRegion: BodyRegion {
        switch self {
        case .chest, .shoulders, .biceps, .triceps, .forearms, .traps: return .upper
        case .back, .lats, .lowerBack: return .upper
        case .quads, .hamstrings, .glutes, .calves: return .lower
        case .abs, .obliques: return .core
        }
    }
}

enum BodyRegion: String, CaseIterable {
    case upper = "Upper Body"
    case lower = "Lower Body"
    case core = "Core"
}

enum ExerciseCategory: String, Codable, CaseIterable {
    case push = "Push"
    case pull = "Pull"
    case legs = "Legs"
    case core = "Core"
    case cardio = "Cardio"
    case fullBody = "Full Body"
}

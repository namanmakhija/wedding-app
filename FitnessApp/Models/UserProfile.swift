import Foundation
import SwiftData

@Model
final class UserProfile {
    var id: UUID
    var name: String
    var age: Int
    var heightCm: Double
    var weightKg: Double
    var goal: FitnessGoal
    var experienceLevel: ExperienceLevel
    var daysPerWeek: Int
    var availableEquipment: [Equipment]
    var injuries: [String]
    var createdAt: Date
    var activeProgram: WorkoutProgram?

    init(
        name: String,
        age: Int,
        heightCm: Double,
        weightKg: Double,
        goal: FitnessGoal,
        experienceLevel: ExperienceLevel,
        daysPerWeek: Int,
        availableEquipment: [Equipment] = Equipment.allCases,
        injuries: [String] = []
    ) {
        self.id = UUID()
        self.name = name
        self.age = age
        self.heightCm = heightCm
        self.weightKg = weightKg
        self.goal = goal
        self.experienceLevel = experienceLevel
        self.daysPerWeek = daysPerWeek
        self.availableEquipment = availableEquipment
        self.injuries = injuries
        self.createdAt = Date()
    }

    var bmi: Double {
        let heightM = heightCm / 100
        return weightKg / (heightM * heightM)
    }

    var maintenanceCalories: Int {
        // Mifflin-St Jeor Equation (using male as default, can be expanded)
        let bmr = 10 * weightKg + 6.25 * heightCm - 5 * Double(age) + 5
        let activityMultiplier: Double = {
            switch daysPerWeek {
            case 0...1: return 1.2
            case 2...3: return 1.375
            case 4...5: return 1.55
            default: return 1.725
            }
        }()
        return Int(bmr * activityMultiplier)
    }

    var targetCalories: Int {
        switch goal {
        case .loseWeight: return maintenanceCalories - 500
        case .buildMuscle: return maintenanceCalories + 300
        case .recomposition: return maintenanceCalories
        case .maintainWeight: return maintenanceCalories
        }
    }

    var proteinTargetG: Int {
        // 0.8-1g per lb of bodyweight
        return Int(weightKg * 2.2 * 0.85)
    }

    var carbTargetG: Int {
        let remainingCals = targetCalories - (proteinTargetG * 4) - (fatTargetG * 9)
        return max(0, remainingCals / 4)
    }

    var fatTargetG: Int {
        return Int(Double(targetCalories) * 0.25 / 9)
    }
}

enum FitnessGoal: String, Codable, CaseIterable {
    case loseWeight = "Lose Weight"
    case buildMuscle = "Build Muscle"
    case recomposition = "Body Recomposition"
    case maintainWeight = "Maintain Weight"

    var description: String {
        switch self {
        case .loseWeight: return "Burn fat while preserving muscle"
        case .buildMuscle: return "Maximize muscle growth and strength"
        case .recomposition: return "Lose fat and gain muscle simultaneously"
        case .maintainWeight: return "Stay fit and healthy"
        }
    }

    var icon: String {
        switch self {
        case .loseWeight: return "flame.fill"
        case .buildMuscle: return "bolt.fill"
        case .recomposition: return "arrow.2.circlepath"
        case .maintainWeight: return "checkmark.seal.fill"
        }
    }
}

enum ExperienceLevel: String, Codable, CaseIterable {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case advanced = "Advanced"

    var description: String {
        switch self {
        case .beginner: return "Less than 1 year of consistent training"
        case .intermediate: return "1-3 years of consistent training"
        case .advanced: return "3+ years of consistent training"
        }
    }
}

enum Equipment: String, Codable, CaseIterable {
    case barbell = "Barbell"
    case dumbbell = "Dumbbells"
    case cables = "Cable Machine"
    case machine = "Machines"
    case resistanceBand = "Resistance Bands"
    case pullupBar = "Pull-up Bar"
    case bodyweight = "Bodyweight"
    case kettlebell = "Kettlebell"
    case trapBar = "Trap Bar"
}

import Foundation
import SwiftData

@Model
final class FoodItem {
    var id: UUID
    var name: String
    var brand: String
    var servingSizeG: Double
    var servingUnit: String
    var calories: Double
    var proteinG: Double
    var carbsG: Double
    var fatG: Double
    var fiberG: Double
    var sugarG: Double
    var sodiumMg: Double
    var barcode: String?
    var isCustom: Bool
    var createdAt: Date

    init(
        name: String,
        brand: String = "",
        servingSizeG: Double,
        servingUnit: String = "g",
        calories: Double,
        proteinG: Double,
        carbsG: Double,
        fatG: Double,
        fiberG: Double = 0,
        sugarG: Double = 0,
        sodiumMg: Double = 0,
        barcode: String? = nil,
        isCustom: Bool = false
    ) {
        self.id = UUID()
        self.name = name
        self.brand = brand
        self.servingSizeG = servingSizeG
        self.servingUnit = servingUnit
        self.calories = calories
        self.proteinG = proteinG
        self.carbsG = carbsG
        self.fatG = fatG
        self.fiberG = fiberG
        self.sugarG = sugarG
        self.sodiumMg = sodiumMg
        self.barcode = barcode
        self.isCustom = isCustom
        self.createdAt = Date()
    }

    func scaled(by multiplier: Double) -> NutritionValues {
        NutritionValues(
            calories: calories * multiplier,
            proteinG: proteinG * multiplier,
            carbsG: carbsG * multiplier,
            fatG: fatG * multiplier,
            fiberG: fiberG * multiplier
        )
    }
}

struct NutritionValues {
    var calories: Double
    var proteinG: Double
    var carbsG: Double
    var fatG: Double
    var fiberG: Double
}

@Model
final class NutritionLog {
    var id: UUID
    var date: Date
    var entries: [NutritionEntry]
    var waterMl: Int
    var notes: String

    init(date: Date = Date()) {
        self.id = UUID()
        self.date = Calendar.current.startOfDay(for: date)
        self.entries = []
        self.waterMl = 0
        self.notes = ""
    }

    var totalCalories: Double {
        entries.reduce(0) { $0 + $1.totalCalories }
    }

    var totalProteinG: Double {
        entries.reduce(0) { $0 + $1.totalProteinG }
    }

    var totalCarbsG: Double {
        entries.reduce(0) { $0 + $1.totalCarbsG }
    }

    var totalFatG: Double {
        entries.reduce(0) { $0 + $1.totalFatG }
    }

    var totalFiberG: Double {
        entries.reduce(0) { $0 + $1.totalFiberG }
    }

    var entriesByMeal: [MealType: [NutritionEntry]] {
        Dictionary(grouping: entries, by: { $0.mealType })
    }
}

@Model
final class NutritionEntry {
    var id: UUID
    var foodItemID: UUID
    var foodName: String
    var brand: String
    var mealType: MealType
    var servingMultiplier: Double  // e.g., 1.5 = 1.5 servings
    var servingSizeG: Double
    var calories: Double
    var proteinG: Double
    var carbsG: Double
    var fatG: Double
    var fiberG: Double
    var loggedAt: Date

    init(foodItem: FoodItem, mealType: MealType, servingMultiplier: Double = 1.0) {
        self.id = UUID()
        self.foodItemID = foodItem.id
        self.foodName = foodItem.name
        self.brand = foodItem.brand
        self.mealType = mealType
        self.servingMultiplier = servingMultiplier
        self.servingSizeG = foodItem.servingSizeG
        self.calories = foodItem.calories
        self.proteinG = foodItem.proteinG
        self.carbsG = foodItem.carbsG
        self.fatG = foodItem.fatG
        self.fiberG = foodItem.fiberG
        self.loggedAt = Date()
    }

    var totalCalories: Double { calories * servingMultiplier }
    var totalProteinG: Double { proteinG * servingMultiplier }
    var totalCarbsG: Double { carbsG * servingMultiplier }
    var totalFatG: Double { fatG * servingMultiplier }
    var totalFiberG: Double { fiberG * servingMultiplier }
    var totalGrams: Double { servingSizeG * servingMultiplier }
}

enum MealType: String, Codable, CaseIterable {
    case breakfast = "Breakfast"
    case lunch = "Lunch"
    case dinner = "Dinner"
    case snack = "Snack"
    case preworkout = "Pre-Workout"
    case postworkout = "Post-Workout"

    var icon: String {
        switch self {
        case .breakfast: return "sun.rise.fill"
        case .lunch: return "sun.max.fill"
        case .dinner: return "moon.fill"
        case .snack: return "leaf.fill"
        case .preworkout: return "bolt.fill"
        case .postworkout: return "checkmark.circle.fill"
        }
    }
}

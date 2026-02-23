import Foundation
import SwiftData

@MainActor
@Observable
final class NutritionViewModel {
    private var modelContext: ModelContext

    var searchText = ""
    var searchResults: [FoodItem] = []
    var recentFoods: [FoodItem] = []
    var selectedMealType: MealType = .breakfast
    var isSearching = false

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        loadRecentFoods()
    }

    func searchFoods(query: String) {
        guard !query.isEmpty else {
            searchResults = []
            return
        }

        isSearching = true
        let descriptor = FetchDescriptor<FoodItem>(
            predicate: #Predicate { food in
                food.name.localizedStandardContains(query)
            },
            sortBy: [SortDescriptor(\.name)]
        )
        searchResults = (try? modelContext.fetch(descriptor)) ?? []
        isSearching = false
    }

    func addFood(_ food: FoodItem, to log: NutritionLog, servings: Double = 1.0) {
        let entry = NutritionEntry(foodItem: food, mealType: selectedMealType, servingMultiplier: servings)
        log.entries.append(entry)
        try? modelContext.save()
        loadRecentFoods()
    }

    func removeEntry(_ entry: NutritionEntry, from log: NutritionLog) {
        log.entries.removeAll { $0.id == entry.id }
        modelContext.delete(entry)
        try? modelContext.save()
    }

    func createCustomFood(
        name: String,
        servingSizeG: Double,
        calories: Double,
        proteinG: Double,
        carbsG: Double,
        fatG: Double
    ) {
        let food = FoodItem(
            name: name,
            servingSizeG: servingSizeG,
            calories: calories,
            proteinG: proteinG,
            carbsG: carbsG,
            fatG: fatG,
            isCustom: true
        )
        modelContext.insert(food)
        try? modelContext.save()
    }

    func todayLog() -> NutritionLog {
        let today = Calendar.current.startOfDay(for: Date())
        let descriptor = FetchDescriptor<NutritionLog>(
            predicate: #Predicate { $0.date == today }
        )
        if let existing = try? modelContext.fetch(descriptor).first {
            return existing
        }
        let newLog = NutritionLog(date: today)
        modelContext.insert(newLog)
        try? modelContext.save()
        return newLog
    }

    func logForDate(_ date: Date) -> NutritionLog? {
        let start = Calendar.current.startOfDay(for: date)
        let descriptor = FetchDescriptor<NutritionLog>(
            predicate: #Predicate { $0.date == start }
        )
        return try? modelContext.fetch(descriptor).first
    }

    private func loadRecentFoods() {
        let descriptor = FetchDescriptor<FoodItem>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        recentFoods = Array((try? modelContext.fetch(descriptor)) ?? []).prefix(20).map { $0 }
    }

    // MARK: - Macro Ring Progress

    func calorieProgress(log: NutritionLog, target: Int) -> Double {
        min(log.totalCalories / Double(target), 1.0)
    }

    func macroProgress(current: Double, target: Int) -> Double {
        min(current / Double(target), 1.0)
    }

    func remainingCalories(log: NutritionLog, target: Int) -> Double {
        Double(target) - log.totalCalories
    }
}

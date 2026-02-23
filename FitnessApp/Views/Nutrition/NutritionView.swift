import SwiftUI
import SwiftData

struct NutritionView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var profiles: [UserProfile]
    @Query(sort: \NutritionLog.date, order: .reverse) private var nutritionLogs: [NutritionLog]

    @State private var selectedDate = Date()
    @State private var showAddFood = false
    @State private var addingMealType: MealType = .breakfast
    @State private var showLogMeasurement = false

    private var profile: UserProfile? { profiles.first }
    private var todayLog: NutritionLog? {
        nutritionLogs.first { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Date selector
                    DateSelector(selectedDate: $selectedDate)
                        .padding(.horizontal)

                    // Macro summary
                    if let profile {
                        MacroSummaryCard(log: todayLog, profile: profile)
                            .padding(.horizontal)
                    }

                    // Water tracker
                    WaterTrackerCard(log: todayLog, modelContext: modelContext)
                        .padding(.horizontal)

                    // Meals
                    ForEach(MealType.allCases, id: \.self) { mealType in
                        MealSection(
                            mealType: mealType,
                            entries: todayLog?.entries.filter { $0.mealType == mealType } ?? [],
                            onAddFood: {
                                addingMealType = mealType
                                showAddFood = true
                            },
                            onDeleteEntry: { entry in
                                deleteEntry(entry)
                            }
                        )
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Nutrition")
            .sheet(isPresented: $showAddFood) {
                FoodSearchView(mealType: addingMealType, log: todayLog ?? createTodayLog())
            }
        }
    }

    private func deleteEntry(_ entry: NutritionEntry) {
        todayLog?.entries.removeAll { $0.id == entry.id }
        modelContext.delete(entry)
        try? modelContext.save()
    }

    private func createTodayLog() -> NutritionLog {
        let log = NutritionLog(date: selectedDate)
        modelContext.insert(log)
        try? modelContext.save()
        return log
    }
}

struct DateSelector: View {
    @Binding var selectedDate: Date

    var body: some View {
        HStack {
            Button {
                selectedDate = Calendar.current.date(byAdding: .day, value: -1, to: selectedDate) ?? selectedDate
            } label: {
                Image(systemName: "chevron.left")
                    .font(.headline)
                    .foregroundStyle(.blue)
            }

            Spacer()

            VStack(spacing: 2) {
                Text(selectedDate, format: .dateTime.weekday(.wide))
                    .font(.headline)
                Text(selectedDate, format: .dateTime.month().day().year())
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Button {
                let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: selectedDate) ?? selectedDate
                if tomorrow <= Date() {
                    selectedDate = tomorrow
                }
            } label: {
                Image(systemName: "chevron.right")
                    .font(.headline)
                    .foregroundStyle(Calendar.current.isDateInToday(selectedDate) ? .secondary : .blue)
            }
            .disabled(Calendar.current.isDateInToday(selectedDate))
        }
        .padding()
        .background(.background, in: RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.06), radius: 4, y: 1)
    }
}

struct MacroSummaryCard: View {
    let log: NutritionLog?
    let profile: UserProfile

    var body: some View {
        let calories = log?.totalCalories ?? 0
        let protein = log?.totalProteinG ?? 0
        let carbs = log?.totalCarbsG ?? 0
        let fat = log?.totalFatG ?? 0

        VStack(spacing: 16) {
            // Calorie bar
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Calories")
                        .font(.headline)
                    Spacer()
                    Text("\(Int(calories)) / \(profile.targetCalories) kcal")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(.secondary.opacity(0.15))
                            .frame(height: 12)
                        RoundedRectangle(cornerRadius: 6)
                            .fill(calorieColor(calories: calories, target: Double(profile.targetCalories)))
                            .frame(width: geo.size.width * min(calories / Double(profile.targetCalories), 1.0), height: 12)
                            .animation(.spring(), value: calories)
                    }
                }
                .frame(height: 12)

                HStack {
                    let remaining = Double(profile.targetCalories) - calories
                    Text(remaining >= 0 ? "\(Int(remaining)) kcal remaining" : "\(Int(abs(remaining))) kcal over target")
                        .font(.caption)
                        .foregroundStyle(remaining >= 0 ? .secondary : .red)
                    Spacer()
                }
            }

            Divider()

            // Macro breakdown
            HStack(spacing: 0) {
                MacroDetailColumn(
                    name: "Protein",
                    current: protein,
                    target: Double(profile.proteinTargetG),
                    unit: "g",
                    color: .blue
                )
                Divider().frame(height: 50)
                MacroDetailColumn(
                    name: "Carbs",
                    current: carbs,
                    target: Double(profile.carbTargetG),
                    unit: "g",
                    color: .orange
                )
                Divider().frame(height: 50)
                MacroDetailColumn(
                    name: "Fat",
                    current: fat,
                    target: Double(profile.fatTargetG),
                    unit: "g",
                    color: .yellow
                )
            }
        }
        .padding()
        .background(.background, in: RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.08), radius: 8, y: 2)
    }

    func calorieColor(calories: Double, target: Double) -> Color {
        let ratio = calories / target
        if ratio < 0.8 { return .blue }
        if ratio < 1.1 { return .green }
        return .red
    }
}

struct MacroDetailColumn: View {
    let name: String
    let current: Double
    let target: Double
    let unit: String
    let color: Color

    var body: some View {
        VStack(spacing: 6) {
            Text(name)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text("\(Int(current))\(unit)")
                .font(.headline.bold())
                .foregroundStyle(color)
            Text("/ \(Int(target))\(unit)")
                .font(.caption2)
                .foregroundStyle(.secondary)
            ProgressView(value: min(current / target, 1.0))
                .tint(color)
                .frame(width: 40)
        }
        .frame(maxWidth: .infinity)
    }
}

struct WaterTrackerCard: View {
    let log: NutritionLog?
    let modelContext: ModelContext

    private let goal = 2500 // 2.5L default

    var body: some View {
        HStack {
            Image(systemName: "drop.fill")
                .foregroundStyle(.blue)
            Text("Water")
                .font(.subheadline.bold())
            Spacer()
            Text("\(log?.waterMl ?? 0)ml / \(goal)ml")
                .font(.caption)
                .foregroundStyle(.secondary)
            Button {
                log?.waterMl += 250
                try? modelContext.save()
            } label: {
                Image(systemName: "plus.circle.fill")
                    .foregroundStyle(.blue)
                    .font(.title3)
            }
        }
        .padding()
        .background(.blue.opacity(0.05), in: RoundedRectangle(cornerRadius: 12))
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(.blue.opacity(0.2), lineWidth: 1)
        }
    }
}

struct MealSection: View {
    let mealType: MealType
    let entries: [NutritionEntry]
    let onAddFood: () -> Void
    let onDeleteEntry: (NutritionEntry) -> Void

    private var mealCalories: Double {
        entries.reduce(0) { $0 + $1.totalCalories }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Label(mealType.rawValue, systemImage: mealType.icon)
                    .font(.headline)
                Spacer()
                if mealCalories > 0 {
                    Text("\(Int(mealCalories)) kcal")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Button(action: onAddFood) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundStyle(.blue)
                        .font(.title3)
                }
            }

            if entries.isEmpty {
                Button(action: onAddFood) {
                    HStack {
                        Image(systemName: "plus")
                            .foregroundStyle(.blue)
                        Text("Add food")
                            .foregroundStyle(.blue)
                        Spacer()
                    }
                    .padding(.vertical, 8)
                }
            } else {
                ForEach(entries) { entry in
                    NutritionEntryRow(entry: entry)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                onDeleteEntry(entry)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }
            }
        }
        .padding()
        .background(.background, in: RoundedRectangle(cornerRadius: 14))
        .shadow(color: .black.opacity(0.06), radius: 6, y: 1)
    }
}

struct NutritionEntryRow: View {
    let entry: NutritionEntry

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(entry.foodName)
                    .font(.subheadline.bold())
                    .lineLimit(1)
                Text(String(format: "%.0fg · P: %.0fg · C: %.0fg · F: %.0fg",
                    entry.totalGrams, entry.totalProteinG, entry.totalCarbsG, entry.totalFatG))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Text("\(Int(entry.totalCalories)) kcal")
                .font(.subheadline.bold())
        }
    }
}

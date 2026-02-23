import SwiftUI
import SwiftData

struct FoodSearchView: View {
    let mealType: MealType
    let log: NutritionLog

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var allFoods: [FoodItem]

    @State private var searchText = ""
    @State private var selectedFood: FoodItem? = nil
    @State private var showCreateFood = false

    private var filteredFoods: [FoodItem] {
        if searchText.isEmpty { return Array(allFoods.prefix(20)) }
        return allFoods.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        NavigationStack {
            List {
                if filteredFoods.isEmpty && !searchText.isEmpty {
                    Section {
                        Button {
                            showCreateFood = true
                        } label: {
                            Label("Create \"\(searchText)\"", systemImage: "plus.circle")
                        }
                    }
                }

                if !filteredFoods.isEmpty {
                    Section(searchText.isEmpty ? "Recent & Frequent" : "Results") {
                        ForEach(filteredFoods) { food in
                            FoodSearchRow(food: food) {
                                selectedFood = food
                            }
                        }
                    }
                }

                Section {
                    Button {
                        showCreateFood = true
                    } label: {
                        Label("Create Custom Food", systemImage: "plus.circle")
                            .foregroundStyle(.blue)
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search foods...")
            .navigationTitle("Add \(mealType.rawValue)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
            }
            .sheet(item: $selectedFood) { food in
                AddFoodServingView(food: food, mealType: mealType, log: log) {
                    dismiss()
                }
            }
            .sheet(isPresented: $showCreateFood) {
                CreateFoodView { food in
                    modelContext.insert(food)
                    try? modelContext.save()
                    selectedFood = food
                }
            }
        }
    }
}

struct FoodSearchRow: View {
    let food: FoodItem
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(food.name)
                        .font(.subheadline.bold())
                        .foregroundStyle(.primary)
                    if !food.brand.isEmpty {
                        Text(food.brand)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Text(String(format: "%.0fkcal · P:%.0fg C:%.0fg F:%.0fg per %.0f%@",
                        food.calories, food.proteinG, food.carbsG, food.fatG,
                        food.servingSizeG, food.servingUnit))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: "plus.circle")
                    .foregroundStyle(.blue)
            }
        }
    }
}

struct AddFoodServingView: View {
    let food: FoodItem
    let mealType: MealType
    let log: NutritionLog
    let onAdd: () -> Void

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var servings: Double = 1.0
    @State private var servingsText = "1"

    private var scaled: NutritionValues {
        food.scaled(by: servings)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                VStack(spacing: 6) {
                    Text(food.name)
                        .font(.title2.bold())
                    if !food.brand.isEmpty {
                        Text(food.brand)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.top)

                // Nutrition facts
                VStack(spacing: 0) {
                    NutritionFactRow(label: "Calories", value: String(format: "%.0f kcal", scaled.calories), isBold: true)
                    Divider()
                    NutritionFactRow(label: "Protein", value: String(format: "%.1f g", scaled.proteinG), color: .blue)
                    Divider()
                    NutritionFactRow(label: "Carbohydrates", value: String(format: "%.1f g", scaled.carbsG), color: .orange)
                    Divider()
                    NutritionFactRow(label: "Fat", value: String(format: "%.1f g", scaled.fatG), color: .yellow)
                    Divider()
                    NutritionFactRow(label: "Fiber", value: String(format: "%.1f g", scaled.fiberG), color: .green)
                }
                .background(.background, in: RoundedRectangle(cornerRadius: 12))
                .shadow(color: .black.opacity(0.06), radius: 6, y: 1)
                .padding(.horizontal)

                // Serving size input
                VStack(spacing: 10) {
                    Text("Serving Size")
                        .font(.headline)

                    HStack(spacing: 16) {
                        Button {
                            servings = max(0.25, servings - 0.25)
                            servingsText = String(format: servings.truncatingRemainder(dividingBy: 1) == 0 ? "%.0f" : "%.2f", servings)
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .font(.title2)
                                .foregroundStyle(.blue)
                        }

                        TextField("1", text: $servingsText)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.center)
                            .font(.title2.bold())
                            .frame(width: 80)
                            .padding(.vertical, 8)
                            .background(.secondary.opacity(0.1), in: RoundedRectangle(cornerRadius: 8))
                            .onChange(of: servingsText) {
                                servings = Double(servingsText) ?? servings
                            }

                        Button {
                            servings += 0.25
                            servingsText = String(format: servings.truncatingRemainder(dividingBy: 1) == 0 ? "%.0f" : "%.2f", servings)
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                                .foregroundStyle(.blue)
                        }
                    }

                    Text("× \(String(format: "%.0f", food.servingSizeG))\(food.servingUnit) = \(String(format: "%.0f", food.servingSizeG * servings))g")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Button {
                    let entry = NutritionEntry(foodItem: food, mealType: mealType, servingMultiplier: servings)
                    log.entries.append(entry)
                    try? modelContext.save()
                    onAdd()
                    dismiss()
                } label: {
                    Text("Add to \(mealType.rawValue)")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(.blue, in: RoundedRectangle(cornerRadius: 14))
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}

struct NutritionFactRow: View {
    let label: String
    let value: String
    var isBold = false
    var color: Color = .primary

    var body: some View {
        HStack {
            Text(label)
                .font(isBold ? .headline : .subheadline)
            Spacer()
            Text(value)
                .font(isBold ? .headline : .subheadline)
                .foregroundStyle(isBold ? .primary : color)
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
}

struct CreateFoodView: View {
    let onCreate: (FoodItem) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var brand = ""
    @State private var servingSize = "100"
    @State private var calories = ""
    @State private var protein = ""
    @State private var carbs = ""
    @State private var fat = ""

    var isValid: Bool {
        !name.isEmpty && Double(servingSize) != nil &&
        Double(calories) != nil && Double(protein) != nil &&
        Double(carbs) != nil && Double(fat) != nil
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Food Info") {
                    TextField("Name *", text: $name)
                    TextField("Brand (optional)", text: $brand)
                    HStack {
                        TextField("Serving Size", text: $servingSize)
                            .keyboardType(.decimalPad)
                        Text("g")
                            .foregroundStyle(.secondary)
                    }
                }

                Section("Per Serving") {
                    HStack {
                        Text("Calories *")
                        Spacer()
                        TextField("0", text: $calories)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                        Text("kcal")
                            .foregroundStyle(.secondary)
                    }
                    HStack {
                        Text("Protein *")
                        Spacer()
                        TextField("0", text: $protein)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                        Text("g")
                            .foregroundStyle(.secondary)
                    }
                    HStack {
                        Text("Carbohydrates *")
                        Spacer()
                        TextField("0", text: $carbs)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                        Text("g")
                            .foregroundStyle(.secondary)
                    }
                    HStack {
                        Text("Fat *")
                        Spacer()
                        TextField("0", text: $fat)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                        Text("g")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Create Food")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        let food = FoodItem(
                            name: name,
                            brand: brand,
                            servingSizeG: Double(servingSize) ?? 100,
                            calories: Double(calories) ?? 0,
                            proteinG: Double(protein) ?? 0,
                            carbsG: Double(carbs) ?? 0,
                            fatG: Double(fat) ?? 0,
                            isCustom: true
                        )
                        onCreate(food)
                        dismiss()
                    }
                    .disabled(!isValid)
                    .fontWeight(.semibold)
                }
            }
        }
    }
}

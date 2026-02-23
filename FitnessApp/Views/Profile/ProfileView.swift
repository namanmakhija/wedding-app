import SwiftUI
import SwiftData

struct ProfileView: View {
    @Query private var profiles: [UserProfile]
    @Environment(\.modelContext) private var modelContext
    @State private var showEditProfile = false

    private var profile: UserProfile? { profiles.first }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    if let profile {
                        // Profile header
                        ProfileHeaderCard(profile: profile)
                            .padding(.horizontal)

                        // Body stats
                        BodyStatsCard(profile: profile)
                            .padding(.horizontal)

                        // Nutrition targets
                        NutritionTargetsCard(profile: profile)
                            .padding(.horizontal)

                        // Settings sections
                        SettingsSection(profile: profile)
                            .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Profile")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Edit") {
                        showEditProfile = true
                    }
                }
            }
            .sheet(isPresented: $showEditProfile) {
                if let profile {
                    EditProfileView(profile: profile)
                }
            }
        }
    }
}

struct ProfileHeaderCard: View {
    let profile: UserProfile

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 70, height: 70)
                Text(profile.name.prefix(1).uppercased())
                    .font(.title.bold())
                    .foregroundStyle(.white)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(profile.name)
                    .font(.title2.bold())
                Label(profile.goal.rawValue, systemImage: profile.goal.icon)
                    .font(.subheadline)
                    .foregroundStyle(.blue)
                Label(profile.experienceLevel.rawValue, systemImage: "chart.bar.fill")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding()
        .background(.background, in: RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.08), radius: 8, y: 2)
    }
}

struct BodyStatsCard: View {
    let profile: UserProfile

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("BODY STATS")
                .font(.caption.bold())
                .foregroundStyle(.secondary)
                .tracking(1)

            HStack(spacing: 0) {
                BodyStatItem(value: String(format: "%.1f", profile.weightKg), unit: "kg", label: "Weight")
                Divider().frame(height: 50)
                BodyStatItem(value: String(format: "%.0f", profile.heightCm), unit: "cm", label: "Height")
                Divider().frame(height: 50)
                BodyStatItem(value: String(format: "%.1f", profile.bmi), unit: "BMI", label: bmiCategory(profile.bmi))
                Divider().frame(height: 50)
                BodyStatItem(value: "\(profile.age)", unit: "yrs", label: "Age")
            }
        }
        .padding()
        .background(.background, in: RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.08), radius: 8, y: 2)
    }

    func bmiCategory(_ bmi: Double) -> String {
        switch bmi {
        case ..<18.5: return "Underweight"
        case 18.5..<25: return "Normal"
        case 25..<30: return "Overweight"
        default: return "Obese"
        }
    }
}

struct BodyStatItem: View {
    let value: String
    let unit: String
    let label: String

    var body: some View {
        VStack(spacing: 4) {
            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text(value)
                    .font(.headline.bold())
                Text(unit)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

struct NutritionTargetsCard: View {
    let profile: UserProfile

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("DAILY NUTRITION TARGETS")
                    .font(.caption.bold())
                    .foregroundStyle(.secondary)
                    .tracking(1)
                Spacer()
                Text("Based on \(profile.goal.rawValue)")
                    .font(.caption)
                    .foregroundStyle(.blue)
            }

            HStack(spacing: 0) {
                NutritionTargetItem(value: "\(profile.targetCalories)", unit: "kcal", label: "Calories", color: .orange)
                Divider().frame(height: 50)
                NutritionTargetItem(value: "\(profile.proteinTargetG)g", unit: "", label: "Protein", color: .blue)
                Divider().frame(height: 50)
                NutritionTargetItem(value: "\(profile.carbTargetG)g", unit: "", label: "Carbs", color: .green)
                Divider().frame(height: 50)
                NutritionTargetItem(value: "\(profile.fatTargetG)g", unit: "", label: "Fat", color: .yellow)
            }
        }
        .padding()
        .background(.background, in: RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.08), radius: 8, y: 2)
    }
}

struct NutritionTargetItem: View {
    let value: String
    let unit: String
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: 4) {
            Text(value + unit)
                .font(.headline.bold())
                .foregroundStyle(color)
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

struct SettingsSection: View {
    let profile: UserProfile

    var body: some View {
        VStack(spacing: 12) {
            SettingsRow(icon: "gear", label: "Training Preferences", color: .gray) {}
            SettingsRow(icon: "bell.fill", label: "Notifications", color: .blue) {}
            SettingsRow(icon: "heart.fill", label: "Apple Health Sync", color: .red) {}
            SettingsRow(icon: "square.and.arrow.up.fill", label: "Export Data", color: .green) {}
        }
        .padding()
        .background(.background, in: RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.08), radius: 8, y: 2)
    }
}

struct SettingsRow: View {
    let icon: String
    let label: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(color)
                        .frame(width: 32, height: 32)
                    Image(systemName: icon)
                        .font(.caption.bold())
                        .foregroundStyle(.white)
                }
                Text(label)
                    .font(.subheadline)
                    .foregroundStyle(.primary)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

struct EditProfileView: View {
    @Bindable var profile: UserProfile
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var name: String
    @State private var weightText: String
    @State private var heightText: String
    @State private var ageText: String
    @State private var goal: FitnessGoal
    @State private var level: ExperienceLevel
    @State private var daysPerWeek: Int

    init(profile: UserProfile) {
        self.profile = profile
        _name = State(initialValue: profile.name)
        _weightText = State(initialValue: String(format: "%.1f", profile.weightKg))
        _heightText = State(initialValue: String(format: "%.0f", profile.heightCm))
        _ageText = State(initialValue: "\(profile.age)")
        _goal = State(initialValue: profile.goal)
        _level = State(initialValue: profile.experienceLevel)
        _daysPerWeek = State(initialValue: profile.daysPerWeek)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Personal Info") {
                    TextField("Name", text: $name)
                    HStack {
                        Text("Weight")
                        Spacer()
                        TextField("0.0", text: $weightText).keyboardType(.decimalPad).multilineTextAlignment(.trailing)
                        Text("kg").foregroundStyle(.secondary)
                    }
                    HStack {
                        Text("Height")
                        Spacer()
                        TextField("0", text: $heightText).keyboardType(.numberPad).multilineTextAlignment(.trailing)
                        Text("cm").foregroundStyle(.secondary)
                    }
                    HStack {
                        Text("Age")
                        Spacer()
                        TextField("0", text: $ageText).keyboardType(.numberPad).multilineTextAlignment(.trailing)
                        Text("yrs").foregroundStyle(.secondary)
                    }
                }

                Section("Training") {
                    Picker("Goal", selection: $goal) {
                        ForEach(FitnessGoal.allCases, id: \.self) { g in
                            Text(g.rawValue).tag(g)
                        }
                    }
                    Picker("Experience Level", selection: $level) {
                        ForEach(ExperienceLevel.allCases, id: \.self) { l in
                            Text(l.rawValue).tag(l)
                        }
                    }
                    Stepper("Training Days: \(daysPerWeek)/week", value: $daysPerWeek, in: 2...6)
                }
            }
            .navigationTitle("Edit Profile")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        profile.name = name
                        profile.weightKg = Double(weightText) ?? profile.weightKg
                        profile.heightCm = Double(heightText) ?? profile.heightCm
                        profile.age = Int(ageText) ?? profile.age
                        profile.goal = goal
                        profile.experienceLevel = level
                        profile.daysPerWeek = daysPerWeek
                        try? modelContext.save()
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
}

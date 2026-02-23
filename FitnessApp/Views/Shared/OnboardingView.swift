import SwiftUI
import SwiftData

struct OnboardingView: View {
    @Binding var showOnboarding: Bool
    @Environment(\.modelContext) private var modelContext

    @State private var currentStep = 0
    @State private var name = ""
    @State private var age = ""
    @State private var weightKg = ""
    @State private var heightCm = ""
    @State private var selectedGoal: FitnessGoal = .buildMuscle
    @State private var selectedLevel: ExperienceLevel = .beginner
    @State private var daysPerWeek = 4
    @State private var selectedEquipment: Set<Equipment> = Set(Equipment.allCases)

    private static let steps = ["Welcome", "About You", "Your Goal", "Training", "Equipment"]

    var body: some View {
        VStack(spacing: 0) {
            // Progress dots
            HStack(spacing: 8) {
                ForEach(Self.steps.indices, id: \.self) { i in
                    Capsule()
                        .fill(i <= currentStep ? Color.blue : Color.secondary.opacity(0.3))
                        .frame(width: i == currentStep ? 24 : 8, height: 8)
                        .animation(.spring(), value: currentStep)
                }
            }
            .padding(.top, 60)
            .padding(.bottom, 32)

            // Step content
            TabView(selection: $currentStep) {
                WelcomeStep().tag(0)
                AboutYouStep(name: $name, age: $age, weight: $weightKg, height: $heightCm).tag(1)
                GoalStep(selected: $selectedGoal).tag(2)
                TrainingStep(level: $selectedLevel, daysPerWeek: $daysPerWeek).tag(3)
                EquipmentStep(selected: $selectedEquipment).tag(4)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))

            // Navigation buttons
            HStack {
                if currentStep > 0 {
                    Button("Back") {
                        withAnimation { currentStep -= 1 }
                    }
                    .foregroundStyle(.secondary)
                }

                Spacer()

                Button {
                    if currentStep < Self.steps.count - 1 {
                        withAnimation { currentStep += 1 }
                    } else {
                        saveProfile()
                    }
                } label: {
                    Text(currentStep < Self.steps.count - 1 ? "Continue" : "Get Started")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 14)
                        .background(.blue, in: Capsule())
                }
                .disabled(!canContinue)
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 40)
        }
        .background(Color(.systemBackground))
    }

    private var canContinue: Bool {
        switch currentStep {
        case 1: return !name.isEmpty && !age.isEmpty && !weightKg.isEmpty && !heightCm.isEmpty
        default: return true
        }
    }

    private func saveProfile() {
        let profile = UserProfile(
            name: name,
            age: Int(age) ?? 25,
            heightCm: Double(heightCm) ?? 170,
            weightKg: Double(weightKg) ?? 70,
            goal: selectedGoal,
            experienceLevel: selectedLevel,
            daysPerWeek: daysPerWeek,
            availableEquipment: Array(selectedEquipment)
        )
        modelContext.insert(profile)
        try? modelContext.save()
        showOnboarding = false
    }
}

struct WelcomeStep: View {
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "figure.strengthtraining.traditional")
                .font(.system(size: 80))
                .foregroundStyle(.blue)

            VStack(spacing: 12) {
                Text("Your Science-Based\nFitness Coach")
                    .font(.title.bold())
                    .multilineTextAlignment(.center)

                Text("Personalized workout programs, nutrition tracking, and progress monitoring — all backed by exercise science.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }

            VStack(alignment: .leading, spacing: 12) {
                FeatureBullet(icon: "dumbbell.fill", color: .blue, text: "Personalized workout programs")
                FeatureBullet(icon: "fork.knife", color: .green, text: "Macro & calorie tracking")
                FeatureBullet(icon: "chart.line.uptrend.xyaxis", color: .orange, text: "Progress & body composition tracking")
                FeatureBullet(icon: "lightbulb.fill", color: .yellow, text: "Science-based tips for every exercise")
            }
            .padding(.horizontal, 32)
            .padding(.top, 8)
        }
    }
}

struct FeatureBullet: View {
    let icon: String
    let color: Color
    let text: String

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .foregroundStyle(.white)
                .frame(width: 36, height: 36)
                .background(color, in: RoundedRectangle(cornerRadius: 8))
            Text(text)
                .font(.subheadline)
        }
    }
}

struct AboutYouStep: View {
    @Binding var name: String
    @Binding var age: String
    @Binding var weight: String
    @Binding var height: String

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Tell Us About You")
                    .font(.title2.bold())
                Text("We'll use this to personalize your plan.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            VStack(spacing: 14) {
                OnboardingField(label: "Your Name", placeholder: "e.g. Alex", text: $name)
                OnboardingField(label: "Age", placeholder: "e.g. 25", text: $age, keyboard: .numberPad)
                OnboardingField(label: "Weight (kg)", placeholder: "e.g. 75", text: $weight, keyboard: .decimalPad)
                OnboardingField(label: "Height (cm)", placeholder: "e.g. 178", text: $height, keyboard: .numberPad)
            }
        }
        .padding(.horizontal, 32)
    }
}

struct OnboardingField: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    var keyboard: UIKeyboardType = .default

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.caption.bold())
                .foregroundStyle(.secondary)
                .tracking(0.5)
            TextField(placeholder, text: $text)
                .keyboardType(keyboard)
                .padding(14)
                .background(.secondary.opacity(0.1), in: RoundedRectangle(cornerRadius: 10))
                .font(.body)
        }
    }
}

struct GoalStep: View {
    @Binding var selected: FitnessGoal

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            VStack(alignment: .leading, spacing: 6) {
                Text("What's Your Goal?")
                    .font(.title2.bold())
                Text("This shapes your program and nutrition targets.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 32)

            VStack(spacing: 12) {
                ForEach(FitnessGoal.allCases, id: \.self) { goal in
                    GoalCard(goal: goal, isSelected: selected == goal) {
                        selected = goal
                    }
                }
            }
            .padding(.horizontal, 32)
        }
    }
}

struct GoalCard: View {
    let goal: FitnessGoal
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 14) {
                Image(systemName: goal.icon)
                    .font(.title3)
                    .foregroundStyle(isSelected ? .white : .blue)
                    .frame(width: 44, height: 44)
                    .background(isSelected ? Color.blue : Color.blue.opacity(0.1), in: RoundedRectangle(cornerRadius: 10))

                VStack(alignment: .leading, spacing: 3) {
                    Text(goal.rawValue)
                        .font(.subheadline.bold())
                        .foregroundStyle(.primary)
                    Text(goal.description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.blue)
                }
            }
            .padding()
            .background(isSelected ? Color.blue.opacity(0.08) : Color(.systemBackground), in: RoundedRectangle(cornerRadius: 14))
            .overlay {
                RoundedRectangle(cornerRadius: 14)
                    .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
            }
        }
        .shadow(color: .black.opacity(0.05), radius: 4, y: 1)
    }
}

struct TrainingStep: View {
    @Binding var level: ExperienceLevel
    @Binding var daysPerWeek: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Training Background")
                    .font(.title2.bold())
                Text("We'll match the program intensity to your level.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 32)

            VStack(spacing: 10) {
                ForEach(ExperienceLevel.allCases, id: \.self) { lvl in
                    Button {
                        level = lvl
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 3) {
                                Text(lvl.rawValue)
                                    .font(.subheadline.bold())
                                    .foregroundStyle(.primary)
                                Text(lvl.description)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            if level == lvl {
                                Image(systemName: "checkmark.circle.fill").foregroundStyle(.blue)
                            }
                        }
                        .padding()
                        .background(level == lvl ? Color.blue.opacity(0.08) : Color(.systemBackground), in: RoundedRectangle(cornerRadius: 12))
                        .overlay {
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(level == lvl ? Color.blue : Color.clear, lineWidth: 2)
                        }
                    }
                }
            }
            .padding(.horizontal, 32)

            VStack(spacing: 8) {
                HStack {
                    Text("Days Per Week")
                        .font(.subheadline.bold())
                    Spacer()
                    Text("\(daysPerWeek) days")
                        .font(.subheadline)
                        .foregroundStyle(.blue)
                }
                Slider(value: Binding(
                    get: { Double(daysPerWeek) },
                    set: { daysPerWeek = Int($0) }
                ), in: 2...6, step: 1)
                .tint(.blue)
            }
            .padding(.horizontal, 32)
        }
    }
}

struct EquipmentStep: View {
    @Binding var selected: Set<Equipment>

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Available Equipment")
                    .font(.title2.bold())
                Text("We'll only recommend exercises you can do.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 32)

            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                    ForEach(Equipment.allCases, id: \.self) { eq in
                        EquipmentChip(equipment: eq, isSelected: selected.contains(eq)) {
                            if selected.contains(eq) {
                                selected.remove(eq)
                            } else {
                                selected.insert(eq)
                            }
                        }
                    }
                }
                .padding(.horizontal, 32)
            }
        }
    }
}

struct EquipmentChip: View {
    let equipment: Equipment
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(isSelected ? .white : .secondary)
                    .font(.subheadline)
                Text(equipment.rawValue)
                    .font(.caption.bold())
                    .foregroundStyle(isSelected ? .white : .primary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(isSelected ? Color.blue : Color.secondary.opacity(0.1), in: RoundedRectangle(cornerRadius: 10))
        }
    }
}

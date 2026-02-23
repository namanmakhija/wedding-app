import SwiftUI
import SwiftData

struct ProgramSelectionView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var profiles: [UserProfile]
    @Query(filter: #Predicate<WorkoutProgram> { $0.isActive }) private var activePrograms: [WorkoutProgram]

    @State private var selectedGoal: FitnessGoal? = nil
    @State private var selectedLevel: ExperienceLevel? = nil
    @State private var showConfirmation: WorkoutProgram? = nil

    private var profile: UserProfile? { profiles.first }

    private var filteredPrograms: [ProgramTemplate] {
        ProgramTemplate.all.filter { template in
            (selectedGoal == nil || template.goal == selectedGoal) &&
            (selectedLevel == nil || template.level == selectedLevel)
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Filters
                    VStack(alignment: .leading, spacing: 12) {
                        Text("FILTER BY GOAL")
                            .font(.caption.bold())
                            .foregroundStyle(.secondary)
                            .tracking(1)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                FilterChip(label: "All", isSelected: selectedGoal == nil) {
                                    selectedGoal = nil
                                }
                                ForEach(FitnessGoal.allCases, id: \.self) { goal in
                                    FilterChip(label: goal.rawValue, isSelected: selectedGoal == goal) {
                                        selectedGoal = selectedGoal == goal ? nil : goal
                                    }
                                }
                            }
                        }

                        Text("FILTER BY LEVEL")
                            .font(.caption.bold())
                            .foregroundStyle(.secondary)
                            .tracking(1)

                        HStack {
                            FilterChip(label: "All", isSelected: selectedLevel == nil) {
                                selectedLevel = nil
                            }
                            ForEach(ExperienceLevel.allCases, id: \.self) { level in
                                FilterChip(label: level.rawValue, isSelected: selectedLevel == level) {
                                    selectedLevel = selectedLevel == level ? nil : level
                                }
                            }
                        }
                    }
                    .padding(.horizontal)

                    // Program cards
                    ForEach(filteredPrograms) { template in
                        ProgramTemplateCard(template: template) {
                            activateProgram(template: template)
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Programs")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }

    private func activateProgram(template: ProgramTemplate) {
        // Deactivate current programs
        let descriptor = FetchDescriptor<WorkoutProgram>(
            predicate: #Predicate { $0.isActive }
        )
        let current = (try? modelContext.fetch(descriptor)) ?? []
        current.forEach { $0.isActive = false }

        // Create and activate new program
        let program = template.build()
        program.isActive = true
        program.startDate = Date()
        modelContext.insert(program)

        // Link to user profile
        profile?.activeProgram = program

        try? modelContext.save()
        dismiss()
    }
}

struct FilterChip: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.subheadline.bold())
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(isSelected ? Color.blue : Color.secondary.opacity(0.1), in: Capsule())
                .foregroundStyle(isSelected ? .white : .primary)
        }
    }
}

struct ProgramTemplateCard: View {
    let template: ProgramTemplate
    let onStart: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(template.name)
                        .font(.title3.bold())
                    Text(template.subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: template.goal.icon)
                    .font(.title2)
                    .foregroundStyle(.blue)
            }

            Text(template.description)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(3)

            HStack(spacing: 16) {
                LabeledChip(value: "\(template.durationWeeks)wk", label: "Duration")
                LabeledChip(value: "\(template.daysPerWeek)x/wk", label: "Frequency")
                LabeledChip(value: template.level.rawValue, label: "Level")
                LabeledChip(value: template.goal.rawValue, label: "Goal")
            }

            Button(action: onStart) {
                Text("Start Program")
                    .font(.subheadline.bold())
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(.blue, in: RoundedRectangle(cornerRadius: 10))
            }
        }
        .padding()
        .background(.background, in: RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.08), radius: 8, y: 2)
    }
}

struct LabeledChip: View {
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.caption.bold())
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(.secondary.opacity(0.1), in: RoundedRectangle(cornerRadius: 6))
    }
}

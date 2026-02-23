import SwiftUI

struct ExerciseLibraryView: View {
    @State private var searchText = ""
    @State private var selectedMuscle: MuscleGroup? = nil
    @State private var selectedCategory: ExerciseCategory? = nil

    private var exercises: [Exercise] { ExerciseLibrary.shared.all }

    private var filtered: [Exercise] {
        exercises.filter { ex in
            let matchesSearch = searchText.isEmpty || ex.name.localizedCaseInsensitiveContains(searchText)
            let matchesMuscle = selectedMuscle == nil || ex.muscleGroups.contains(selectedMuscle!)
            let matchesCategory = selectedCategory == nil || ex.category == selectedCategory
            return matchesSearch && matchesMuscle && matchesCategory
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Filter chips
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        FilterChip(label: "All", isSelected: selectedCategory == nil) {
                            selectedCategory = nil
                        }
                        ForEach(ExerciseCategory.allCases, id: \.self) { cat in
                            FilterChip(label: cat.rawValue, isSelected: selectedCategory == cat) {
                                selectedCategory = selectedCategory == cat ? nil : cat
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 8)

                List(filtered) { exercise in
                    NavigationLink(destination: ExerciseDetailView(exercise: exercise)) {
                        ExerciseLibraryRow(exercise: exercise)
                    }
                }
                .listStyle(.plain)
            }
            .searchable(text: $searchText, prompt: "Search exercises...")
            .navigationTitle("Exercise Library")
        }
    }
}

struct ExerciseLibraryRow: View {
    let exercise: Exercise

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(categoryColor(exercise.category).opacity(0.15))
                    .frame(width: 44, height: 44)
                Image(systemName: exercise.category.icon)
                    .foregroundStyle(categoryColor(exercise.category))
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(exercise.name)
                    .font(.subheadline.bold())
                HStack {
                    Text(exercise.primaryMuscle.rawValue)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("·")
                        .foregroundStyle(.secondary)
                    Text(exercise.category.rawValue)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("·")
                        .foregroundStyle(.secondary)
                    Text(exercise.difficulty.rawValue)
                        .font(.caption)
                        .foregroundStyle(difficultyColor(exercise.difficulty))
                }
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 4) {
                        ForEach(exercise.muscleGroups.prefix(3), id: \.self) { muscle in
                            Text(muscle.rawValue)
                                .font(.caption2)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.blue.opacity(0.1), in: Capsule())
                                .foregroundStyle(.blue)
                        }
                    }
                }
            }
        }
        .padding(.vertical, 4)
    }

    func categoryColor(_ cat: ExerciseCategory) -> Color {
        switch cat {
        case .push: return .blue
        case .pull: return .purple
        case .legs: return .green
        case .core: return .orange
        case .cardio: return .red
        case .fullBody: return .teal
        }
    }

    func difficultyColor(_ level: ExperienceLevel) -> Color {
        switch level {
        case .beginner: return .green
        case .intermediate: return .orange
        case .advanced: return .red
        }
    }
}

struct ExerciseDetailView: View {
    let exercise: Exercise

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Muscle groups
                VStack(alignment: .leading, spacing: 10) {
                    SectionHeader("Muscles Worked")
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(exercise.muscleGroups, id: \.self) { muscle in
                                HStack(spacing: 4) {
                                    if muscle == exercise.primaryMuscle {
                                        Text("PRIMARY")
                                            .font(.caption2.bold())
                                            .foregroundStyle(.white.opacity(0.8))
                                    }
                                    Text(muscle.rawValue)
                                        .font(.caption.bold())
                                }
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(muscle == exercise.primaryMuscle ? Color.blue : Color.blue.opacity(0.1), in: Capsule())
                                .foregroundStyle(muscle == exercise.primaryMuscle ? .white : .blue)
                            }
                        }
                    }
                }

                // Equipment
                VStack(alignment: .leading, spacing: 10) {
                    SectionHeader("Equipment")
                    HStack {
                        ForEach(exercise.equipment, id: \.self) { eq in
                            Text(eq.rawValue)
                                .font(.caption.bold())
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(.secondary.opacity(0.1), in: Capsule())
                        }
                    }
                }

                // Instructions
                if !exercise.instructions.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        SectionHeader("How To Perform")
                        ForEach(exercise.instructions.indices, id: \.self) { i in
                            HStack(alignment: .top, spacing: 14) {
                                Text("\(i + 1)")
                                    .font(.caption.bold())
                                    .foregroundStyle(.white)
                                    .frame(width: 24, height: 24)
                                    .background(.blue, in: Circle())
                                Text(exercise.instructions[i])
                                    .font(.subheadline)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                }

                // Tips
                if !exercise.tips.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        SectionHeader("Science-Based Tips")
                        ForEach(exercise.tips, id: \.self) { tip in
                            HStack(alignment: .top, spacing: 12) {
                                Image(systemName: "lightbulb.fill")
                                    .foregroundStyle(.yellow)
                                    .font(.subheadline)
                                Text(tip)
                                    .font(.subheadline)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                }

                // Common mistakes
                if !exercise.commonMistakes.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        SectionHeader("Common Mistakes")
                        ForEach(exercise.commonMistakes, id: \.self) { mistake in
                            HStack(alignment: .top, spacing: 12) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundStyle(.orange)
                                    .font(.subheadline)
                                Text(mistake)
                                    .font(.subheadline)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle(exercise.name)
        .navigationBarTitleDisplayMode(.large)
    }
}

struct SectionHeader: View {
    let title: String
    init(_ title: String) { self.title = title }

    var body: some View {
        Text(title)
            .font(.headline.bold())
    }
}

import SwiftUI
import SwiftData

struct WorkoutDayDetailView: View {
    let day: WorkoutDay
    let program: WorkoutProgram

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Label(day.focus.rawValue, systemImage: day.focus.icon)
                            .font(.subheadline)
                            .foregroundStyle(.blue)
                        Spacer()
                        Label("\(day.estimatedMinutes) min", systemImage: "clock")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    if !day.notes.isEmpty {
                        Text(day.notes)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.horizontal)

                // Exercise list
                VStack(spacing: 12) {
                    ForEach(day.exercises.sorted(by: { $0.orderIndex < $1.orderIndex })) { exercise in
                        ExercisePlanRow(exercise: exercise)
                    }
                }
                .padding(.horizontal)

                // Start button
                NavigationLink(destination: ActiveWorkoutView(day: day, program: program)) {
                    Label("Start Workout", systemImage: "play.fill")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(.blue, in: RoundedRectangle(cornerRadius: 14))
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle(day.name)
        .navigationBarTitleDisplayMode(.large)
    }
}

struct ExercisePlanRow: View {
    let exercise: WorkoutExercise
    @State private var showDetail = false

    var body: some View {
        HStack(spacing: 14) {
            // Order number
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.blue.opacity(0.1))
                    .frame(width: 36, height: 36)
                Text("\(exercise.orderIndex + 1)")
                    .font(.subheadline.bold())
                    .foregroundStyle(.blue)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(exercise.exerciseName)
                    .font(.subheadline.bold())

                HStack(spacing: 12) {
                    Text(exercise.setsSummary)
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Label(restText(exercise.restSeconds), systemImage: "timer")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    if exercise.rpeTarget > 0 {
                        Text("RPE \(String(format: "%.0f", exercise.rpeTarget))")
                            .font(.caption)
                            .foregroundStyle(.orange)
                    }
                }
            }
            Spacer()

            Button {
                showDetail = true
            } label: {
                Image(systemName: "info.circle")
                    .foregroundStyle(.blue)
            }
        }
        .padding()
        .background(.background, in: RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.05), radius: 4, y: 1)
        .sheet(isPresented: $showDetail) {
            ExerciseInfoSheet(exerciseID: exercise.exerciseID, exerciseName: exercise.exerciseName)
        }
    }

    func restText(_ seconds: Int) -> String {
        if seconds < 60 { return "\(seconds)s rest" }
        let mins = seconds / 60
        let secs = seconds % 60
        return secs == 0 ? "\(mins)m rest" : "\(mins)m\(secs)s rest"
    }
}

struct ExerciseInfoSheet: View {
    let exerciseID: String
    let exerciseName: String
    @Environment(\.dismiss) private var dismiss

    private var exercise: Exercise? {
        ExerciseLibrary.shared.exercise(id: exerciseID)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                if let ex = exercise {
                    VStack(alignment: .leading, spacing: 24) {
                        // Muscle groups
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Muscles Worked")
                                .font(.headline)
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(ex.muscleGroups, id: \.self) { muscle in
                                        Text(muscle.rawValue)
                                            .font(.caption.bold())
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 5)
                                            .background(muscle == ex.primaryMuscle ? Color.blue : Color.blue.opacity(0.1), in: Capsule())
                                            .foregroundStyle(muscle == ex.primaryMuscle ? .white : .blue)
                                    }
                                }
                            }
                        }

                        // Instructions
                        if !ex.instructions.isEmpty {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("How To Perform")
                                    .font(.headline)
                                ForEach(ex.instructions.indices, id: \.self) { i in
                                    HStack(alignment: .top, spacing: 12) {
                                        Text("\(i + 1)")
                                            .font(.caption.bold())
                                            .foregroundStyle(.white)
                                            .frame(width: 22, height: 22)
                                            .background(.blue, in: Circle())
                                        Text(ex.instructions[i])
                                            .font(.subheadline)
                                    }
                                }
                            }
                        }

                        // Tips
                        if !ex.tips.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Science-Based Tips")
                                    .font(.headline)
                                ForEach(ex.tips, id: \.self) { tip in
                                    HStack(alignment: .top, spacing: 10) {
                                        Image(systemName: "lightbulb.fill")
                                            .foregroundStyle(.yellow)
                                            .font(.subheadline)
                                        Text(tip)
                                            .font(.subheadline)
                                    }
                                }
                            }
                        }

                        // Common mistakes
                        if !ex.commonMistakes.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Common Mistakes")
                                    .font(.headline)
                                ForEach(ex.commonMistakes, id: \.self) { mistake in
                                    HStack(alignment: .top, spacing: 10) {
                                        Image(systemName: "exclamationmark.triangle.fill")
                                            .foregroundStyle(.orange)
                                            .font(.subheadline)
                                        Text(mistake)
                                            .font(.subheadline)
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                } else {
                    Text("Exercise details not available")
                        .foregroundStyle(.secondary)
                        .padding()
                }
            }
            .navigationTitle(exerciseName)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

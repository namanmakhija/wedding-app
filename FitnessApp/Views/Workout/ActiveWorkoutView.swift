import SwiftUI
import SwiftData

struct ActiveWorkoutView: View {
    let day: WorkoutDay
    let program: WorkoutProgram

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var profiles: [UserProfile]

    @State private var viewModel: WorkoutViewModel?
    @State private var showFinishAlert = false
    @State private var showCancelAlert = false

    private var profile: UserProfile? { profiles.first }

    var body: some View {
        Group {
            if let vm = viewModel {
                workoutContent(vm: vm)
            } else {
                ProgressView("Starting workout...")
                    .onAppear {
                        let vm = WorkoutViewModel(modelContext: modelContext)
                        vm.startWorkout(day: day, programName: program.name)
                        viewModel = vm
                    }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle(day.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    func workoutContent(vm: WorkoutViewModel) -> some View {
        VStack(spacing: 0) {
            // Top bar with timer
            HStack {
                Button("Cancel") { showCancelAlert = true }
                    .foregroundStyle(.red)
                Spacer()
                Text(vm.elapsedText)
                    .font(.headline.monospacedDigit())
                Spacer()
                Button("Finish") { showFinishAlert = true }
                    .foregroundStyle(.blue)
                    .fontWeight(.semibold)
            }
            .padding()
            .background(.background)

            Divider()

            if vm.isResting {
                RestTimerView(vm: vm)
            } else if let exercise = vm.currentExercise {
                ActiveExerciseView(vm: vm, exercise: exercise)
            } else {
                WorkoutCompleteView {
                    vm.finishWorkout(profile: profile, program: program)
                    dismiss()
                }
            }
        }
        .alert("Finish Workout?", isPresented: $showFinishAlert) {
            Button("Finish", role: .destructive) {
                vm.finishWorkout(profile: profile, program: program)
                dismiss()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Your workout will be saved.")
        }
        .alert("Cancel Workout?", isPresented: $showCancelAlert) {
            Button("Cancel Workout", role: .destructive) {
                vm.cancelWorkout()
                dismiss()
            }
            Button("Keep Going", role: .cancel) {}
        } message: {
            Text("Progress will not be saved.")
        }
    }
}

struct ActiveExerciseView: View {
    let vm: WorkoutViewModel
    let exercise: WorkoutExercise

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Exercise header
                VStack(spacing: 8) {
                    Text(exercise.exerciseName)
                        .font(.title2.bold())
                        .multilineTextAlignment(.center)

                    HStack(spacing: 16) {
                        Label("\(exercise.sets) sets", systemImage: "list.number")
                        Label(exercise.repRangeText, systemImage: "repeat")
                        Label("RPE \(String(format: "%.0f", exercise.rpeTarget))", systemImage: "gauge.medium")
                    }
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                }
                .padding()

                // Previous performance
                if let prev = vm.previousPerformanceSummary(for: exercise.exerciseID) {
                    HStack {
                        Image(systemName: "clock.arrow.circlepath")
                            .foregroundStyle(.blue)
                        Text(prev)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal)
                }

                // Logged sets
                let loggedSets = vm.activeWorkoutLog?.sets.filter { $0.exerciseID == exercise.exerciseID } ?? []
                if !loggedSets.isEmpty {
                    VStack(spacing: 8) {
                        ForEach(loggedSets) { set in
                            HStack {
                                Text("Set \(set.setNumber)")
                                    .font(.subheadline.bold())
                                    .foregroundStyle(.secondary)
                                Spacer()
                                Text(set.weightText)
                                    .font(.subheadline.bold())
                                Text("×")
                                    .foregroundStyle(.secondary)
                                Text("\(set.reps) reps")
                                    .font(.subheadline.bold())
                                if set.isPersonalRecord {
                                    Image(systemName: "trophy.fill")
                                        .foregroundStyle(.yellow)
                                        .font(.caption)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }

                // Set input
                VStack(spacing: 16) {
                    Text("Set \(vm.currentSetIndex + 1) of \(exercise.sets)")
                        .font(.headline)
                        .foregroundStyle(.blue)

                    HStack(spacing: 20) {
                        VStack(spacing: 6) {
                            Text("Weight (kg)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            TextField(
                                vm.suggestedWeight(for: exercise.exerciseID).map { String(format: "%.1f", $0) } ?? "0",
                                text: Binding(get: { vm.pendingWeight }, set: { vm.pendingWeight = $0 })
                            )
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.center)
                            .font(.title3.bold())
                            .padding(12)
                            .background(.secondary.opacity(0.1), in: RoundedRectangle(cornerRadius: 10))
                        }

                        VStack(spacing: 6) {
                            Text("Reps")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            TextField("\(exercise.repMin)", text: Binding(get: { vm.pendingReps }, set: { vm.pendingReps = $0 }))
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.center)
                                .font(.title3.bold())
                                .padding(12)
                                .background(.secondary.opacity(0.1), in: RoundedRectangle(cornerRadius: 10))
                        }
                    }
                    .padding(.horizontal)

                    // RPE selector
                    VStack(spacing: 6) {
                        HStack {
                            Text("RPE")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Spacer()
                            Text(rpeLabel(vm.pendingRPE))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Slider(
                            value: Binding(get: { vm.pendingRPE }, set: { vm.pendingRPE = $0 }),
                            in: 5...10,
                            step: 0.5
                        )
                        .tint(.orange)
                    }
                    .padding(.horizontal)

                    Button {
                        vm.logSet()
                    } label: {
                        Text("Log Set")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(.blue, in: RoundedRectangle(cornerRadius: 14))
                    }
                    .padding(.horizontal)
                    .disabled(vm.pendingReps.isEmpty)
                }
                .padding()
                .background(.background, in: RoundedRectangle(cornerRadius: 16))
                .shadow(color: .black.opacity(0.08), radius: 8, y: 2)
                .padding(.horizontal)

                // Skip exercise
                Button("Skip Exercise") {
                    vm.skipExercise()
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .padding(.bottom)
            }
        }
    }

    func rpeLabel(_ rpe: Double) -> String {
        switch rpe {
        case ..<6: return "Very easy"
        case 6..<7: return "Easy"
        case 7..<8: return "Moderate"
        case 8..<9: return "Hard"
        case 9..<10: return "Very hard"
        default: return "Max effort"
        }
    }
}

struct RestTimerView: View {
    let vm: WorkoutViewModel

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            Text("Rest")
                .font(.title2.bold())
                .foregroundStyle(.secondary)

            ZStack {
                Circle()
                    .stroke(.gray.opacity(0.2), lineWidth: 12)
                    .frame(width: 200, height: 200)

                Circle()
                    .trim(from: 0, to: CGFloat(vm.restTimerSeconds) / 90)
                    .stroke(.blue, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .frame(width: 200, height: 200)
                    .animation(.linear, value: vm.restTimerSeconds)

                VStack(spacing: 4) {
                    Text("\(vm.restTimerSeconds)")
                        .font(.system(size: 56, weight: .bold, design: .rounded))
                    Text("seconds")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }

            if let next = vm.currentExercise {
                VStack(spacing: 4) {
                    Text("NEXT UP")
                        .font(.caption.bold())
                        .foregroundStyle(.secondary)
                        .tracking(1)
                    Text(next.exerciseName)
                        .font(.headline)
                }
            }

            Button {
                vm.skipRest()
            } label: {
                Text("Skip Rest")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 14)
                    .background(.blue, in: Capsule())
            }

            Spacer()
        }
    }
}

struct WorkoutCompleteView: View {
    let onFinish: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 72))
                .foregroundStyle(.green)

            VStack(spacing: 8) {
                Text("Workout Complete!")
                    .font(.title.bold())
                Text("Great job crushing that session.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Button(action: onFinish) {
                Text("Save & Finish")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(.green, in: RoundedRectangle(cornerRadius: 14))
            }
            .padding(.horizontal, 40)

            Spacer()
        }
    }
}

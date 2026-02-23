import Foundation
import SwiftData
import Combine

@MainActor
@Observable
final class WorkoutViewModel {
    private var modelContext: ModelContext

    // Active workout session state
    var isWorkoutActive = false
    var activeWorkoutLog: WorkoutLog?
    var activeDay: WorkoutDay?
    var currentExerciseIndex = 0
    var currentSetIndex = 0
    var restTimerSeconds = 0
    var isResting = false
    var workoutStartTime: Date?
    var elapsedSeconds = 0

    // Set input state
    var pendingWeight: String = ""
    var pendingReps: String = ""
    var pendingRPE: Double = 8.0

    // Previous performance for progressive overload guidance
    var previousSets: [String: [ExerciseSetLog]] = [:]

    private var restTimer: Timer?
    private var workoutTimer: Timer?

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    // MARK: - Workout Session Management

    func startWorkout(day: WorkoutDay, programName: String) {
        activeDay = day
        activeWorkoutLog = WorkoutLog(programName: programName, dayName: day.name)
        isWorkoutActive = true
        workoutStartTime = Date()
        currentExerciseIndex = 0
        currentSetIndex = 0

        startWorkoutTimer()
        loadPreviousSets(for: day)
    }

    func finishWorkout(profile: UserProfile?, program: WorkoutProgram?) {
        stopTimers()

        guard let log = activeWorkoutLog else { return }
        log.durationSeconds = elapsedSeconds
        log.bodyweightKg = profile?.weightKg

        modelContext.insert(log)

        // Check for personal records
        checkPersonalRecords(in: log)

        // Advance program
        program?.advanceToNextDay()

        try? modelContext.save()

        // Reset state
        isWorkoutActive = false
        activeWorkoutLog = nil
        activeDay = nil
        elapsedSeconds = 0
        currentExerciseIndex = 0
        currentSetIndex = 0
    }

    func cancelWorkout() {
        stopTimers()
        isWorkoutActive = false
        activeWorkoutLog = nil
        activeDay = nil
        elapsedSeconds = 0
    }

    // MARK: - Set Logging

    func logSet() {
        guard
            let log = activeWorkoutLog,
            let day = activeDay,
            currentExerciseIndex < day.exercises.count,
            let weight = Double(pendingWeight.isEmpty ? "0" : pendingWeight),
            let reps = Int(pendingReps)
        else { return }

        let exercise = day.exercises[currentExerciseIndex]
        let setLog = ExerciseSetLog(
            exerciseID: exercise.exerciseID,
            exerciseName: exercise.exerciseName,
            setNumber: currentSetIndex + 1,
            reps: reps,
            weightKg: weight,
            rpe: pendingRPE
        )

        log.sets.append(setLog)

        // Advance set counter
        currentSetIndex += 1
        if currentSetIndex >= exercise.sets {
            currentSetIndex = 0
            currentExerciseIndex += 1
        }

        // Start rest timer
        startRestTimer(seconds: exercise.restSeconds)

        // Clear inputs
        pendingWeight = ""
        pendingReps = ""
    }

    func skipExercise() {
        guard let day = activeDay else { return }
        currentExerciseIndex = min(currentExerciseIndex + 1, day.exercises.count)
        currentSetIndex = 0
    }

    // MARK: - Progressive Overload

    func suggestedWeight(for exerciseID: String) -> Double? {
        guard let prev = previousSets[exerciseID], !prev.isEmpty else { return nil }
        // If previous sets were completed at RPE < 8, suggest adding weight
        let avgRPE = prev.map(\.rpe).reduce(0, +) / Double(prev.count)
        let maxWeight = prev.map(\.weightKg).max() ?? 0

        if avgRPE < 7.5 {
            return maxWeight + 2.5  // Add 2.5kg
        }
        return maxWeight
    }

    func previousPerformanceSummary(for exerciseID: String) -> String? {
        guard let sets = previousSets[exerciseID], !sets.isEmpty else { return nil }
        let maxWeight = sets.map(\.weightKg).max() ?? 0
        let totalReps = sets.map(\.reps).reduce(0, +)
        return String(format: "Last: %.1f kg · %d total reps", maxWeight, totalReps)
    }

    // MARK: - Timers

    private func startRestTimer(seconds: Int) {
        restTimerSeconds = seconds
        isResting = true
        restTimer?.invalidate()
        restTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            Task { @MainActor in
                guard let self else { return }
                self.restTimerSeconds -= 1
                if self.restTimerSeconds <= 0 {
                    self.isResting = false
                    self.restTimer?.invalidate()
                }
            }
        }
    }

    func skipRest() {
        restTimer?.invalidate()
        isResting = false
        restTimerSeconds = 0
    }

    private func startWorkoutTimer() {
        elapsedSeconds = 0
        workoutTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.elapsedSeconds += 1
            }
        }
    }

    private func stopTimers() {
        restTimer?.invalidate()
        workoutTimer?.invalidate()
    }

    // MARK: - Helpers

    private func loadPreviousSets(for day: WorkoutDay) {
        previousSets = [:]
        let exerciseIDs = day.exercises.map(\.exerciseID)
        let descriptor = FetchDescriptor<WorkoutLog>(
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
        guard let logs = try? modelContext.fetch(descriptor) else { return }

        for exerciseID in exerciseIDs {
            for log in logs {
                let sets = log.sets.filter { $0.exerciseID == exerciseID }
                if !sets.isEmpty {
                    previousSets[exerciseID] = sets
                    break
                }
            }
        }
    }

    private func checkPersonalRecords(in log: WorkoutLog) {
        let descriptor = FetchDescriptor<PersonalRecord>()
        let existingPRs = (try? modelContext.fetch(descriptor)) ?? []
        var prMap: [String: PersonalRecord] = Dictionary(uniqueKeysWithValues: existingPRs.map { ($0.exerciseID, $0) })

        for set in log.sets {
            if let pr = prMap[set.exerciseID] {
                if set.estimated1RM > pr.estimated1RM {
                    pr.weightKg = set.weightKg
                    pr.reps = set.reps
                    pr.estimated1RM = set.estimated1RM
                    pr.date = Date()
                    set.isPersonalRecord = true
                }
            } else {
                let newPR = PersonalRecord(
                    exerciseID: set.exerciseID,
                    exerciseName: set.exerciseName,
                    weightKg: set.weightKg,
                    reps: set.reps
                )
                modelContext.insert(newPR)
                prMap[set.exerciseID] = newPR
                set.isPersonalRecord = true
            }
        }
    }

    var elapsedText: String {
        let mins = elapsedSeconds / 60
        let secs = elapsedSeconds % 60
        return String(format: "%02d:%02d", mins, secs)
    }

    var currentExercise: WorkoutExercise? {
        guard let day = activeDay, currentExerciseIndex < day.exercises.count else { return nil }
        return day.exercises[currentExerciseIndex]
    }
}

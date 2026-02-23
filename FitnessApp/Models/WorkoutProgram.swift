import Foundation
import SwiftData

@Model
final class WorkoutProgram {
    var id: UUID
    var name: String
    var programDescription: String
    var durationWeeks: Int
    var daysPerWeek: Int
    var goal: FitnessGoal
    var level: ExperienceLevel
    var days: [WorkoutDay]
    var currentWeek: Int
    var currentDayIndex: Int
    var startDate: Date?
    var isActive: Bool
    var createdAt: Date

    init(
        name: String,
        description: String,
        durationWeeks: Int,
        daysPerWeek: Int,
        goal: FitnessGoal,
        level: ExperienceLevel
    ) {
        self.id = UUID()
        self.name = name
        self.programDescription = description
        self.durationWeeks = durationWeeks
        self.daysPerWeek = daysPerWeek
        self.goal = goal
        self.level = level
        self.days = []
        self.currentWeek = 1
        self.currentDayIndex = 0
        self.isActive = false
        self.createdAt = Date()
    }

    var completionPercentage: Double {
        guard durationWeeks > 0, daysPerWeek > 0 else { return 0 }
        let totalDays = durationWeeks * daysPerWeek
        let completedDays = (currentWeek - 1) * daysPerWeek + currentDayIndex
        return min(Double(completedDays) / Double(totalDays), 1.0)
    }

    var todaysWorkout: WorkoutDay? {
        guard currentDayIndex < days.count else { return nil }
        return days[currentDayIndex]
    }

    func advanceToNextDay() {
        currentDayIndex += 1
        if currentDayIndex >= daysPerWeek {
            currentDayIndex = 0
            currentWeek += 1
        }
    }
}

@Model
final class WorkoutDay {
    var id: UUID
    var name: String
    var dayNumber: Int
    var focus: ExerciseCategory
    var exercises: [WorkoutExercise]
    var estimatedMinutes: Int
    var notes: String

    init(name: String, dayNumber: Int, focus: ExerciseCategory, estimatedMinutes: Int = 60, notes: String = "") {
        self.id = UUID()
        self.name = name
        self.dayNumber = dayNumber
        self.focus = focus
        self.exercises = []
        self.estimatedMinutes = estimatedMinutes
        self.notes = notes
    }
}

@Model
final class WorkoutExercise {
    var id: UUID
    var exerciseID: String  // References Exercise.id from static data
    var exerciseName: String
    var sets: Int
    var repMin: Int
    var repMax: Int
    var restSeconds: Int
    var rpeTarget: Double   // Rate of Perceived Exertion (1-10)
    var notes: String
    var orderIndex: Int
    var isWarmup: Bool

    init(
        exerciseID: String,
        exerciseName: String,
        sets: Int,
        repMin: Int,
        repMax: Int,
        restSeconds: Int = 90,
        rpeTarget: Double = 8.0,
        notes: String = "",
        orderIndex: Int = 0,
        isWarmup: Bool = false
    ) {
        self.id = UUID()
        self.exerciseID = exerciseID
        self.exerciseName = exerciseName
        self.sets = sets
        self.repMin = repMin
        self.repMax = repMax
        self.restSeconds = restSeconds
        self.rpeTarget = rpeTarget
        self.notes = notes
        self.orderIndex = orderIndex
        self.isWarmup = isWarmup
    }

    var repRangeText: String {
        if repMin == repMax {
            return "\(repMin) reps"
        }
        return "\(repMin)-\(repMax) reps"
    }

    var setsSummary: String {
        "\(sets) x \(repRangeText)"
    }
}

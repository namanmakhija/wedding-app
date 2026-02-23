import Foundation
import SwiftData

@Model
final class WorkoutLog {
    var id: UUID
    var programName: String
    var dayName: String
    var date: Date
    var durationSeconds: Int
    var sets: [ExerciseSetLog]
    var notes: String
    var bodyweightKg: Double?

    init(programName: String, dayName: String, date: Date = Date()) {
        self.id = UUID()
        self.programName = programName
        self.dayName = dayName
        self.date = date
        self.durationSeconds = 0
        self.sets = []
        self.notes = ""
    }

    var totalVolume: Double {
        sets.reduce(0) { $0 + ($1.weightKg * Double($1.reps)) }
    }

    var durationText: String {
        let mins = durationSeconds / 60
        let secs = durationSeconds % 60
        if mins > 0 {
            return "\(mins)m \(secs)s"
        }
        return "\(secs)s"
    }

    var exerciseGroups: [(exerciseID: String, exerciseName: String, sets: [ExerciseSetLog])] {
        var groups: [(String, String, [ExerciseSetLog])] = []
        var seen: [String: Int] = [:]
        for set in sets.sorted(by: { $0.setNumber < $1.setNumber }) {
            if let idx = seen[set.exerciseID] {
                groups[idx].2.append(set)
            } else {
                seen[set.exerciseID] = groups.count
                groups.append((set.exerciseID, set.exerciseName, [set]))
            }
        }
        return groups
    }
}

@Model
final class ExerciseSetLog {
    var id: UUID
    var exerciseID: String
    var exerciseName: String
    var setNumber: Int
    var reps: Int
    var weightKg: Double
    var rpe: Double
    var isPersonalRecord: Bool
    var notes: String
    var completedAt: Date

    init(
        exerciseID: String,
        exerciseName: String,
        setNumber: Int,
        reps: Int,
        weightKg: Double,
        rpe: Double = 8.0
    ) {
        self.id = UUID()
        self.exerciseID = exerciseID
        self.exerciseName = exerciseName
        self.setNumber = setNumber
        self.reps = reps
        self.weightKg = weightKg
        self.rpe = rpe
        self.isPersonalRecord = false
        self.notes = ""
        self.completedAt = Date()
    }

    var volume: Double {
        weightKg * Double(reps)
    }

    var weightText: String {
        if weightKg == 0 { return "BW" }
        return String(format: weightKg.truncatingRemainder(dividingBy: 1) == 0 ? "%.0f kg" : "%.1f kg", weightKg)
    }

    // Estimated 1 Rep Max using Epley formula
    var estimated1RM: Double {
        guard reps > 1 else { return weightKg }
        return weightKg * (1 + Double(reps) / 30)
    }
}

@Model
final class PersonalRecord {
    var id: UUID
    var exerciseID: String
    var exerciseName: String
    var weightKg: Double
    var reps: Int
    var estimated1RM: Double
    var date: Date

    init(exerciseID: String, exerciseName: String, weightKg: Double, reps: Int) {
        self.id = UUID()
        self.exerciseID = exerciseID
        self.exerciseName = exerciseName
        self.weightKg = weightKg
        self.reps = reps
        self.estimated1RM = reps > 1 ? weightKg * (1 + Double(reps) / 30) : weightKg
        self.date = Date()
    }

    var displayText: String {
        if reps == 1 {
            return String(format: "%.1f kg (1RM)", weightKg)
        }
        return String(format: "%.1f kg x %d reps", weightKg, reps)
    }
}

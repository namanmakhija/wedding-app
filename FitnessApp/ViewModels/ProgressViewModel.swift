import Foundation
import SwiftData

@MainActor
@Observable
final class ProgressViewModel {
    private var modelContext: ModelContext

    var selectedTimeRange: TimeRange = .threeMonths
    var selectedMetric: ProgressMetric = .weight

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func weightHistory(limit: Int = 90) -> [BodyMeasurement] {
        let descriptor = FetchDescriptor<BodyMeasurement>(
            predicate: #Predicate { $0.weightKg != nil },
            sortBy: [SortDescriptor(\.date)]
        )
        return (try? modelContext.fetch(descriptor)) ?? []
    }

    func workoutHistory(days: Int = 30) -> [WorkoutLog] {
        let cutoff = Calendar.current.date(byAdding: .day, value: -days, to: Date()) ?? Date()
        let descriptor = FetchDescriptor<WorkoutLog>(
            predicate: #Predicate { $0.date >= cutoff },
            sortBy: [SortDescriptor(\.date)]
        )
        return (try? modelContext.fetch(descriptor)) ?? []
    }

    func volumeHistory(for exerciseID: String) -> [(date: Date, volume: Double)] {
        let descriptor = FetchDescriptor<WorkoutLog>(
            sortBy: [SortDescriptor(\.date)]
        )
        let logs = (try? modelContext.fetch(descriptor)) ?? []
        return logs.compactMap { log -> (Date, Double)? in
            let sets = log.sets.filter { $0.exerciseID == exerciseID }
            guard !sets.isEmpty else { return nil }
            let volume = sets.reduce(0) { $0 + $1.volume }
            return (log.date, volume)
        }
    }

    func personalRecords() -> [PersonalRecord] {
        let descriptor = FetchDescriptor<PersonalRecord>(
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
        return (try? modelContext.fetch(descriptor)) ?? []
    }

    func addMeasurement(_ measurement: BodyMeasurement) {
        modelContext.insert(measurement)
        try? modelContext.save()
    }

    func weeklyWorkoutCount(weeks: Int = 12) -> [(weekStart: Date, count: Int)] {
        let logs = workoutHistory(days: weeks * 7)
        let calendar = Calendar.current
        var result: [(Date, Int)] = []

        for weekOffset in 0..<weeks {
            let weekStart = calendar.date(byAdding: .weekOfYear, value: -weekOffset, to: Date()) ?? Date()
            let weekLogs = logs.filter {
                calendar.isDate($0.date, equalTo: weekStart, toGranularity: .weekOfYear)
            }
            result.append((weekStart, weekLogs.count))
        }

        return result.reversed()
    }

    var currentStreak: Int {
        let logs = workoutHistory(days: 365)
        guard !logs.isEmpty else { return 0 }

        let calendar = Calendar.current
        var streak = 0
        var checkDate = calendar.startOfDay(for: Date())

        while true {
            let hasWorkout = logs.contains { calendar.isDate($0.date, inSameDayAs: checkDate) }
            if hasWorkout {
                streak += 1
                checkDate = calendar.date(byAdding: .day, value: -1, to: checkDate) ?? checkDate
            } else {
                break
            }
        }

        return streak
    }

    var totalWorkoutsCompleted: Int {
        let descriptor = FetchDescriptor<WorkoutLog>()
        return (try? modelContext.fetchCount(descriptor)) ?? 0
    }

    var totalVolumeLifted: Double {
        let descriptor = FetchDescriptor<ExerciseSetLog>()
        let sets = (try? modelContext.fetch(descriptor)) ?? []
        return sets.reduce(0) { $0 + $1.volume }
    }
}

enum TimeRange: String, CaseIterable {
    case oneMonth = "1M"
    case threeMonths = "3M"
    case sixMonths = "6M"
    case oneYear = "1Y"
    case allTime = "All"

    var days: Int {
        switch self {
        case .oneMonth: return 30
        case .threeMonths: return 90
        case .sixMonths: return 180
        case .oneYear: return 365
        case .allTime: return 3650
        }
    }
}

enum ProgressMetric: String, CaseIterable {
    case weight = "Weight"
    case bodyFat = "Body Fat %"
    case volume = "Volume"
    case strength = "Strength"
}

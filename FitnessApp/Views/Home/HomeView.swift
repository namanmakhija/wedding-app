import SwiftUI
import SwiftData

struct HomeView: View {
    @Query private var profiles: [UserProfile]
    @Query(sort: \WorkoutLog.date, order: .reverse) private var recentLogs: [WorkoutLog]
    @Query(filter: #Predicate<WorkoutProgram> { $0.isActive }) private var activePrograms: [WorkoutProgram]

    private var profile: UserProfile? { profiles.first }
    private var activeProgram: WorkoutProgram? { activePrograms.first }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Greeting header
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(greetingText)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Text(profile?.name ?? "Athlete")
                                .font(.title.bold())
                        }
                        Spacer()
                        streakBadge
                    }
                    .padding(.horizontal)

                    // Today's Workout Card
                    if let program = activeProgram, let today = program.todaysWorkout {
                        TodayWorkoutCard(program: program, day: today)
                            .padding(.horizontal)
                    } else {
                        NoProgramCard()
                            .padding(.horizontal)
                    }

                    // Nutrition summary
                    DailyNutritionSummaryCard(profile: profile)
                        .padding(.horizontal)

                    // Weekly overview
                    WeeklyActivityCard(logs: Array(recentLogs.prefix(7)))
                        .padding(.horizontal)

                    // Recent workouts
                    if !recentLogs.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Recent Workouts")
                                .font(.headline)
                                .padding(.horizontal)

                            ForEach(recentLogs.prefix(3)) { log in
                                RecentWorkoutRow(log: log)
                                    .padding(.horizontal)
                            }
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Dashboard")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var greetingText: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 0..<12: return "Good morning,"
        case 12..<17: return "Good afternoon,"
        default: return "Good evening,"
        }
    }

    private var streakBadge: some View {
        VStack(spacing: 2) {
            Text("\(currentStreak)")
                .font(.title2.bold())
                .foregroundStyle(.orange)
            Text("day streak")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .padding(10)
        .background(.orange.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
    }

    private var currentStreak: Int {
        let calendar = Calendar.current
        var streak = 0
        var checkDate = calendar.startOfDay(for: Date())
        for log in recentLogs {
            if calendar.isDate(log.date, inSameDayAs: checkDate) {
                streak += 1
                checkDate = calendar.date(byAdding: .day, value: -1, to: checkDate) ?? checkDate
            } else {
                break
            }
        }
        return streak
    }
}

struct TodayWorkoutCard: View {
    let program: WorkoutProgram
    let day: WorkoutDay
    @State private var showWorkout = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("TODAY'S WORKOUT")
                        .font(.caption.bold())
                        .foregroundStyle(.secondary)
                        .tracking(1)
                    Text(day.name)
                        .font(.title2.bold())
                }
                Spacer()
                Image(systemName: day.focus.icon)
                    .font(.title2)
                    .foregroundStyle(.blue)
            }

            HStack(spacing: 20) {
                Label("\(day.exercises.count) exercises", systemImage: "list.bullet")
                Label("\(day.estimatedMinutes) min", systemImage: "clock")
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)

            // Exercise preview
            VStack(alignment: .leading, spacing: 6) {
                ForEach(day.exercises.prefix(3)) { exercise in
                    HStack {
                        Circle()
                            .fill(.blue)
                            .frame(width: 6, height: 6)
                        Text(exercise.exerciseName)
                            .font(.subheadline)
                        Spacer()
                        Text(exercise.setsSummary)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                if day.exercises.count > 3 {
                    Text("+ \(day.exercises.count - 3) more")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            // Progress bar
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("Program Progress")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text("Week \(program.currentWeek) of \(program.durationWeeks)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                ProgressView(value: program.completionPercentage)
                    .tint(.blue)
            }

            NavigationLink(destination: ActiveWorkoutView(day: day, program: program)) {
                Text("Start Workout")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(.blue, in: RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding()
        .background(.background, in: RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.08), radius: 8, y: 2)
    }
}

struct NoProgramCard: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "dumbbell.fill")
                .font(.largeTitle)
                .foregroundStyle(.blue)
            Text("No Active Program")
                .font(.headline)
            Text("Choose a workout program to get started with your fitness journey")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            NavigationLink(destination: ProgramSelectionView()) {
                Text("Browse Programs")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(.blue, in: RoundedRectangle(cornerRadius: 10))
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.background, in: RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.08), radius: 8, y: 2)
    }
}

struct DailyNutritionSummaryCard: View {
    let profile: UserProfile?
    @Query private var nutritionLogs: [NutritionLog]

    private var todayLog: NutritionLog? {
        let today = Calendar.current.startOfDay(for: Date())
        return nutritionLogs.first { Calendar.current.isDate($0.date, inSameDayAs: today) }
    }

    var body: some View {
        let calories = todayLog?.totalCalories ?? 0
        let target = Double(profile?.targetCalories ?? 2000)
        let protein = todayLog?.totalProteinG ?? 0
        let proteinTarget = Double(profile?.proteinTargetG ?? 150)

        VStack(alignment: .leading, spacing: 12) {
            Text("TODAY'S NUTRITION")
                .font(.caption.bold())
                .foregroundStyle(.secondary)
                .tracking(1)

            HStack(spacing: 16) {
                // Calories ring
                ZStack {
                    Circle()
                        .stroke(.gray.opacity(0.2), lineWidth: 8)
                    Circle()
                        .trim(from: 0, to: min(calories / target, 1.0))
                        .stroke(.orange, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                    VStack(spacing: 0) {
                        Text("\(Int(calories))")
                            .font(.headline.bold())
                        Text("kcal")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
                .frame(width: 80, height: 80)

                VStack(alignment: .leading, spacing: 8) {
                    MacroRow(label: "Protein", current: protein, target: proteinTarget, color: .blue)
                    MacroRow(label: "Carbs", current: todayLog?.totalCarbsG ?? 0, target: Double(profile?.carbTargetG ?? 250), color: .orange)
                    MacroRow(label: "Fat", current: todayLog?.totalFatG ?? 0, target: Double(profile?.fatTargetG ?? 65), color: .yellow)
                }
            }
        }
        .padding()
        .background(.background, in: RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.08), radius: 8, y: 2)
    }
}

struct MacroRow: View {
    let label: String
    let current: Double
    let target: Double
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            HStack {
                Text(label)
                    .font(.caption)
                Spacer()
                Text("\(Int(current))g / \(Int(target))g")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            ProgressView(value: min(current / target, 1.0))
                .tint(color)
        }
    }
}

struct WeeklyActivityCard: View {
    let logs: [WorkoutLog]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("THIS WEEK")
                .font(.caption.bold())
                .foregroundStyle(.secondary)
                .tracking(1)

            HStack(spacing: 6) {
                ForEach(weekDays, id: \.self) { day in
                    let hasWorkout = hasWorkout(on: day)
                    VStack(spacing: 4) {
                        Circle()
                            .fill(hasWorkout ? Color.blue : Color.gray.opacity(0.2))
                            .frame(width: 32, height: 32)
                            .overlay {
                                if hasWorkout {
                                    Image(systemName: "checkmark")
                                        .font(.caption.bold())
                                        .foregroundStyle(.white)
                                }
                            }
                        Text(dayLabel(day))
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding()
        .background(.background, in: RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.08), radius: 8, y: 2)
    }

    private var weekDays: [Date] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let weekday = calendar.component(.weekday, from: today)
        let daysFromMonday = (weekday + 5) % 7
        let monday = calendar.date(byAdding: .day, value: -daysFromMonday, to: today)!
        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: monday) }
    }

    private func hasWorkout(on date: Date) -> Bool {
        logs.contains { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }

    private func dayLabel(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return String(formatter.string(from: date).prefix(1))
    }
}

struct RecentWorkoutRow: View {
    let log: WorkoutLog

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(log.dayName)
                    .font(.subheadline.bold())
                Text(log.programName)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 4) {
                Text(log.date, style: .date)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(log.durationText)
                    .font(.caption.bold())
                    .foregroundStyle(.blue)
            }
        }
        .padding()
        .background(.background, in: RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.05), radius: 4, y: 1)
    }
}

extension ExerciseCategory {
    var icon: String {
        switch self {
        case .push: return "arrow.up.circle.fill"
        case .pull: return "arrow.down.circle.fill"
        case .legs: return "figure.walk"
        case .core: return "circle.grid.cross.fill"
        case .cardio: return "heart.fill"
        case .fullBody: return "person.fill"
        }
    }
}

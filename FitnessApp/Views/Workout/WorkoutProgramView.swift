import SwiftUI
import SwiftData

struct WorkoutProgramView: View {
    @Query(filter: #Predicate<WorkoutProgram> { $0.isActive }) private var activePrograms: [WorkoutProgram]
    @Query(filter: #Predicate<WorkoutProgram> { !$0.isActive }) private var availablePrograms: [WorkoutProgram]
    @State private var showProgramSelection = false

    private var activeProgram: WorkoutProgram? { activePrograms.first }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    if let program = activeProgram {
                        ActiveProgramSection(program: program)
                    } else {
                        EmptyProgramBanner()
                    }

                    // Week schedule
                    if let program = activeProgram {
                        WeekScheduleSection(program: program)
                    }
                }
                .padding()
            }
            .navigationTitle("Workout")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Programs") {
                        showProgramSelection = true
                    }
                }
            }
            .sheet(isPresented: $showProgramSelection) {
                ProgramSelectionView()
            }
        }
    }
}

struct ActiveProgramSection: View {
    let program: WorkoutProgram

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("ACTIVE PROGRAM")
                        .font(.caption.bold())
                        .foregroundStyle(.secondary)
                        .tracking(1)
                    Text(program.name)
                        .font(.title2.bold())
                    Text(program.programDescription)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }

            HStack(spacing: 24) {
                StatBadge(value: "\(program.durationWeeks)", label: "Weeks", icon: "calendar")
                StatBadge(value: "\(program.daysPerWeek)", label: "Days/Week", icon: "repeat")
                StatBadge(value: "Week \(program.currentWeek)", label: "Current", icon: "flag.fill")
            }

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text("Overall Progress")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text("\(Int(program.completionPercentage * 100))%")
                        .font(.caption.bold())
                }
                ProgressView(value: program.completionPercentage)
                    .tint(.blue)
                    .scaleEffect(y: 2)
            }
        }
        .padding()
        .background(.background, in: RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.08), radius: 8, y: 2)
    }
}

struct StatBadge: View {
    let value: String
    let label: String
    let icon: String

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.subheadline)
                .foregroundStyle(.blue)
            Text(value)
                .font(.subheadline.bold())
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

struct WeekScheduleSection: View {
    let program: WorkoutProgram

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("THIS WEEK'S SCHEDULE")
                .font(.caption.bold())
                .foregroundStyle(.secondary)
                .tracking(1)

            ForEach(program.days.sorted(by: { $0.dayNumber < $1.dayNumber })) { day in
                WorkoutDayRow(day: day, isCurrent: day.dayNumber - 1 == program.currentDayIndex, program: program)
            }
        }
    }
}

struct WorkoutDayRow: View {
    let day: WorkoutDay
    let isCurrent: Bool
    let program: WorkoutProgram

    var body: some View {
        NavigationLink(destination: WorkoutDayDetailView(day: day, program: program)) {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(isCurrent ? Color.blue : Color.gray.opacity(0.15))
                        .frame(width: 44, height: 44)
                    Image(systemName: day.focus.icon)
                        .font(.subheadline)
                        .foregroundStyle(isCurrent ? .white : .secondary)
                }

                VStack(alignment: .leading, spacing: 3) {
                    HStack {
                        Text(day.name)
                            .font(.subheadline.bold())
                            .foregroundStyle(.primary)
                        if isCurrent {
                            Text("TODAY")
                                .font(.caption2.bold())
                                .foregroundStyle(.white)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(.blue, in: Capsule())
                        }
                    }
                    Text("\(day.exercises.count) exercises · \(day.estimatedMinutes) min")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding()
            .background(isCurrent ? Color.blue.opacity(0.05) : Color(.systemBackground), in: RoundedRectangle(cornerRadius: 12))
            .overlay {
                if isCurrent {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.blue.opacity(0.3), lineWidth: 1)
                }
            }
        }
        .shadow(color: .black.opacity(0.05), radius: 4, y: 1)
    }
}

struct EmptyProgramBanner: View {
    @State private var showSelection = false

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "dumbbell.fill")
                .font(.system(size: 50))
                .foregroundStyle(.blue.opacity(0.7))

            VStack(spacing: 8) {
                Text("Start Your Journey")
                    .font(.title2.bold())
                Text("Choose a science-based workout program tailored to your goal and experience level.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            Button {
                showSelection = true
            } label: {
                Text("Choose a Program")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(.blue, in: RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(.background, in: RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.08), radius: 8, y: 2)
        .sheet(isPresented: $showSelection) {
            ProgramSelectionView()
        }
    }
}

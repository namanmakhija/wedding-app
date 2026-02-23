import SwiftUI
import SwiftData
import Charts

struct ProgressTrackingView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \BodyMeasurement.date) private var measurements: [BodyMeasurement]
    @Query(sort: \WorkoutLog.date) private var workoutLogs: [WorkoutLog]
    @Query(sort: \PersonalRecord.date, order: .reverse) private var personalRecords: [PersonalRecord]

    @State private var selectedMetric: ProgressMetric = .weight
    @State private var selectedTimeRange: TimeRange = .threeMonths
    @State private var showAddMeasurement = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Stats overview
                    StatsOverviewSection(logs: workoutLogs, measurements: measurements)
                        .padding(.horizontal)

                    // Chart section
                    ChartSection(
                        measurements: filteredMeasurements,
                        workoutLogs: filteredLogs,
                        metric: selectedMetric,
                        timeRange: selectedTimeRange,
                        onMetricChange: { selectedMetric = $0 },
                        onRangeChange: { selectedTimeRange = $0 }
                    )
                    .padding(.horizontal)

                    // Log measurement button
                    Button {
                        showAddMeasurement = true
                    } label: {
                        Label("Log Measurement", systemImage: "plus.circle")
                            .font(.subheadline.bold())
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(.blue, in: RoundedRectangle(cornerRadius: 12))
                    }
                    .padding(.horizontal)

                    // Personal Records
                    if !personalRecords.isEmpty {
                        PersonalRecordsSection(records: personalRecords)
                            .padding(.horizontal)
                    }

                    // Recent workouts summary
                    WorkoutHistorySection(logs: Array(workoutLogs.suffix(10).reversed()))
                        .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("Progress")
            .sheet(isPresented: $showAddMeasurement) {
                AddMeasurementView { measurement in
                    modelContext.insert(measurement)
                    try? modelContext.save()
                }
            }
        }
    }

    private var filteredMeasurements: [BodyMeasurement] {
        let cutoff = Calendar.current.date(byAdding: .day, value: -selectedTimeRange.days, to: Date()) ?? Date()
        return measurements.filter { $0.date >= cutoff }
    }

    private var filteredLogs: [WorkoutLog] {
        let cutoff = Calendar.current.date(byAdding: .day, value: -selectedTimeRange.days, to: Date()) ?? Date()
        return workoutLogs.filter { $0.date >= cutoff }
    }
}

struct StatsOverviewSection: View {
    let logs: [WorkoutLog]
    let measurements: [BodyMeasurement]

    private var totalWorkouts: Int { logs.count }
    private var totalVolume: Double { logs.flatMap { $0.sets }.reduce(0) { $0 + $1.volume } }
    private var currentStreak: Int {
        let calendar = Calendar.current
        var streak = 0
        var checkDate = calendar.startOfDay(for: Date())
        for log in logs.sorted(by: { $0.date > $1.date }) {
            if calendar.isDate(log.date, inSameDayAs: checkDate) {
                streak += 1
                checkDate = calendar.date(byAdding: .day, value: -1, to: checkDate) ?? checkDate
            } else { break }
        }
        return streak
    }

    var body: some View {
        HStack(spacing: 12) {
            BigStatCard(value: "\(totalWorkouts)", label: "Workouts", icon: "dumbbell.fill", color: .blue)
            BigStatCard(value: "\(currentStreak)", label: "Day Streak", icon: "flame.fill", color: .orange)
            BigStatCard(value: String(format: "%.0f", totalVolume / 1000) + "t", label: "Volume", icon: "chart.bar.fill", color: .green)
        }
    }
}

struct BigStatCard: View {
    let value: String
    let label: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(color)
            Text(value)
                .font(.title2.bold())
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.background, in: RoundedRectangle(cornerRadius: 14))
        .shadow(color: .black.opacity(0.07), radius: 6, y: 2)
    }
}

struct ChartSection: View {
    let measurements: [BodyMeasurement]
    let workoutLogs: [WorkoutLog]
    let metric: ProgressMetric
    let timeRange: TimeRange
    let onMetricChange: (ProgressMetric) -> Void
    let onRangeChange: (TimeRange) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Metric selector
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(ProgressMetric.allCases, id: \.self) { m in
                        FilterChip(label: m.rawValue, isSelected: metric == m) {
                            onMetricChange(m)
                        }
                    }
                }
            }

            // Time range selector
            HStack {
                ForEach(TimeRange.allCases, id: \.self) { range in
                    Button {
                        onRangeChange(range)
                    } label: {
                        Text(range.rawValue)
                            .font(.caption.bold())
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(timeRange == range ? Color.blue : Color.clear, in: Capsule())
                            .foregroundStyle(timeRange == range ? .white : .secondary)
                    }
                }
                Spacer()
            }

            // Chart
            Group {
                switch metric {
                case .weight:
                    WeightChart(measurements: measurements.filter { $0.weightKg != nil })
                case .bodyFat:
                    BodyFatChart(measurements: measurements.filter { $0.bodyFatPercentage != nil })
                case .volume:
                    VolumeChart(logs: workoutLogs)
                case .strength:
                    Text("Select an exercise to view strength progress")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, minHeight: 120)
                }
            }
        }
        .padding()
        .background(.background, in: RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.08), radius: 8, y: 2)
    }
}

struct WeightChart: View {
    let measurements: [BodyMeasurement]

    var body: some View {
        if measurements.isEmpty {
            emptyChart(label: "No weight data yet")
        } else {
            Chart {
                ForEach(measurements) { m in
                    if let weight = m.weightKg {
                        LineMark(
                            x: .value("Date", m.date),
                            y: .value("Weight", weight)
                        )
                        .foregroundStyle(.blue)
                        .interpolationMethod(.catmullRom)

                        AreaMark(
                            x: .value("Date", m.date),
                            y: .value("Weight", weight)
                        )
                        .foregroundStyle(.blue.opacity(0.1))
                        .interpolationMethod(.catmullRom)

                        PointMark(
                            x: .value("Date", m.date),
                            y: .value("Weight", weight)
                        )
                        .foregroundStyle(.blue)
                        .symbolSize(30)
                    }
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading)
            }
            .frame(height: 150)
        }
    }
}

struct BodyFatChart: View {
    let measurements: [BodyMeasurement]

    var body: some View {
        if measurements.isEmpty {
            emptyChart(label: "No body fat data yet")
        } else {
            Chart {
                ForEach(measurements) { m in
                    if let bf = m.bodyFatPercentage {
                        LineMark(
                            x: .value("Date", m.date),
                            y: .value("Body Fat %", bf)
                        )
                        .foregroundStyle(.orange)
                        .interpolationMethod(.catmullRom)

                        PointMark(
                            x: .value("Date", m.date),
                            y: .value("Body Fat %", bf)
                        )
                        .foregroundStyle(.orange)
                    }
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading) { value in
                    AxisValueLabel {
                        if let v = value.as(Double.self) {
                            Text("\(Int(v))%")
                        }
                    }
                }
            }
            .frame(height: 150)
        }
    }
}

struct VolumeChart: View {
    let logs: [WorkoutLog]

    var body: some View {
        if logs.isEmpty {
            emptyChart(label: "No workout data yet")
        } else {
            Chart {
                ForEach(logs) { log in
                    BarMark(
                        x: .value("Date", log.date, unit: .day),
                        y: .value("Volume", log.totalVolume)
                    )
                    .foregroundStyle(.green.gradient)
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading) { value in
                    AxisValueLabel {
                        if let v = value.as(Double.self) {
                            Text("\(Int(v/1000))k")
                        }
                    }
                }
            }
            .frame(height: 150)
        }
    }
}

@ViewBuilder
func emptyChart(label: String) -> some View {
    VStack(spacing: 8) {
        Image(systemName: "chart.line.uptrend.xyaxis")
            .font(.largeTitle)
            .foregroundStyle(.secondary.opacity(0.4))
        Text(label)
            .font(.subheadline)
            .foregroundStyle(.secondary)
    }
    .frame(maxWidth: .infinity, minHeight: 120)
}

struct PersonalRecordsSection: View {
    let records: [PersonalRecord]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("PERSONAL RECORDS")
                .font(.caption.bold())
                .foregroundStyle(.secondary)
                .tracking(1)

            ForEach(records.prefix(5)) { record in
                HStack {
                    Image(systemName: "trophy.fill")
                        .foregroundStyle(.yellow)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(record.exerciseName)
                            .font(.subheadline.bold())
                        Text(record.date, style: .date)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 2) {
                        Text(record.displayText)
                            .font(.subheadline.bold())
                        Text(String(format: "~%.0f kg 1RM", record.estimated1RM))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding()
                .background(.yellow.opacity(0.07), in: RoundedRectangle(cornerRadius: 10))
            }
        }
        .padding()
        .background(.background, in: RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.08), radius: 8, y: 2)
    }
}

struct WorkoutHistorySection: View {
    let logs: [WorkoutLog]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("WORKOUT HISTORY")
                .font(.caption.bold())
                .foregroundStyle(.secondary)
                .tracking(1)

            ForEach(logs) { log in
                HStack {
                    VStack(alignment: .leading, spacing: 3) {
                        Text(log.dayName)
                            .font(.subheadline.bold())
                        Text("\(log.sets.count) sets · \(String(format: "%.0f", log.totalVolume)) kg total volume")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 3) {
                        Text(log.date, style: .date)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text(log.durationText)
                            .font(.caption.bold())
                    }
                }
                .padding(.vertical, 6)
                Divider()
            }
        }
        .padding()
        .background(.background, in: RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.08), radius: 8, y: 2)
    }
}

struct AddMeasurementView: View {
    let onSave: (BodyMeasurement) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var weight = ""
    @State private var bodyFat = ""
    @State private var waist = ""
    @State private var chest = ""
    @State private var hips = ""
    @State private var leftBicep = ""
    @State private var date = Date()
    @State private var notes = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Date") {
                    DatePicker("Date", selection: $date, in: ...Date(), displayedComponents: .date)
                }

                Section("Body Weight & Composition") {
                    HStack {
                        Text("Weight")
                        Spacer()
                        TextField("0.0", text: $weight).keyboardType(.decimalPad).multilineTextAlignment(.trailing)
                        Text("kg").foregroundStyle(.secondary)
                    }
                    HStack {
                        Text("Body Fat")
                        Spacer()
                        TextField("0.0", text: $bodyFat).keyboardType(.decimalPad).multilineTextAlignment(.trailing)
                        Text("%").foregroundStyle(.secondary)
                    }
                }

                Section("Measurements (optional)") {
                    measurementRow("Waist", value: $waist)
                    measurementRow("Chest", value: $chest)
                    measurementRow("Hips", value: $hips)
                    measurementRow("Left Bicep", value: $leftBicep)
                }

                Section("Notes") {
                    TextField("Optional notes...", text: $notes, axis: .vertical)
                        .lineLimit(3)
                }
            }
            .navigationTitle("Log Measurement")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        let m = BodyMeasurement(date: date)
                        m.weightKg = Double(weight)
                        m.bodyFatPercentage = Double(bodyFat)
                        m.waistCm = Double(waist)
                        m.chestCm = Double(chest)
                        m.hipsCm = Double(hips)
                        m.leftBicepCm = Double(leftBicep)
                        m.notes = notes
                        onSave(m)
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .disabled(weight.isEmpty && bodyFat.isEmpty)
                }
            }
        }
    }

    @ViewBuilder
    func measurementRow(_ label: String, value: Binding<String>) -> some View {
        HStack {
            Text(label)
            Spacer()
            TextField("0.0", text: value).keyboardType(.decimalPad).multilineTextAlignment(.trailing)
            Text("cm").foregroundStyle(.secondary)
        }
    }
}

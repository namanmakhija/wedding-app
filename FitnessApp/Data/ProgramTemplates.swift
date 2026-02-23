import Foundation

// Describes a pre-built program template that can be instantiated into a WorkoutProgram
struct ProgramTemplate: Identifiable {
    let id: String
    let name: String
    let subtitle: String
    let description: String
    let durationWeeks: Int
    let daysPerWeek: Int
    let goal: FitnessGoal
    let level: ExperienceLevel
    let build: () -> WorkoutProgram

    static let all: [ProgramTemplate] = [
        upperLowerBeginner,
        pplIntermediate,
        fullBodyBeginner,
        upperLowerBuildMuscle,
        bodySplitAdvanced,
        fullBodyFatLoss
    ]
}

// MARK: - Program Builders

extension ProgramTemplate {

    // MARK: Upper/Lower – Beginner (4 days)
    static let upperLowerBeginner = ProgramTemplate(
        id: "upper_lower_beginner",
        name: "Upper/Lower Split",
        subtitle: "4-Day Beginner Program",
        description: "A proven beginner program that trains each muscle group twice per week with an upper/lower split. Focuses on the fundamental compound lifts to build a strong foundation.",
        durationWeeks: 12,
        daysPerWeek: 4,
        goal: .buildMuscle,
        level: .beginner
    ) {
        let program = WorkoutProgram(
            name: "Upper/Lower Split",
            description: "Science-based 4-day beginner program",
            durationWeeks: 12,
            daysPerWeek: 4,
            goal: .buildMuscle,
            level: .beginner
        )

        // Upper A
        let upperA = WorkoutDay(name: "Upper A", dayNumber: 1, focus: .push, estimatedMinutes: 55)
        upperA.exercises = [
            WorkoutExercise(exerciseID: "barbell_bench_press", exerciseName: "Barbell Bench Press", sets: 3, repMin: 8, repMax: 10, restSeconds: 120, rpeTarget: 8, orderIndex: 0),
            WorkoutExercise(exerciseID: "barbell_row", exerciseName: "Barbell Row", sets: 3, repMin: 8, repMax: 10, restSeconds: 120, rpeTarget: 8, orderIndex: 1),
            WorkoutExercise(exerciseID: "dumbbell_shoulder_press", exerciseName: "Dumbbell Shoulder Press", sets: 3, repMin: 10, repMax: 12, restSeconds: 90, rpeTarget: 8, orderIndex: 2),
            WorkoutExercise(exerciseID: "lat_pulldown", exerciseName: "Lat Pulldown", sets: 3, repMin: 10, repMax: 12, restSeconds: 90, rpeTarget: 8, orderIndex: 3),
            WorkoutExercise(exerciseID: "dumbbell_curl", exerciseName: "Dumbbell Curl", sets: 2, repMin: 12, repMax: 15, restSeconds: 60, rpeTarget: 8, orderIndex: 4),
            WorkoutExercise(exerciseID: "tricep_pushdown", exerciseName: "Cable Tricep Pushdown", sets: 2, repMin: 12, repMax: 15, restSeconds: 60, rpeTarget: 8, orderIndex: 5)
        ]

        // Lower A
        let lowerA = WorkoutDay(name: "Lower A", dayNumber: 2, focus: .legs, estimatedMinutes: 55)
        lowerA.exercises = [
            WorkoutExercise(exerciseID: "barbell_squat", exerciseName: "Barbell Back Squat", sets: 3, repMin: 6, repMax: 8, restSeconds: 180, rpeTarget: 8, orderIndex: 0),
            WorkoutExercise(exerciseID: "romanian_deadlift", exerciseName: "Romanian Deadlift", sets: 3, repMin: 10, repMax: 12, restSeconds: 120, rpeTarget: 8, orderIndex: 1),
            WorkoutExercise(exerciseID: "leg_press", exerciseName: "Leg Press", sets: 3, repMin: 10, repMax: 15, restSeconds: 90, rpeTarget: 8, orderIndex: 2),
            WorkoutExercise(exerciseID: "leg_curl", exerciseName: "Lying Leg Curl", sets: 3, repMin: 10, repMax: 15, restSeconds: 90, rpeTarget: 8, orderIndex: 3),
            WorkoutExercise(exerciseID: "calf_raise", exerciseName: "Standing Calf Raise", sets: 3, repMin: 12, repMax: 20, restSeconds: 60, rpeTarget: 8, orderIndex: 4)
        ]

        // Upper B
        let upperB = WorkoutDay(name: "Upper B", dayNumber: 3, focus: .pull, estimatedMinutes: 55)
        upperB.exercises = [
            WorkoutExercise(exerciseID: "incline_dumbbell_press", exerciseName: "Incline Dumbbell Press", sets: 3, repMin: 10, repMax: 12, restSeconds: 90, rpeTarget: 8, orderIndex: 0),
            WorkoutExercise(exerciseID: "pull_up", exerciseName: "Pull-Up", sets: 3, repMin: 5, repMax: 8, restSeconds: 120, rpeTarget: 8, orderIndex: 1),
            WorkoutExercise(exerciseID: "lateral_raise", exerciseName: "Dumbbell Lateral Raise", sets: 3, repMin: 12, repMax: 15, restSeconds: 60, rpeTarget: 8, orderIndex: 2),
            WorkoutExercise(exerciseID: "cable_row", exerciseName: "Seated Cable Row", sets: 3, repMin: 10, repMax: 12, restSeconds: 90, rpeTarget: 8, orderIndex: 3),
            WorkoutExercise(exerciseID: "hammer_curl", exerciseName: "Hammer Curl", sets: 2, repMin: 12, repMax: 15, restSeconds: 60, rpeTarget: 8, orderIndex: 4),
            WorkoutExercise(exerciseID: "overhead_tricep_extension", exerciseName: "Overhead Tricep Extension", sets: 2, repMin: 12, repMax: 15, restSeconds: 60, rpeTarget: 8, orderIndex: 5),
            WorkoutExercise(exerciseID: "face_pull", exerciseName: "Cable Face Pull", sets: 2, repMin: 15, repMax: 20, restSeconds: 60, rpeTarget: 7, orderIndex: 6)
        ]

        // Lower B
        let lowerB = WorkoutDay(name: "Lower B", dayNumber: 4, focus: .legs, estimatedMinutes: 55)
        lowerB.exercises = [
            WorkoutExercise(exerciseID: "deadlift", exerciseName: "Conventional Deadlift", sets: 3, repMin: 4, repMax: 6, restSeconds: 180, rpeTarget: 8, orderIndex: 0),
            WorkoutExercise(exerciseID: "hack_squat", exerciseName: "Hack Squat", sets: 3, repMin: 10, repMax: 12, restSeconds: 120, rpeTarget: 8, orderIndex: 1),
            WorkoutExercise(exerciseID: "lunge", exerciseName: "Dumbbell Lunge", sets: 3, repMin: 10, repMax: 12, restSeconds: 90, rpeTarget: 8, orderIndex: 2),
            WorkoutExercise(exerciseID: "leg_extension", exerciseName: "Leg Extension", sets: 3, repMin: 12, repMax: 15, restSeconds: 60, rpeTarget: 8, orderIndex: 3),
            WorkoutExercise(exerciseID: "hip_thrust", exerciseName: "Barbell Hip Thrust", sets: 3, repMin: 10, repMax: 15, restSeconds: 90, rpeTarget: 8, orderIndex: 4),
            WorkoutExercise(exerciseID: "calf_raise", exerciseName: "Seated Calf Raise", sets: 4, repMin: 12, repMax: 20, restSeconds: 60, rpeTarget: 8, orderIndex: 5)
        ]

        program.days = [upperA, lowerA, upperB, lowerB]
        return program
    }

    // MARK: Push/Pull/Legs – Intermediate (6 days)
    static let pplIntermediate = ProgramTemplate(
        id: "ppl_intermediate",
        name: "Push / Pull / Legs",
        subtitle: "6-Day Intermediate Program",
        description: "The classic PPL split run twice per week. Each muscle group receives high volume and is trained twice per week, making it ideal for intermediate lifters chasing hypertrophy.",
        durationWeeks: 12,
        daysPerWeek: 6,
        goal: .buildMuscle,
        level: .intermediate
    ) {
        let program = WorkoutProgram(
            name: "Push / Pull / Legs",
            description: "High-volume 6-day PPL split",
            durationWeeks: 12,
            daysPerWeek: 6,
            goal: .buildMuscle,
            level: .intermediate
        )

        // Push A
        let pushA = WorkoutDay(name: "Push A", dayNumber: 1, focus: .push, estimatedMinutes: 65)
        pushA.exercises = [
            WorkoutExercise(exerciseID: "barbell_bench_press", exerciseName: "Barbell Bench Press", sets: 4, repMin: 6, repMax: 8, restSeconds: 150, rpeTarget: 8.5, orderIndex: 0),
            WorkoutExercise(exerciseID: "incline_dumbbell_press", exerciseName: "Incline Dumbbell Press", sets: 3, repMin: 10, repMax: 12, restSeconds: 90, rpeTarget: 8, orderIndex: 1),
            WorkoutExercise(exerciseID: "overhead_press", exerciseName: "Barbell Overhead Press", sets: 3, repMin: 6, repMax: 8, restSeconds: 120, rpeTarget: 8, orderIndex: 2),
            WorkoutExercise(exerciseID: "lateral_raise", exerciseName: "Dumbbell Lateral Raise", sets: 4, repMin: 12, repMax: 20, restSeconds: 60, rpeTarget: 8, orderIndex: 3),
            WorkoutExercise(exerciseID: "cable_fly", exerciseName: "Cable Fly (Low-to-High)", sets: 3, repMin: 12, repMax: 15, restSeconds: 60, rpeTarget: 8, orderIndex: 4),
            WorkoutExercise(exerciseID: "tricep_pushdown", exerciseName: "Cable Tricep Pushdown", sets: 3, repMin: 12, repMax: 15, restSeconds: 60, rpeTarget: 8, orderIndex: 5),
            WorkoutExercise(exerciseID: "skull_crusher", exerciseName: "Skull Crusher", sets: 3, repMin: 10, repMax: 12, restSeconds: 60, rpeTarget: 8, orderIndex: 6)
        ]

        // Pull A
        let pullA = WorkoutDay(name: "Pull A", dayNumber: 2, focus: .pull, estimatedMinutes: 65)
        pullA.exercises = [
            WorkoutExercise(exerciseID: "deadlift", exerciseName: "Conventional Deadlift", sets: 4, repMin: 4, repMax: 6, restSeconds: 240, rpeTarget: 8.5, orderIndex: 0),
            WorkoutExercise(exerciseID: "pull_up", exerciseName: "Pull-Up", sets: 4, repMin: 6, repMax: 10, restSeconds: 120, rpeTarget: 8, orderIndex: 1),
            WorkoutExercise(exerciseID: "barbell_row", exerciseName: "Barbell Row", sets: 3, repMin: 8, repMax: 10, restSeconds: 120, rpeTarget: 8, orderIndex: 2),
            WorkoutExercise(exerciseID: "face_pull", exerciseName: "Cable Face Pull", sets: 3, repMin: 15, repMax: 20, restSeconds: 60, rpeTarget: 7, orderIndex: 3),
            WorkoutExercise(exerciseID: "barbell_curl", exerciseName: "Barbell Curl", sets: 3, repMin: 10, repMax: 12, restSeconds: 60, rpeTarget: 8, orderIndex: 4),
            WorkoutExercise(exerciseID: "incline_dumbbell_curl", exerciseName: "Incline Dumbbell Curl", sets: 3, repMin: 10, repMax: 15, restSeconds: 60, rpeTarget: 8, orderIndex: 5),
            WorkoutExercise(exerciseID: "hammer_curl", exerciseName: "Hammer Curl", sets: 2, repMin: 12, repMax: 15, restSeconds: 60, rpeTarget: 8, orderIndex: 6)
        ]

        // Legs A
        let legsA = WorkoutDay(name: "Legs A", dayNumber: 3, focus: .legs, estimatedMinutes: 65)
        legsA.exercises = [
            WorkoutExercise(exerciseID: "barbell_squat", exerciseName: "Barbell Back Squat", sets: 4, repMin: 6, repMax: 8, restSeconds: 180, rpeTarget: 8.5, orderIndex: 0),
            WorkoutExercise(exerciseID: "hack_squat", exerciseName: "Hack Squat", sets: 3, repMin: 10, repMax: 12, restSeconds: 120, rpeTarget: 8, orderIndex: 1),
            WorkoutExercise(exerciseID: "romanian_deadlift", exerciseName: "Romanian Deadlift", sets: 3, repMin: 10, repMax: 12, restSeconds: 120, rpeTarget: 8, orderIndex: 2),
            WorkoutExercise(exerciseID: "leg_curl", exerciseName: "Lying Leg Curl", sets: 3, repMin: 10, repMax: 15, restSeconds: 90, rpeTarget: 8, orderIndex: 3),
            WorkoutExercise(exerciseID: "leg_extension", exerciseName: "Leg Extension", sets: 3, repMin: 12, repMax: 15, restSeconds: 60, rpeTarget: 8, orderIndex: 4),
            WorkoutExercise(exerciseID: "hip_thrust", exerciseName: "Barbell Hip Thrust", sets: 3, repMin: 10, repMax: 15, restSeconds: 90, rpeTarget: 8, orderIndex: 5),
            WorkoutExercise(exerciseID: "calf_raise", exerciseName: "Standing Calf Raise", sets: 4, repMin: 10, repMax: 20, restSeconds: 60, rpeTarget: 8, orderIndex: 6)
        ]

        // Push B
        let pushB = WorkoutDay(name: "Push B", dayNumber: 4, focus: .push, estimatedMinutes: 60)
        pushB.exercises = [
            WorkoutExercise(exerciseID: "incline_barbell_press", exerciseName: "Incline Barbell Press", sets: 4, repMin: 8, repMax: 10, restSeconds: 120, rpeTarget: 8, orderIndex: 0),
            WorkoutExercise(exerciseID: "dumbbell_bench_press", exerciseName: "Dumbbell Bench Press", sets: 3, repMin: 10, repMax: 12, restSeconds: 90, rpeTarget: 8, orderIndex: 1),
            WorkoutExercise(exerciseID: "arnold_press", exerciseName: "Arnold Press", sets: 3, repMin: 10, repMax: 12, restSeconds: 90, rpeTarget: 8, orderIndex: 2),
            WorkoutExercise(exerciseID: "cable_lateral_raise", exerciseName: "Cable Lateral Raise", sets: 4, repMin: 15, repMax: 20, restSeconds: 60, rpeTarget: 8, orderIndex: 3),
            WorkoutExercise(exerciseID: "pec_deck", exerciseName: "Pec Deck / Machine Fly", sets: 3, repMin: 12, repMax: 15, restSeconds: 60, rpeTarget: 8, orderIndex: 4),
            WorkoutExercise(exerciseID: "overhead_tricep_extension", exerciseName: "Overhead Tricep Extension", sets: 3, repMin: 10, repMax: 15, restSeconds: 60, rpeTarget: 8, orderIndex: 5)
        ]

        // Pull B
        let pullB = WorkoutDay(name: "Pull B", dayNumber: 5, focus: .pull, estimatedMinutes: 60)
        pullB.exercises = [
            WorkoutExercise(exerciseID: "lat_pulldown", exerciseName: "Lat Pulldown", sets: 4, repMin: 8, repMax: 12, restSeconds: 90, rpeTarget: 8, orderIndex: 0),
            WorkoutExercise(exerciseID: "dumbbell_row", exerciseName: "Single-Arm Dumbbell Row", sets: 4, repMin: 10, repMax: 12, restSeconds: 90, rpeTarget: 8, orderIndex: 1),
            WorkoutExercise(exerciseID: "cable_row", exerciseName: "Seated Cable Row", sets: 3, repMin: 10, repMax: 12, restSeconds: 90, rpeTarget: 8, orderIndex: 2),
            WorkoutExercise(exerciseID: "rear_delt_fly", exerciseName: "Rear Delt Fly", sets: 3, repMin: 15, repMax: 20, restSeconds: 60, rpeTarget: 7, orderIndex: 3),
            WorkoutExercise(exerciseID: "cable_curl", exerciseName: "Cable Curl", sets: 3, repMin: 12, repMax: 15, restSeconds: 60, rpeTarget: 8, orderIndex: 4),
            WorkoutExercise(exerciseID: "dumbbell_curl", exerciseName: "Dumbbell Curl", sets: 3, repMin: 12, repMax: 15, restSeconds: 60, rpeTarget: 8, orderIndex: 5)
        ]

        // Legs B
        let legsB = WorkoutDay(name: "Legs B", dayNumber: 6, focus: .legs, estimatedMinutes: 60)
        legsB.exercises = [
            WorkoutExercise(exerciseID: "trap_bar_deadlift", exerciseName: "Trap Bar Deadlift", sets: 4, repMin: 4, repMax: 6, restSeconds: 210, rpeTarget: 8.5, orderIndex: 0),
            WorkoutExercise(exerciseID: "leg_press", exerciseName: "Leg Press", sets: 4, repMin: 10, repMax: 15, restSeconds: 120, rpeTarget: 8, orderIndex: 1),
            WorkoutExercise(exerciseID: "lunge", exerciseName: "Dumbbell Lunge", sets: 3, repMin: 10, repMax: 12, restSeconds: 90, rpeTarget: 8, orderIndex: 2),
            WorkoutExercise(exerciseID: "leg_curl", exerciseName: "Lying Leg Curl", sets: 4, repMin: 10, repMax: 15, restSeconds: 90, rpeTarget: 8, orderIndex: 3),
            WorkoutExercise(exerciseID: "glute_bridge", exerciseName: "Glute Bridge", sets: 3, repMin: 12, repMax: 20, restSeconds: 60, rpeTarget: 8, orderIndex: 4),
            WorkoutExercise(exerciseID: "calf_raise", exerciseName: "Standing Calf Raise", sets: 5, repMin: 10, repMax: 20, restSeconds: 60, rpeTarget: 8, orderIndex: 5)
        ]

        program.days = [pushA, pullA, legsA, pushB, pullB, legsB]
        return program
    }

    // MARK: Full Body – Beginner (3 days)
    static let fullBodyBeginner = ProgramTemplate(
        id: "full_body_beginner",
        name: "Full Body Basics",
        subtitle: "3-Day Beginner Program",
        description: "Train your whole body 3x per week with this beginner-friendly full body program. Perfect for those new to weight training who want to build strength and muscle efficiently.",
        durationWeeks: 10,
        daysPerWeek: 3,
        goal: .buildMuscle,
        level: .beginner
    ) {
        let program = WorkoutProgram(
            name: "Full Body Basics",
            description: "3-day full body beginner program",
            durationWeeks: 10,
            daysPerWeek: 3,
            goal: .buildMuscle,
            level: .beginner
        )

        let dayA = WorkoutDay(name: "Full Body A", dayNumber: 1, focus: .fullBody, estimatedMinutes: 50)
        dayA.exercises = [
            WorkoutExercise(exerciseID: "barbell_squat", exerciseName: "Barbell Back Squat", sets: 3, repMin: 5, repMax: 8, restSeconds: 150, rpeTarget: 7.5, orderIndex: 0),
            WorkoutExercise(exerciseID: "barbell_bench_press", exerciseName: "Barbell Bench Press", sets: 3, repMin: 8, repMax: 10, restSeconds: 120, rpeTarget: 7.5, orderIndex: 1),
            WorkoutExercise(exerciseID: "barbell_row", exerciseName: "Barbell Row", sets: 3, repMin: 8, repMax: 10, restSeconds: 120, rpeTarget: 7.5, orderIndex: 2),
            WorkoutExercise(exerciseID: "dumbbell_shoulder_press", exerciseName: "Dumbbell Shoulder Press", sets: 2, repMin: 10, repMax: 12, restSeconds: 90, rpeTarget: 7.5, orderIndex: 3),
            WorkoutExercise(exerciseID: "plank", exerciseName: "Plank", sets: 3, repMin: 30, repMax: 60, restSeconds: 60, rpeTarget: 7, notes: "Hold for 30-60 seconds", orderIndex: 4)
        ]

        let dayB = WorkoutDay(name: "Full Body B", dayNumber: 2, focus: .fullBody, estimatedMinutes: 50)
        dayB.exercises = [
            WorkoutExercise(exerciseID: "deadlift", exerciseName: "Conventional Deadlift", sets: 3, repMin: 5, repMax: 6, restSeconds: 180, rpeTarget: 7.5, orderIndex: 0),
            WorkoutExercise(exerciseID: "dumbbell_bench_press", exerciseName: "Dumbbell Bench Press", sets: 3, repMin: 10, repMax: 12, restSeconds: 90, rpeTarget: 7.5, orderIndex: 1),
            WorkoutExercise(exerciseID: "lat_pulldown", exerciseName: "Lat Pulldown", sets: 3, repMin: 10, repMax: 12, restSeconds: 90, rpeTarget: 7.5, orderIndex: 2),
            WorkoutExercise(exerciseID: "lunge", exerciseName: "Dumbbell Lunge", sets: 2, repMin: 10, repMax: 12, restSeconds: 90, rpeTarget: 7.5, orderIndex: 3),
            WorkoutExercise(exerciseID: "dead_bug", exerciseName: "Dead Bug", sets: 3, repMin: 8, repMax: 10, restSeconds: 60, rpeTarget: 7, notes: "8-10 per side", orderIndex: 4)
        ]

        let dayC = WorkoutDay(name: "Full Body C", dayNumber: 3, focus: .fullBody, estimatedMinutes: 50)
        dayC.exercises = [
            WorkoutExercise(exerciseID: "goblet_squat", exerciseName: "Goblet Squat", sets: 3, repMin: 10, repMax: 15, restSeconds: 90, rpeTarget: 7.5, orderIndex: 0),
            WorkoutExercise(exerciseID: "push_up", exerciseName: "Push-Up", sets: 3, repMin: 10, repMax: 20, restSeconds: 60, rpeTarget: 7.5, orderIndex: 1),
            WorkoutExercise(exerciseID: "dumbbell_row", exerciseName: "Single-Arm Dumbbell Row", sets: 3, repMin: 10, repMax: 12, restSeconds: 90, rpeTarget: 7.5, orderIndex: 2),
            WorkoutExercise(exerciseID: "hip_thrust", exerciseName: "Barbell Hip Thrust", sets: 3, repMin: 10, repMax: 15, restSeconds: 90, rpeTarget: 7.5, orderIndex: 3),
            WorkoutExercise(exerciseID: "calf_raise", exerciseName: "Standing Calf Raise", sets: 3, repMin: 15, repMax: 20, restSeconds: 60, rpeTarget: 7.5, orderIndex: 4)
        ]

        program.days = [dayA, dayB, dayC]
        return program
    }

    // MARK: Upper/Lower – Build Muscle (4 days, Intermediate)
    static let upperLowerBuildMuscle = ProgramTemplate(
        id: "upper_lower_intermediate",
        name: "Upper/Lower Hypertrophy",
        subtitle: "4-Day Intermediate Program",
        description: "A higher-volume upper/lower split for intermediate lifters focused on maximizing muscle hypertrophy. Each session includes both compound and isolation work.",
        durationWeeks: 12,
        daysPerWeek: 4,
        goal: .buildMuscle,
        level: .intermediate
    ) {
        let program = WorkoutProgram(
            name: "Upper/Lower Hypertrophy",
            description: "4-day intermediate hypertrophy split",
            durationWeeks: 12,
            daysPerWeek: 4,
            goal: .buildMuscle,
            level: .intermediate
        )

        let upperA = WorkoutDay(name: "Upper – Strength Focus", dayNumber: 1, focus: .push, estimatedMinutes: 70)
        upperA.exercises = [
            WorkoutExercise(exerciseID: "barbell_bench_press", exerciseName: "Barbell Bench Press", sets: 4, repMin: 4, repMax: 6, restSeconds: 180, rpeTarget: 8.5, orderIndex: 0),
            WorkoutExercise(exerciseID: "barbell_row", exerciseName: "Barbell Row", sets: 4, repMin: 4, repMax: 6, restSeconds: 180, rpeTarget: 8.5, orderIndex: 1),
            WorkoutExercise(exerciseID: "overhead_press", exerciseName: "Barbell Overhead Press", sets: 3, repMin: 6, repMax: 8, restSeconds: 120, rpeTarget: 8, orderIndex: 2),
            WorkoutExercise(exerciseID: "pull_up", exerciseName: "Pull-Up", sets: 3, repMin: 6, repMax: 10, restSeconds: 120, rpeTarget: 8, orderIndex: 3),
            WorkoutExercise(exerciseID: "lateral_raise", exerciseName: "Dumbbell Lateral Raise", sets: 3, repMin: 15, repMax: 20, restSeconds: 60, rpeTarget: 8, orderIndex: 4),
            WorkoutExercise(exerciseID: "barbell_curl", exerciseName: "Barbell Curl", sets: 3, repMin: 8, repMax: 12, restSeconds: 60, rpeTarget: 8, orderIndex: 5),
            WorkoutExercise(exerciseID: "skull_crusher", exerciseName: "Skull Crusher", sets: 3, repMin: 8, repMax: 12, restSeconds: 60, rpeTarget: 8, orderIndex: 6)
        ]

        let lowerA = WorkoutDay(name: "Lower – Strength Focus", dayNumber: 2, focus: .legs, estimatedMinutes: 70)
        lowerA.exercises = [
            WorkoutExercise(exerciseID: "barbell_squat", exerciseName: "Barbell Back Squat", sets: 4, repMin: 4, repMax: 6, restSeconds: 240, rpeTarget: 8.5, orderIndex: 0),
            WorkoutExercise(exerciseID: "romanian_deadlift", exerciseName: "Romanian Deadlift", sets: 3, repMin: 8, repMax: 10, restSeconds: 150, rpeTarget: 8, orderIndex: 1),
            WorkoutExercise(exerciseID: "leg_press", exerciseName: "Leg Press", sets: 3, repMin: 10, repMax: 15, restSeconds: 120, rpeTarget: 8, orderIndex: 2),
            WorkoutExercise(exerciseID: "leg_curl", exerciseName: "Lying Leg Curl", sets: 4, repMin: 10, repMax: 12, restSeconds: 90, rpeTarget: 8, orderIndex: 3),
            WorkoutExercise(exerciseID: "leg_extension", exerciseName: "Leg Extension", sets: 3, repMin: 12, repMax: 15, restSeconds: 60, rpeTarget: 8, orderIndex: 4),
            WorkoutExercise(exerciseID: "calf_raise", exerciseName: "Standing Calf Raise", sets: 5, repMin: 10, repMax: 20, restSeconds: 60, rpeTarget: 8, orderIndex: 5)
        ]

        let upperB = WorkoutDay(name: "Upper – Volume Focus", dayNumber: 3, focus: .pull, estimatedMinutes: 70)
        upperB.exercises = [
            WorkoutExercise(exerciseID: "incline_barbell_press", exerciseName: "Incline Barbell Press", sets: 4, repMin: 8, repMax: 10, restSeconds: 120, rpeTarget: 8, orderIndex: 0),
            WorkoutExercise(exerciseID: "lat_pulldown", exerciseName: "Lat Pulldown", sets: 4, repMin: 8, repMax: 12, restSeconds: 90, rpeTarget: 8, orderIndex: 1),
            WorkoutExercise(exerciseID: "dumbbell_shoulder_press", exerciseName: "Dumbbell Shoulder Press", sets: 3, repMin: 10, repMax: 12, restSeconds: 90, rpeTarget: 8, orderIndex: 2),
            WorkoutExercise(exerciseID: "cable_row", exerciseName: "Seated Cable Row", sets: 3, repMin: 10, repMax: 12, restSeconds: 90, rpeTarget: 8, orderIndex: 3),
            WorkoutExercise(exerciseID: "cable_fly", exerciseName: "Cable Fly (Low-to-High)", sets: 3, repMin: 12, repMax: 15, restSeconds: 60, rpeTarget: 8, orderIndex: 4),
            WorkoutExercise(exerciseID: "face_pull", exerciseName: "Cable Face Pull", sets: 3, repMin: 15, repMax: 20, restSeconds: 60, rpeTarget: 7, orderIndex: 5),
            WorkoutExercise(exerciseID: "incline_dumbbell_curl", exerciseName: "Incline Dumbbell Curl", sets: 3, repMin: 10, repMax: 15, restSeconds: 60, rpeTarget: 8, orderIndex: 6),
            WorkoutExercise(exerciseID: "overhead_tricep_extension", exerciseName: "Overhead Tricep Extension", sets: 3, repMin: 12, repMax: 15, restSeconds: 60, rpeTarget: 8, orderIndex: 7)
        ]

        let lowerB = WorkoutDay(name: "Lower – Volume Focus", dayNumber: 4, focus: .legs, estimatedMinutes: 70)
        lowerB.exercises = [
            WorkoutExercise(exerciseID: "deadlift", exerciseName: "Conventional Deadlift", sets: 3, repMin: 4, repMax: 6, restSeconds: 240, rpeTarget: 8.5, orderIndex: 0),
            WorkoutExercise(exerciseID: "hack_squat", exerciseName: "Hack Squat", sets: 4, repMin: 8, repMax: 12, restSeconds: 120, rpeTarget: 8, orderIndex: 1),
            WorkoutExercise(exerciseID: "lunge", exerciseName: "Dumbbell Lunge", sets: 3, repMin: 10, repMax: 12, restSeconds: 90, rpeTarget: 8, orderIndex: 2),
            WorkoutExercise(exerciseID: "leg_curl", exerciseName: "Lying Leg Curl", sets: 4, repMin: 10, repMax: 15, restSeconds: 90, rpeTarget: 8, orderIndex: 3),
            WorkoutExercise(exerciseID: "hip_thrust", exerciseName: "Barbell Hip Thrust", sets: 4, repMin: 10, repMax: 15, restSeconds: 90, rpeTarget: 8, orderIndex: 4),
            WorkoutExercise(exerciseID: "calf_raise", exerciseName: "Standing Calf Raise", sets: 5, repMin: 10, repMax: 20, restSeconds: 60, rpeTarget: 8, orderIndex: 5)
        ]

        program.days = [upperA, lowerA, upperB, lowerB]
        return program
    }

    // MARK: Body Part Split – Advanced (5 days)
    static let bodySplitAdvanced = ProgramTemplate(
        id: "bro_split_advanced",
        name: "5-Day Body Part Split",
        subtitle: "Advanced Hypertrophy Program",
        description: "A high-volume 5-day split targeting each muscle group once per week with maximum volume. For advanced lifters who have plateaued on lower-frequency programs.",
        durationWeeks: 12,
        daysPerWeek: 5,
        goal: .buildMuscle,
        level: .advanced
    ) {
        let program = WorkoutProgram(
            name: "5-Day Body Part Split",
            description: "Advanced high-volume hypertrophy",
            durationWeeks: 12,
            daysPerWeek: 5,
            goal: .buildMuscle,
            level: .advanced
        )

        let chest = WorkoutDay(name: "Chest & Triceps", dayNumber: 1, focus: .push, estimatedMinutes: 70)
        chest.exercises = [
            WorkoutExercise(exerciseID: "barbell_bench_press", exerciseName: "Barbell Bench Press", sets: 4, repMin: 5, repMax: 8, restSeconds: 150, rpeTarget: 8.5, orderIndex: 0),
            WorkoutExercise(exerciseID: "incline_barbell_press", exerciseName: "Incline Barbell Press", sets: 4, repMin: 8, repMax: 10, restSeconds: 120, rpeTarget: 8, orderIndex: 1),
            WorkoutExercise(exerciseID: "dip", exerciseName: "Chest Dip", sets: 3, repMin: 8, repMax: 12, restSeconds: 90, rpeTarget: 8, orderIndex: 2),
            WorkoutExercise(exerciseID: "cable_fly", exerciseName: "Cable Fly (Low-to-High)", sets: 3, repMin: 12, repMax: 15, restSeconds: 60, rpeTarget: 8, orderIndex: 3),
            WorkoutExercise(exerciseID: "pec_deck", exerciseName: "Pec Deck", sets: 3, repMin: 12, repMax: 15, restSeconds: 60, rpeTarget: 8, orderIndex: 4),
            WorkoutExercise(exerciseID: "skull_crusher", exerciseName: "Skull Crusher", sets: 4, repMin: 8, repMax: 12, restSeconds: 75, rpeTarget: 8, orderIndex: 5),
            WorkoutExercise(exerciseID: "overhead_tricep_extension", exerciseName: "Overhead Tricep Extension", sets: 3, repMin: 10, repMax: 15, restSeconds: 60, rpeTarget: 8, orderIndex: 6),
            WorkoutExercise(exerciseID: "tricep_pushdown", exerciseName: "Cable Tricep Pushdown", sets: 3, repMin: 12, repMax: 20, restSeconds: 60, rpeTarget: 8, orderIndex: 7)
        ]

        let back = WorkoutDay(name: "Back & Biceps", dayNumber: 2, focus: .pull, estimatedMinutes: 70)
        back.exercises = [
            WorkoutExercise(exerciseID: "deadlift", exerciseName: "Conventional Deadlift", sets: 4, repMin: 3, repMax: 5, restSeconds: 240, rpeTarget: 8.5, orderIndex: 0),
            WorkoutExercise(exerciseID: "pull_up", exerciseName: "Pull-Up", sets: 4, repMin: 6, repMax: 10, restSeconds: 120, rpeTarget: 8, orderIndex: 1),
            WorkoutExercise(exerciseID: "barbell_row", exerciseName: "Barbell Row", sets: 4, repMin: 6, repMax: 8, restSeconds: 150, rpeTarget: 8, orderIndex: 2),
            WorkoutExercise(exerciseID: "lat_pulldown", exerciseName: "Lat Pulldown", sets: 3, repMin: 10, repMax: 12, restSeconds: 90, rpeTarget: 8, orderIndex: 3),
            WorkoutExercise(exerciseID: "dumbbell_row", exerciseName: "Single-Arm Dumbbell Row", sets: 3, repMin: 10, repMax: 12, restSeconds: 90, rpeTarget: 8, orderIndex: 4),
            WorkoutExercise(exerciseID: "face_pull", exerciseName: "Cable Face Pull", sets: 3, repMin: 15, repMax: 20, restSeconds: 60, rpeTarget: 7, orderIndex: 5),
            WorkoutExercise(exerciseID: "barbell_curl", exerciseName: "Barbell Curl", sets: 4, repMin: 8, repMax: 12, restSeconds: 75, rpeTarget: 8, orderIndex: 6),
            WorkoutExercise(exerciseID: "incline_dumbbell_curl", exerciseName: "Incline Dumbbell Curl", sets: 3, repMin: 10, repMax: 15, restSeconds: 60, rpeTarget: 8, orderIndex: 7),
            WorkoutExercise(exerciseID: "hammer_curl", exerciseName: "Hammer Curl", sets: 3, repMin: 12, repMax: 15, restSeconds: 60, rpeTarget: 8, orderIndex: 8)
        ]

        let shoulders = WorkoutDay(name: "Shoulders", dayNumber: 3, focus: .push, estimatedMinutes: 55)
        shoulders.exercises = [
            WorkoutExercise(exerciseID: "overhead_press", exerciseName: "Barbell Overhead Press", sets: 4, repMin: 5, repMax: 8, restSeconds: 150, rpeTarget: 8.5, orderIndex: 0),
            WorkoutExercise(exerciseID: "arnold_press", exerciseName: "Arnold Press", sets: 3, repMin: 10, repMax: 12, restSeconds: 90, rpeTarget: 8, orderIndex: 1),
            WorkoutExercise(exerciseID: "lateral_raise", exerciseName: "Dumbbell Lateral Raise", sets: 5, repMin: 12, repMax: 20, restSeconds: 60, rpeTarget: 8, orderIndex: 2),
            WorkoutExercise(exerciseID: "cable_lateral_raise", exerciseName: "Cable Lateral Raise", sets: 3, repMin: 15, repMax: 20, restSeconds: 60, rpeTarget: 8, orderIndex: 3),
            WorkoutExercise(exerciseID: "rear_delt_fly", exerciseName: "Rear Delt Fly", sets: 4, repMin: 15, repMax: 20, restSeconds: 60, rpeTarget: 7, orderIndex: 4),
            WorkoutExercise(exerciseID: "face_pull", exerciseName: "Cable Face Pull", sets: 3, repMin: 15, repMax: 20, restSeconds: 60, rpeTarget: 7, orderIndex: 5)
        ]

        let legs = WorkoutDay(name: "Legs", dayNumber: 4, focus: .legs, estimatedMinutes: 75)
        legs.exercises = [
            WorkoutExercise(exerciseID: "barbell_squat", exerciseName: "Barbell Back Squat", sets: 5, repMin: 4, repMax: 6, restSeconds: 240, rpeTarget: 8.5, orderIndex: 0),
            WorkoutExercise(exerciseID: "hack_squat", exerciseName: "Hack Squat", sets: 4, repMin: 8, repMax: 12, restSeconds: 120, rpeTarget: 8, orderIndex: 1),
            WorkoutExercise(exerciseID: "romanian_deadlift", exerciseName: "Romanian Deadlift", sets: 4, repMin: 8, repMax: 10, restSeconds: 120, rpeTarget: 8, orderIndex: 2),
            WorkoutExercise(exerciseID: "leg_curl", exerciseName: "Lying Leg Curl", sets: 4, repMin: 10, repMax: 15, restSeconds: 90, rpeTarget: 8, orderIndex: 3),
            WorkoutExercise(exerciseID: "leg_extension", exerciseName: "Leg Extension", sets: 4, repMin: 12, repMax: 15, restSeconds: 60, rpeTarget: 8, orderIndex: 4),
            WorkoutExercise(exerciseID: "hip_thrust", exerciseName: "Barbell Hip Thrust", sets: 4, repMin: 10, repMax: 15, restSeconds: 90, rpeTarget: 8, orderIndex: 5),
            WorkoutExercise(exerciseID: "calf_raise", exerciseName: "Standing Calf Raise", sets: 6, repMin: 10, repMax: 20, restSeconds: 60, rpeTarget: 8, orderIndex: 6)
        ]

        let armsAndAbs = WorkoutDay(name: "Arms & Core", dayNumber: 5, focus: .core, estimatedMinutes: 55)
        armsAndAbs.exercises = [
            WorkoutExercise(exerciseID: "barbell_curl", exerciseName: "Barbell Curl", sets: 4, repMin: 6, repMax: 10, restSeconds: 90, rpeTarget: 8.5, orderIndex: 0),
            WorkoutExercise(exerciseID: "incline_dumbbell_curl", exerciseName: "Incline Dumbbell Curl", sets: 3, repMin: 10, repMax: 15, restSeconds: 60, rpeTarget: 8, orderIndex: 1),
            WorkoutExercise(exerciseID: "cable_curl", exerciseName: "Cable Curl", sets: 3, repMin: 12, repMax: 15, restSeconds: 60, rpeTarget: 8, orderIndex: 2),
            WorkoutExercise(exerciseID: "skull_crusher", exerciseName: "Skull Crusher", sets: 4, repMin: 8, repMax: 12, restSeconds: 75, rpeTarget: 8, orderIndex: 3),
            WorkoutExercise(exerciseID: "tricep_pushdown", exerciseName: "Cable Tricep Pushdown", sets: 3, repMin: 12, repMax: 20, restSeconds: 60, rpeTarget: 8, orderIndex: 4),
            WorkoutExercise(exerciseID: "hanging_leg_raise", exerciseName: "Hanging Leg Raise", sets: 4, repMin: 10, repMax: 15, restSeconds: 60, rpeTarget: 8, orderIndex: 5),
            WorkoutExercise(exerciseID: "ab_wheel_rollout", exerciseName: "Ab Wheel Rollout", sets: 3, repMin: 8, repMax: 12, restSeconds: 60, rpeTarget: 8, orderIndex: 6),
            WorkoutExercise(exerciseID: "plank", exerciseName: "Plank", sets: 3, repMin: 30, repMax: 60, restSeconds: 45, rpeTarget: 7, notes: "Hold 30-60 seconds", orderIndex: 7)
        ]

        program.days = [chest, back, shoulders, legs, armsAndAbs]
        return program
    }

    // MARK: Full Body Fat Loss (3 days)
    static let fullBodyFatLoss = ProgramTemplate(
        id: "full_body_fat_loss",
        name: "Full Body Fat Loss",
        subtitle: "3-Day Recomposition Program",
        description: "Designed to preserve muscle while losing fat. Combines compound lifts with higher reps and shorter rest periods to maximize calorie burn and maintain strength.",
        durationWeeks: 12,
        daysPerWeek: 3,
        goal: .loseWeight,
        level: .beginner
    ) {
        let program = WorkoutProgram(
            name: "Full Body Fat Loss",
            description: "3-day fat loss and muscle preservation",
            durationWeeks: 12,
            daysPerWeek: 3,
            goal: .loseWeight,
            level: .beginner
        )

        let dayA = WorkoutDay(name: "Full Body A", dayNumber: 1, focus: .fullBody, estimatedMinutes: 45)
        dayA.exercises = [
            WorkoutExercise(exerciseID: "barbell_squat", exerciseName: "Barbell Back Squat", sets: 3, repMin: 10, repMax: 15, restSeconds: 60, rpeTarget: 8, orderIndex: 0),
            WorkoutExercise(exerciseID: "barbell_bench_press", exerciseName: "Barbell Bench Press", sets: 3, repMin: 10, repMax: 15, restSeconds: 60, rpeTarget: 8, orderIndex: 1),
            WorkoutExercise(exerciseID: "lat_pulldown", exerciseName: "Lat Pulldown", sets: 3, repMin: 10, repMax: 15, restSeconds: 60, rpeTarget: 8, orderIndex: 2),
            WorkoutExercise(exerciseID: "lunge", exerciseName: "Dumbbell Lunge", sets: 3, repMin: 12, repMax: 15, restSeconds: 60, rpeTarget: 8, orderIndex: 3),
            WorkoutExercise(exerciseID: "plank", exerciseName: "Plank", sets: 3, repMin: 30, repMax: 60, restSeconds: 45, rpeTarget: 7, notes: "Hold 30-60s", orderIndex: 4)
        ]

        let dayB = WorkoutDay(name: "Full Body B", dayNumber: 2, focus: .fullBody, estimatedMinutes: 45)
        dayB.exercises = [
            WorkoutExercise(exerciseID: "deadlift", exerciseName: "Conventional Deadlift", sets: 3, repMin: 8, repMax: 10, restSeconds: 90, rpeTarget: 8, orderIndex: 0),
            WorkoutExercise(exerciseID: "push_up", exerciseName: "Push-Up", sets: 3, repMin: 12, repMax: 20, restSeconds: 60, rpeTarget: 8, orderIndex: 1),
            WorkoutExercise(exerciseID: "dumbbell_row", exerciseName: "Single-Arm Dumbbell Row", sets: 3, repMin: 12, repMax: 15, restSeconds: 60, rpeTarget: 8, orderIndex: 2),
            WorkoutExercise(exerciseID: "hip_thrust", exerciseName: "Barbell Hip Thrust", sets: 3, repMin: 15, repMax: 20, restSeconds: 60, rpeTarget: 8, orderIndex: 3),
            WorkoutExercise(exerciseID: "dead_bug", exerciseName: "Dead Bug", sets: 3, repMin: 10, repMax: 10, restSeconds: 45, rpeTarget: 7, notes: "10 per side", orderIndex: 4)
        ]

        let dayC = WorkoutDay(name: "Full Body C", dayNumber: 3, focus: .fullBody, estimatedMinutes: 45)
        dayC.exercises = [
            WorkoutExercise(exerciseID: "goblet_squat", exerciseName: "Goblet Squat", sets: 4, repMin: 12, repMax: 20, restSeconds: 60, rpeTarget: 8, orderIndex: 0),
            WorkoutExercise(exerciseID: "dumbbell_bench_press", exerciseName: "Dumbbell Bench Press", sets: 3, repMin: 12, repMax: 15, restSeconds: 60, rpeTarget: 8, orderIndex: 1),
            WorkoutExercise(exerciseID: "cable_row", exerciseName: "Seated Cable Row", sets: 3, repMin: 12, repMax: 15, restSeconds: 60, rpeTarget: 8, orderIndex: 2),
            WorkoutExercise(exerciseID: "romanian_deadlift", exerciseName: "Romanian Deadlift", sets: 3, repMin: 12, repMax: 15, restSeconds: 60, rpeTarget: 8, orderIndex: 3),
            WorkoutExercise(exerciseID: "hanging_leg_raise", exerciseName: "Hanging Leg Raise", sets: 3, repMin: 10, repMax: 15, restSeconds: 45, rpeTarget: 7, orderIndex: 4)
        ]

        program.days = [dayA, dayB, dayC]
        return program
    }
}

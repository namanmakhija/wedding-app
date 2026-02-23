import Foundation

// Singleton that holds all static exercise data
final class ExerciseLibrary {
    static let shared = ExerciseLibrary()
    private(set) var all: [Exercise] = []
    private var index: [String: Exercise] = [:]

    private init() {
        all = Self.buildLibrary()
        index = Dictionary(uniqueKeysWithValues: all.map { ($0.id, $0) })
    }

    func exercise(id: String) -> Exercise? { index[id] }

    func exercises(for muscleGroup: MuscleGroup) -> [Exercise] {
        all.filter { $0.muscleGroups.contains(muscleGroup) }
    }

    func exercises(for category: ExerciseCategory) -> [Exercise] {
        all.filter { $0.category == category }
    }

    func exercises(equipment: [Equipment]) -> [Exercise] {
        all.filter { ex in ex.equipment.allSatisfy { equipment.contains($0) } }
    }

    // MARK: - Exercise Database

    private static func buildLibrary() -> [Exercise] {
        return chestExercises() + backExercises() + shoulderExercises() +
               bicepExercises() + tricepExercises() + legExercises() +
               coreExercises() + compoundExercises()
    }

    // MARK: - Chest

    private static func chestExercises() -> [Exercise] {
        [
            Exercise(
                id: "barbell_bench_press",
                name: "Barbell Bench Press",
                muscleGroups: [.chest, .triceps, .shoulders],
                primaryMuscle: .chest,
                equipment: [.barbell],
                difficulty: .intermediate,
                category: .push,
                instructions: [
                    "Lie flat on the bench with your eyes under the bar.",
                    "Grip the bar slightly wider than shoulder-width with a full grip.",
                    "Unrack the bar and hold it directly over your chest with arms locked.",
                    "Lower the bar to your mid-chest in a controlled manner, tucking elbows ~45°.",
                    "Touch the bar lightly to your chest without bouncing.",
                    "Press the bar back up explosively, driving your feet into the floor."
                ],
                tips: [
                    "Maintain a slight arch in your lower back — this is natural and protects the spine.",
                    "Keep your shoulder blades retracted and depressed throughout the lift.",
                    "The bar path should be slightly diagonal, not straight up and down.",
                    "Think about 'bending the bar' to engage the lats and protect the shoulders."
                ],
                commonMistakes: [
                    "Flaring the elbows to 90° — this stresses the shoulder joint excessively.",
                    "Bouncing the bar off the chest — removes tension and risks injury.",
                    "Lifting the hips off the bench — reduces stability and range of motion.",
                    "Using too wide a grip — increases shoulder impingement risk."
                ],
                videoURL: nil,
                thumbnailName: nil,
                isCompound: true,
                alternatives: ["dumbbell_bench_press", "incline_barbell_press", "push_up"]
            ),
            Exercise(
                id: "dumbbell_bench_press",
                name: "Dumbbell Bench Press",
                muscleGroups: [.chest, .triceps, .shoulders],
                primaryMuscle: .chest,
                equipment: [.dumbbell],
                difficulty: .beginner,
                category: .push,
                instructions: [
                    "Sit on the bench with dumbbells on your thighs, then kick them up as you lie back.",
                    "Hold the dumbbells at chest height with palms facing forward.",
                    "Press the dumbbells up and slightly inward until your arms are fully extended.",
                    "Lower them slowly back to the starting position with control.",
                    "Allow a full stretch at the bottom without losing tension."
                ],
                tips: [
                    "Dumbbells allow a greater range of motion than the barbell — use it.",
                    "Bring the dumbbells close together at the top to increase peak chest contraction.",
                    "Keep wrists stacked over elbows throughout the movement."
                ],
                commonMistakes: [
                    "Letting the dumbbells drift too far apart at the bottom.",
                    "Using a partial range of motion to lift heavier weight.",
                    "Losing shoulder blade retraction during the lift."
                ],
                videoURL: nil,
                thumbnailName: nil,
                isCompound: true,
                alternatives: ["barbell_bench_press", "cable_fly"]
            ),
            Exercise(
                id: "incline_barbell_press",
                name: "Incline Barbell Press",
                muscleGroups: [.chest, .triceps, .shoulders],
                primaryMuscle: .chest,
                equipment: [.barbell],
                difficulty: .intermediate,
                category: .push,
                instructions: [
                    "Set the bench to 30–45°. Steeper angles shift emphasis to the shoulders.",
                    "Grip the bar slightly wider than shoulder-width.",
                    "Lower the bar to your upper chest, just below your collarbone.",
                    "Press the bar up and slightly back over your upper chest.",
                    "Maintain control throughout — don't bounce."
                ],
                tips: [
                    "A 30° incline targets the upper chest more effectively than steeper angles.",
                    "Upper chest is often underdeveloped — prioritize this movement.",
                    "Imagine pushing your chest into the bar rather than pushing the bar away."
                ],
                commonMistakes: [
                    "Setting the bench too steep (past 45°) — becomes more of a shoulder press.",
                    "Lowering the bar to the mid-chest instead of upper chest.",
                    "Using excessive body momentum."
                ],
                videoURL: nil,
                thumbnailName: nil,
                isCompound: true,
                alternatives: ["incline_dumbbell_press", "barbell_bench_press"]
            ),
            Exercise(
                id: "incline_dumbbell_press",
                name: "Incline Dumbbell Press",
                muscleGroups: [.chest, .triceps, .shoulders],
                primaryMuscle: .chest,
                equipment: [.dumbbell],
                difficulty: .beginner,
                category: .push,
                instructions: [
                    "Set bench to 30–45° incline.",
                    "Kick the dumbbells up and press them over your upper chest.",
                    "Lower with control until you feel a full stretch in the upper chest.",
                    "Press back up, bringing the dumbbells slightly together at the top."
                ],
                tips: [
                    "The extra range of motion vs barbell version is a key advantage — use it.",
                    "Control the eccentric (lowering) phase for maximum muscle growth."
                ],
                commonMistakes: [
                    "Setting the incline too high.",
                    "Rushing the eccentric phase."
                ],
                videoURL: nil,
                thumbnailName: nil,
                isCompound: true,
                alternatives: ["incline_barbell_press", "cable_fly"]
            ),
            Exercise(
                id: "cable_fly",
                name: "Cable Fly (Low-to-High)",
                muscleGroups: [.chest, .shoulders],
                primaryMuscle: .chest,
                equipment: [.cables],
                difficulty: .beginner,
                category: .push,
                instructions: [
                    "Set the cable pulleys to the lowest position.",
                    "Grab the handles and step forward into a split stance.",
                    "With a slight bend in the elbows, bring the handles up and together in an arc.",
                    "Squeeze the chest at the top, then slowly return to the start."
                ],
                tips: [
                    "Cables keep constant tension on the chest throughout the movement — barbells and dumbbells do not.",
                    "Low-to-high angle targets the upper chest fibers effectively.",
                    "Focus on feeling the chest contract, not just moving the weight."
                ],
                commonMistakes: [
                    "Bending the elbows too much — turns it into a press.",
                    "Letting the weight pull your arms too far back and stressing the shoulder."
                ],
                videoURL: nil,
                thumbnailName: nil,
                isCompound: false,
                alternatives: ["dumbbell_fly", "pec_deck"]
            ),
            Exercise(
                id: "push_up",
                name: "Push-Up",
                muscleGroups: [.chest, .triceps, .shoulders],
                primaryMuscle: .chest,
                equipment: [.bodyweight],
                difficulty: .beginner,
                category: .push,
                instructions: [
                    "Start in a high plank with hands slightly wider than shoulder-width.",
                    "Maintain a rigid body line from head to heels — no sagging hips.",
                    "Lower your chest to just above the floor, keeping elbows at ~45°.",
                    "Press back up explosively without locking the elbows forcefully."
                ],
                tips: [
                    "Elevating feet targets the upper chest; hands elevated targets the lower chest.",
                    "Adding a pause at the bottom increases difficulty and muscle activation.",
                    "Squeeze your glutes and abs throughout to maintain a neutral spine."
                ],
                commonMistakes: [
                    "Sagging the hips — reduces core engagement and compresses the spine.",
                    "Flaring the elbows to 90°.",
                    "Short-range-of-motion reps."
                ],
                videoURL: nil,
                thumbnailName: nil,
                isCompound: true,
                alternatives: ["dumbbell_bench_press", "barbell_bench_press"]
            ),
            Exercise(
                id: "dip",
                name: "Chest Dip",
                muscleGroups: [.chest, .triceps, .shoulders],
                primaryMuscle: .chest,
                equipment: [.bodyweight],
                difficulty: .intermediate,
                category: .push,
                instructions: [
                    "Grip parallel bars and press yourself up with arms locked.",
                    "Lean your torso forward at ~30° to shift emphasis to the chest.",
                    "Lower yourself by bending the elbows until you feel a stretch in the chest.",
                    "Press back up to the starting position."
                ],
                tips: [
                    "The forward lean is critical — vertical torso targets triceps more.",
                    "Add weight with a belt once bodyweight becomes easy.",
                    "Go deep enough to get a full chest stretch."
                ],
                commonMistakes: [
                    "Staying too upright — minimizes chest activation.",
                    "Not going deep enough."
                ],
                videoURL: nil,
                thumbnailName: nil,
                isCompound: true,
                alternatives: ["barbell_bench_press", "cable_fly"]
            )
        ]
    }

    // MARK: - Back

    private static func backExercises() -> [Exercise] {
        [
            Exercise(
                id: "pull_up",
                name: "Pull-Up",
                muscleGroups: [.lats, .biceps, .traps, .back],
                primaryMuscle: .lats,
                equipment: [.pullupBar],
                difficulty: .intermediate,
                category: .pull,
                instructions: [
                    "Hang from the bar with an overhand grip, slightly wider than shoulder-width.",
                    "Depress your shoulder blades (pull them down and back) before initiating.",
                    "Pull your chest toward the bar by driving your elbows down and back.",
                    "Get your chin clearly over the bar, then lower with full control."
                ],
                tips: [
                    "Think 'elbows to your back pockets' to maximize lat engagement.",
                    "A full dead hang between reps increases range of motion and muscle growth.",
                    "Tuck a dumbbell between your feet or use a belt to add weight."
                ],
                commonMistakes: [
                    "Kipping or swinging — uses momentum instead of muscle.",
                    "Not achieving a full range of motion (chin must clear the bar).",
                    "Shrugging the shoulders up instead of depressing them."
                ],
                videoURL: nil,
                thumbnailName: nil,
                isCompound: true,
                alternatives: ["lat_pulldown", "assisted_pull_up"]
            ),
            Exercise(
                id: "lat_pulldown",
                name: "Lat Pulldown",
                muscleGroups: [.lats, .biceps, .traps],
                primaryMuscle: .lats,
                equipment: [.cables],
                difficulty: .beginner,
                category: .pull,
                instructions: [
                    "Sit at the pulldown machine with thighs secured under the pads.",
                    "Grip the bar slightly wider than shoulder-width with an overhand grip.",
                    "Lean back slightly (~15°) and pull the bar to your upper chest.",
                    "Drive your elbows down and back, squeezing the lats at the bottom.",
                    "Return the bar slowly under control to full arm extension."
                ],
                tips: [
                    "A slight backward lean mimics the angle of the pull-up more closely.",
                    "Initiate with your elbows, not your hands — think of your arms as hooks.",
                    "Full extension at the top is essential for lat stretch and growth."
                ],
                commonMistakes: [
                    "Pulling behind the neck — high injury risk with minimal benefit.",
                    "Leaning back too far — turns it into a row.",
                    "Using momentum to swing the weight down."
                ],
                videoURL: nil,
                thumbnailName: nil,
                isCompound: true,
                alternatives: ["pull_up", "cable_row"]
            ),
            Exercise(
                id: "barbell_row",
                name: "Barbell Row",
                muscleGroups: [.back, .lats, .biceps, .traps],
                primaryMuscle: .back,
                equipment: [.barbell],
                difficulty: .intermediate,
                category: .pull,
                instructions: [
                    "Stand with the bar over your mid-foot, hip-width stance.",
                    "Hinge at the hips until your torso is roughly parallel to the floor.",
                    "Grip the bar just outside your legs with an overhand grip.",
                    "Pull the bar into your lower ribcage/upper abdomen by driving the elbows back.",
                    "Squeeze the back at the top, then lower the bar back down with control."
                ],
                tips: [
                    "Keep your lower back neutral — don't round excessively.",
                    "A slight upward torso angle (not fully parallel) is fine and common.",
                    "Think about driving your elbows behind you, not pulling with your arms."
                ],
                commonMistakes: [
                    "Excessive body English — using hip momentum to row the weight up.",
                    "Pulling to the upper chest instead of the lower ribcage.",
                    "Rounding the lower back under heavy load."
                ],
                videoURL: nil,
                thumbnailName: nil,
                isCompound: true,
                alternatives: ["dumbbell_row", "cable_row"]
            ),
            Exercise(
                id: "dumbbell_row",
                name: "Single-Arm Dumbbell Row",
                muscleGroups: [.back, .lats, .biceps],
                primaryMuscle: .lats,
                equipment: [.dumbbell],
                difficulty: .beginner,
                category: .pull,
                instructions: [
                    "Place your knee and hand on a bench for support.",
                    "Hold a dumbbell in the free hand with arm extended toward the floor.",
                    "Pull the dumbbell up toward your hip, driving the elbow high.",
                    "Squeeze the lat at the top, then lower the dumbbell with control."
                ],
                tips: [
                    "Allow the shoulder to protract at the bottom for a full lat stretch.",
                    "Aim to pull the elbow past your torso — not just to hip level.",
                    "Use a neutral or pronated grip — both are effective."
                ],
                commonMistakes: [
                    "Rotating the torso to lift the weight — reduces lat isolation.",
                    "Not allowing full arm extension at the bottom."
                ],
                videoURL: nil,
                thumbnailName: nil,
                isCompound: false,
                alternatives: ["barbell_row", "cable_row"]
            ),
            Exercise(
                id: "cable_row",
                name: "Seated Cable Row",
                muscleGroups: [.back, .lats, .biceps, .traps],
                primaryMuscle: .back,
                equipment: [.cables],
                difficulty: .beginner,
                category: .pull,
                instructions: [
                    "Sit at the cable row station with knees slightly bent and feet on the platform.",
                    "Grip the handle and keep your torso upright.",
                    "Pull the handle into your lower abdomen by driving your elbows back.",
                    "Squeeze your shoulder blades together at the end of the movement.",
                    "Extend your arms fully to get a complete stretch in the back."
                ],
                tips: [
                    "Allow a slight forward lean when the arms are extended to increase range of motion.",
                    "A close-grip neutral handle works the mid-back; a wide overhand grip hits the lats more.",
                    "Don't lean back excessively — let your back do the work."
                ],
                commonMistakes: [
                    "Leaning back too far to generate momentum.",
                    "Not fully extending the arms between reps."
                ],
                videoURL: nil,
                thumbnailName: nil,
                isCompound: true,
                alternatives: ["barbell_row", "dumbbell_row"]
            ),
            Exercise(
                id: "deadlift",
                name: "Conventional Deadlift",
                muscleGroups: [.back, .glutes, .hamstrings, .traps, .lowerBack],
                primaryMuscle: .back,
                equipment: [.barbell],
                difficulty: .advanced,
                category: .pull,
                instructions: [
                    "Stand with the bar over your mid-foot, feet hip-width apart.",
                    "Hinge down and grip the bar just outside your shins.",
                    "Take a deep breath, brace your core, and create tension in the lats ('protect your armpits').",
                    "Push the floor away as you lift — don't yank the bar.",
                    "Lock out hips and knees simultaneously at the top.",
                    "Hinge back down, controlling the descent."
                ],
                tips: [
                    "Squeeze the bar hard and 'push the floor away' rather than thinking about pulling up.",
                    "Keep the bar in contact with your legs the entire lift.",
                    "The lockout comes from hip extension, not hyperextending the lower back."
                ],
                commonMistakes: [
                    "Rounding the lower back under heavy load — serious injury risk.",
                    "Bar drifting away from the body, increasing the lever arm.",
                    "Jerking the bar off the floor instead of applying smooth force."
                ],
                videoURL: nil,
                thumbnailName: nil,
                isCompound: true,
                alternatives: ["romanian_deadlift", "trap_bar_deadlift"]
            ),
            Exercise(
                id: "romanian_deadlift",
                name: "Romanian Deadlift",
                muscleGroups: [.hamstrings, .glutes, .lowerBack],
                primaryMuscle: .hamstrings,
                equipment: [.barbell],
                difficulty: .intermediate,
                category: .pull,
                instructions: [
                    "Stand holding the bar at hip height with an overhand grip.",
                    "With soft knees, hinge at the hips, pushing your butt back.",
                    "Lower the bar along your legs until you feel a deep hamstring stretch.",
                    "Drive your hips forward to return to standing — squeeze the glutes at the top."
                ],
                tips: [
                    "The hamstrings stretch under load in this movement — this is where growth happens.",
                    "Keep the bar close to your legs throughout.",
                    "How far you lower depends on your hamstring flexibility — don't round the back to get lower."
                ],
                commonMistakes: [
                    "Squatting down instead of hinging at the hip.",
                    "Rounding the back at the bottom.",
                    "Hyperextending the lower back at the top."
                ],
                videoURL: nil,
                thumbnailName: nil,
                isCompound: true,
                alternatives: ["deadlift", "dumbbell_rdl"]
            ),
            Exercise(
                id: "face_pull",
                name: "Cable Face Pull",
                muscleGroups: [.traps, .shoulders, .back],
                primaryMuscle: .traps,
                equipment: [.cables],
                difficulty: .beginner,
                category: .pull,
                instructions: [
                    "Set the cable to upper-chest height with a rope attachment.",
                    "Grab the rope with both hands, palms facing in, and step back.",
                    "Pull the rope toward your face, separating your hands as you pull.",
                    "Finish with your hands beside your ears and elbows flared high.",
                    "Pause briefly, then return under control."
                ],
                tips: [
                    "This exercise is critical for shoulder health and rear delt development.",
                    "Focus on external rotation at the top — elbows should end up above wrist level.",
                    "Use lighter weight and higher reps for this movement."
                ],
                commonMistakes: [
                    "Pulling to the neck instead of the face.",
                    "Not separating the hands — reduces external rotation."
                ],
                videoURL: nil,
                thumbnailName: nil,
                isCompound: false,
                alternatives: ["rear_delt_fly"]
            )
        ]
    }

    // MARK: - Shoulders

    private static func shoulderExercises() -> [Exercise] {
        [
            Exercise(
                id: "overhead_press",
                name: "Barbell Overhead Press",
                muscleGroups: [.shoulders, .triceps, .traps],
                primaryMuscle: .shoulders,
                equipment: [.barbell],
                difficulty: .intermediate,
                category: .push,
                instructions: [
                    "Hold the bar at shoulder height with a grip just outside shoulder-width.",
                    "Brace your core and glutes hard before pressing.",
                    "Press the bar overhead, moving your head back slightly to let the bar pass.",
                    "Lock out fully overhead, then lower under control to the starting position."
                ],
                tips: [
                    "At the top, shrug your traps up to fully elevate the shoulder — this builds upper traps.",
                    "Keep your ribs down and avoid excessive lumbar extension.",
                    "The bar should travel in a straight vertical line — this requires slight head movement."
                ],
                commonMistakes: [
                    "Pressing in front of the face instead of vertically.",
                    "Excessive lower back arch to compensate for poor shoulder mobility.",
                    "Not fully locking out at the top."
                ],
                videoURL: nil,
                thumbnailName: nil,
                isCompound: true,
                alternatives: ["dumbbell_shoulder_press", "seated_db_press"]
            ),
            Exercise(
                id: "dumbbell_shoulder_press",
                name: "Dumbbell Shoulder Press",
                muscleGroups: [.shoulders, .triceps],
                primaryMuscle: .shoulders,
                equipment: [.dumbbell],
                difficulty: .beginner,
                category: .push,
                instructions: [
                    "Sit on an upright bench with dumbbells at shoulder height, elbows at ~90°.",
                    "Press the dumbbells overhead until your arms are fully extended.",
                    "Lower them back to the starting position under full control."
                ],
                tips: [
                    "A neutral grip (palms facing each other) can reduce shoulder impingement risk.",
                    "Don't touch the dumbbells at the top — keep tension on the deltoids."
                ],
                commonMistakes: [
                    "Arching the lower back excessively.",
                    "Partial range of motion."
                ],
                videoURL: nil,
                thumbnailName: nil,
                isCompound: true,
                alternatives: ["overhead_press", "arnold_press"]
            ),
            Exercise(
                id: "lateral_raise",
                name: "Dumbbell Lateral Raise",
                muscleGroups: [.shoulders],
                primaryMuscle: .shoulders,
                equipment: [.dumbbell],
                difficulty: .beginner,
                category: .push,
                instructions: [
                    "Stand holding dumbbells at your sides with a slight bend in the elbows.",
                    "Raise the dumbbells out to the sides until they reach shoulder height.",
                    "Lead with your elbows and pinkies, not your palms.",
                    "Lower the dumbbells slowly — the eccentric phase is critical."
                ],
                tips: [
                    "Tilt the dumbbell slightly forward (like pouring a cup) to better align with the lateral delt.",
                    "The lateral delt is only significant mover for shoulder width — don't neglect it.",
                    "Cables or bands provide more consistent tension than dumbbells."
                ],
                commonMistakes: [
                    "Using momentum to swing the weight up.",
                    "Shrugging the traps as you raise — use lighter weight.",
                    "Dropping the weight too fast on the way down."
                ],
                videoURL: nil,
                thumbnailName: nil,
                isCompound: false,
                alternatives: ["cable_lateral_raise"]
            ),
            Exercise(
                id: "rear_delt_fly",
                name: "Rear Delt Fly",
                muscleGroups: [.shoulders, .traps, .back],
                primaryMuscle: .shoulders,
                equipment: [.dumbbell],
                difficulty: .beginner,
                category: .pull,
                instructions: [
                    "Hinge forward at the hips until your torso is nearly parallel to the floor.",
                    "Hold dumbbells hanging below you with palms facing each other.",
                    "Raise the dumbbells out to the sides in an arc, leading with your elbows.",
                    "Squeeze your rear delts at the top, then lower slowly."
                ],
                tips: [
                    "Rear delts are chronically undertrained — they're crucial for shoulder balance and health.",
                    "Use higher reps (15–25) with a lighter weight for rear delts.",
                    "A cable version provides superior tension at the stretched position."
                ],
                commonMistakes: [
                    "Using too much weight and turning it into a back exercise.",
                    "Not hinging forward enough."
                ],
                videoURL: nil,
                thumbnailName: nil,
                isCompound: false,
                alternatives: ["face_pull"]
            )
        ]
    }

    // MARK: - Biceps

    private static func bicepExercises() -> [Exercise] {
        [
            Exercise(
                id: "barbell_curl",
                name: "Barbell Curl",
                muscleGroups: [.biceps, .forearms],
                primaryMuscle: .biceps,
                equipment: [.barbell],
                difficulty: .beginner,
                category: .pull,
                instructions: [
                    "Stand with the bar at hip height, underhand grip shoulder-width apart.",
                    "Keep your elbows pinned to your sides and upper arms stationary.",
                    "Curl the bar up toward your chest by flexing the biceps.",
                    "Squeeze hard at the top, then lower slowly over 2–3 seconds."
                ],
                tips: [
                    "A slow eccentric (lowering) phase increases bicep muscle damage and growth.",
                    "The EZ-bar version can reduce wrist strain while maintaining effectiveness.",
                    "Full extension at the bottom maximizes the stretch stimulus."
                ],
                commonMistakes: [
                    "Swinging the body to lift the weight.",
                    "Not fully extending the arms at the bottom.",
                    "Letting the elbows drift forward."
                ],
                videoURL: nil,
                thumbnailName: nil,
                isCompound: false,
                alternatives: ["dumbbell_curl", "cable_curl"]
            ),
            Exercise(
                id: "dumbbell_curl",
                name: "Dumbbell Curl",
                muscleGroups: [.biceps, .forearms],
                primaryMuscle: .biceps,
                equipment: [.dumbbell],
                difficulty: .beginner,
                category: .pull,
                instructions: [
                    "Stand with dumbbells hanging at your sides, palms facing forward.",
                    "Curl one or both dumbbells up, keeping elbows pinned to your sides.",
                    "Supinate (rotate) your wrist as you lift to maximize bicep peak contraction.",
                    "Lower slowly back to full extension."
                ],
                tips: [
                    "Supination (rotating the wrist outward) at the top is unique to dumbbells and increases bicep activation.",
                    "Alternate arms to allow brief recovery between reps."
                ],
                commonMistakes: [
                    "Not supinating the wrist at the top.",
                    "Using momentum."
                ],
                videoURL: nil,
                thumbnailName: nil,
                isCompound: false,
                alternatives: ["barbell_curl", "hammer_curl", "incline_dumbbell_curl"]
            ),
            Exercise(
                id: "incline_dumbbell_curl",
                name: "Incline Dumbbell Curl",
                muscleGroups: [.biceps],
                primaryMuscle: .biceps,
                equipment: [.dumbbell],
                difficulty: .beginner,
                category: .pull,
                instructions: [
                    "Set a bench to a 45–60° incline and sit back on it.",
                    "Let the dumbbells hang behind you — this puts the biceps in a stretched position.",
                    "Curl the dumbbells up, keeping the upper arms stationary against the bench.",
                    "Squeeze at the top, then lower slowly back to full extension."
                ],
                tips: [
                    "The incline stretches the long head of the bicep — this variation is excellent for peak development.",
                    "The stretched position is where the most growth stimulus occurs.",
                    "Go lighter than you would for a standing curl."
                ],
                commonMistakes: [
                    "Bringing the elbows forward as you lift.",
                    "Not achieving full stretch at the bottom."
                ],
                videoURL: nil,
                thumbnailName: nil,
                isCompound: false,
                alternatives: ["barbell_curl", "cable_curl"]
            ),
            Exercise(
                id: "hammer_curl",
                name: "Hammer Curl",
                muscleGroups: [.biceps, .forearms],
                primaryMuscle: .biceps,
                equipment: [.dumbbell],
                difficulty: .beginner,
                category: .pull,
                instructions: [
                    "Hold dumbbells at your sides with a neutral grip (thumbs up).",
                    "Curl the dumbbells up without rotating the wrists.",
                    "Keep elbows pinned and squeeze at the top.",
                    "Lower under control."
                ],
                tips: [
                    "Hammer curls target the brachialis, which lies under the biceps and adds arm thickness.",
                    "The brachialis pushes the bicep up, making the arm appear larger and more peaked."
                ],
                commonMistakes: [
                    "Rotating the wrists (this converts it to a regular curl)."
                ],
                videoURL: nil,
                thumbnailName: nil,
                isCompound: false,
                alternatives: ["barbell_curl", "cable_curl"]
            )
        ]
    }

    // MARK: - Triceps

    private static func tricepExercises() -> [Exercise] {
        [
            Exercise(
                id: "tricep_pushdown",
                name: "Cable Tricep Pushdown",
                muscleGroups: [.triceps],
                primaryMuscle: .triceps,
                equipment: [.cables],
                difficulty: .beginner,
                category: .push,
                instructions: [
                    "Set the cable to the highest position with a straight bar or rope.",
                    "Grip the attachment and tuck your elbows into your sides.",
                    "Push the bar/rope downward until your arms are fully extended.",
                    "Hold the contraction briefly, then return under control."
                ],
                tips: [
                    "The triceps make up ~2/3 of upper arm size — they're more important than biceps for arm size.",
                    "A rope attachment allows you to spread the rope at the bottom for a stronger squeeze.",
                    "Keep elbows locked in place — don't let them drift forward."
                ],
                commonMistakes: [
                    "Letting the elbows flare out or drift forward.",
                    "Using body weight to push the weight down."
                ],
                videoURL: nil,
                thumbnailName: nil,
                isCompound: false,
                alternatives: ["overhead_tricep_extension", "skull_crusher"]
            ),
            Exercise(
                id: "overhead_tricep_extension",
                name: "Overhead Tricep Extension",
                muscleGroups: [.triceps],
                primaryMuscle: .triceps,
                equipment: [.dumbbell, .cables],
                difficulty: .beginner,
                category: .push,
                instructions: [
                    "Hold a dumbbell with both hands overhead, arms extended.",
                    "Lower the dumbbell behind your head by bending only at the elbows.",
                    "Keep your elbows pointing forward — don't let them flare.",
                    "Extend back to the start by squeezing the triceps."
                ],
                tips: [
                    "The overhead position stretches the long head of the triceps, which is the largest portion.",
                    "Research shows overhead tricep exercises result in superior long head growth.",
                    "A cable overhead version provides more consistent tension."
                ],
                commonMistakes: [
                    "Flaring the elbows outward.",
                    "Moving the upper arms instead of just the forearms."
                ],
                videoURL: nil,
                thumbnailName: nil,
                isCompound: false,
                alternatives: ["skull_crusher", "tricep_pushdown"]
            ),
            Exercise(
                id: "skull_crusher",
                name: "Skull Crusher (Lying Tricep Extension)",
                muscleGroups: [.triceps],
                primaryMuscle: .triceps,
                equipment: [.barbell, .dumbbell],
                difficulty: .intermediate,
                category: .push,
                instructions: [
                    "Lie on a flat bench holding an EZ-bar or dumbbells over your chest.",
                    "Lower the weight toward your forehead by bending only at the elbows.",
                    "Just before the weight reaches your head, extend back to the start.",
                    "Keep your upper arms perpendicular to the floor throughout."
                ],
                tips: [
                    "Slightly angling the upper arms toward the head puts the long head in a stretched position.",
                    "Use the EZ-bar for wrist comfort.",
                    "Spot this exercise — the bar passes near your head."
                ],
                commonMistakes: [
                    "Letting the upper arms move during the exercise.",
                    "Using too heavy a weight and losing control."
                ],
                videoURL: nil,
                thumbnailName: nil,
                isCompound: false,
                alternatives: ["overhead_tricep_extension", "tricep_pushdown"]
            )
        ]
    }

    // MARK: - Legs

    private static func legExercises() -> [Exercise] {
        [
            Exercise(
                id: "barbell_squat",
                name: "Barbell Back Squat",
                muscleGroups: [.quads, .glutes, .hamstrings],
                primaryMuscle: .quads,
                equipment: [.barbell],
                difficulty: .advanced,
                category: .legs,
                instructions: [
                    "Set the bar on the rack at upper-chest height. Duck under and position it on your upper traps (high bar) or lower traps (low bar).",
                    "Grip the bar, unrack it, and step back into a shoulder-width stance.",
                    "Take a deep breath, brace your core hard, and break at the hips and knees simultaneously.",
                    "Descend until your thighs are at least parallel to the floor.",
                    "Drive through your heels and mid-foot to stand back up.",
                    "Keep your chest up and knees tracking over your toes throughout."
                ],
                tips: [
                    "Knees caving inward is a sign of weak glutes — focus on 'spreading the floor' with your feet.",
                    "The Valsalva maneuver (holding your breath and bracing) is crucial for spinal safety.",
                    "High bar squats are more quad-dominant; low bar squats are more posterior chain."
                ],
                commonMistakes: [
                    "Knees caving inward (valgus collapse).",
                    "Butt wink (posterior pelvic tilt at the bottom) — often from poor mobility.",
                    "Rising on the toes — keep the full foot in contact with the floor.",
                    "Not reaching parallel depth."
                ],
                videoURL: nil,
                thumbnailName: nil,
                isCompound: true,
                alternatives: ["goblet_squat", "leg_press", "hack_squat"]
            ),
            Exercise(
                id: "goblet_squat",
                name: "Goblet Squat",
                muscleGroups: [.quads, .glutes],
                primaryMuscle: .quads,
                equipment: [.dumbbell, .kettlebell],
                difficulty: .beginner,
                category: .legs,
                instructions: [
                    "Hold a dumbbell or kettlebell at chest height with both hands.",
                    "Stand with feet shoulder-width apart, toes slightly flared.",
                    "Squat down, keeping the weight close to your chest.",
                    "Drive your elbows between your knees at the bottom to open up the hips.",
                    "Press through the floor to stand back up."
                ],
                tips: [
                    "An excellent teaching tool for squat mechanics before loading with a barbell.",
                    "The counterbalance of the weight in front helps you sit back into the squat.",
                    "Great for improving ankle and hip mobility."
                ],
                commonMistakes: [
                    "Leaning too far forward.",
                    "Not getting to parallel depth."
                ],
                videoURL: nil,
                thumbnailName: nil,
                isCompound: true,
                alternatives: ["barbell_squat", "leg_press"]
            ),
            Exercise(
                id: "leg_press",
                name: "Leg Press",
                muscleGroups: [.quads, .glutes, .hamstrings],
                primaryMuscle: .quads,
                equipment: [.machine],
                difficulty: .beginner,
                category: .legs,
                instructions: [
                    "Sit in the leg press machine with your back flat against the pad.",
                    "Place your feet shoulder-width apart on the platform, mid-height.",
                    "Unrack and lower the platform by bending the knees to ~90°.",
                    "Push the platform back up without locking out the knees fully."
                ],
                tips: [
                    "Foot position changes emphasis: lower = more quads, higher = more glutes/hamstrings.",
                    "A full range of motion (knees to chest) provides greater muscle growth stimulus.",
                    "Don't let the lower back round off the pad at the bottom."
                ],
                commonMistakes: [
                    "Rounding the lower back off the seat.",
                    "Using a partial range of motion to load more weight.",
                    "Letting the knees cave inward."
                ],
                videoURL: nil,
                thumbnailName: nil,
                isCompound: true,
                alternatives: ["barbell_squat", "hack_squat"]
            ),
            Exercise(
                id: "hack_squat",
                name: "Hack Squat",
                muscleGroups: [.quads, .glutes],
                primaryMuscle: .quads,
                equipment: [.machine],
                difficulty: .intermediate,
                category: .legs,
                instructions: [
                    "Step into the hack squat machine and position your shoulders under the pads.",
                    "Feet should be shoulder-width on the platform, toes slightly flared.",
                    "Lower by bending at the knees, keeping your back against the pad.",
                    "Go as deep as your mobility allows, then drive through to the starting position."
                ],
                tips: [
                    "The hack squat places your torso in a fixed upright position, maximizing quad emphasis.",
                    "A narrower, lower foot placement increases quad activation.",
                    "Great alternative to barbell squats for quad development without the technical demand."
                ],
                commonMistakes: [
                    "Not going deep enough.",
                    "Knees caving inward."
                ],
                videoURL: nil,
                thumbnailName: nil,
                isCompound: true,
                alternatives: ["barbell_squat", "leg_press"]
            ),
            Exercise(
                id: "leg_curl",
                name: "Lying Leg Curl",
                muscleGroups: [.hamstrings],
                primaryMuscle: .hamstrings,
                equipment: [.machine],
                difficulty: .beginner,
                category: .legs,
                instructions: [
                    "Lie face down on the leg curl machine with the pad just below your calves.",
                    "Curl your legs up toward your glutes as far as possible.",
                    "Squeeze the hamstrings hard at the top.",
                    "Lower slowly — a 2–3 second negative is ideal."
                ],
                tips: [
                    "Hamstrings are best trained with both hip extension (RDL) and knee flexion (leg curl).",
                    "Plantarflexing the foot (pointing toes) slightly increases hamstring activation.",
                    "The seated leg curl keeps the hamstring in a more stretched position."
                ],
                commonMistakes: [
                    "Rushing the eccentric phase.",
                    "Hyperextending the lower back as you curl."
                ],
                videoURL: nil,
                thumbnailName: nil,
                isCompound: false,
                alternatives: ["romanian_deadlift"]
            ),
            Exercise(
                id: "hip_thrust",
                name: "Barbell Hip Thrust",
                muscleGroups: [.glutes, .hamstrings],
                primaryMuscle: .glutes,
                equipment: [.barbell],
                difficulty: .intermediate,
                category: .legs,
                instructions: [
                    "Sit with your upper back against a bench and roll a barbell over your hips.",
                    "Plant your feet flat on the floor, hip-width apart.",
                    "Drive through your heels and thrust your hips upward.",
                    "Squeeze your glutes hard at the top — your torso should be parallel to the floor.",
                    "Lower under control back to the starting position."
                ],
                tips: [
                    "The hip thrust is one of the most effective exercises for glute development.",
                    "A pad or foam roll under the bar protects your hips.",
                    "Chin to chest at the top to maintain a neutral spine — don't hyperextend."
                ],
                commonMistakes: [
                    "Not achieving full hip extension at the top.",
                    "Hyperextending the lower back.",
                    "Feet too far forward or backward."
                ],
                videoURL: nil,
                thumbnailName: nil,
                isCompound: false,
                alternatives: ["glute_bridge"]
            ),
            Exercise(
                id: "leg_extension",
                name: "Leg Extension",
                muscleGroups: [.quads],
                primaryMuscle: .quads,
                equipment: [.machine],
                difficulty: .beginner,
                category: .legs,
                instructions: [
                    "Sit in the leg extension machine with the pad just above your ankles.",
                    "Extend your legs until they are fully straight.",
                    "Squeeze the quads hard at the top for 1 second.",
                    "Lower slowly under control."
                ],
                tips: [
                    "Leg extensions isolate the quads — excellent as a finisher or for direct quad work.",
                    "The rectus femoris (one of the quad heads) crosses the hip, making it hard to fully activate in squats.",
                    "Full knee extension maximizes the peak contraction."
                ],
                commonMistakes: [
                    "Rushing the exercise.",
                    "Not fully extending the knee."
                ],
                videoURL: nil,
                thumbnailName: nil,
                isCompound: false,
                alternatives: ["barbell_squat"]
            ),
            Exercise(
                id: "calf_raise",
                name: "Standing Calf Raise",
                muscleGroups: [.calves],
                primaryMuscle: .calves,
                equipment: [.machine, .barbell],
                difficulty: .beginner,
                category: .legs,
                instructions: [
                    "Stand with the balls of your feet on the edge of a platform.",
                    "Lower your heels as far as possible for a full stretch.",
                    "Rise up on your tiptoes as high as possible.",
                    "Hold the peak contraction for 1 second, then lower slowly."
                ],
                tips: [
                    "The calves are very resistant to training — they need high volume and full range of motion.",
                    "A full stretch at the bottom is critical — bouncing from a shortened position limits growth.",
                    "Slow eccentrics (3–5 seconds down) are particularly effective for calves."
                ],
                commonMistakes: [
                    "Bouncing through partial reps.",
                    "Not getting a full stretch at the bottom."
                ],
                videoURL: nil,
                thumbnailName: nil,
                isCompound: false,
                alternatives: []
            ),
            Exercise(
                id: "lunge",
                name: "Dumbbell Lunge",
                muscleGroups: [.quads, .glutes, .hamstrings],
                primaryMuscle: .quads,
                equipment: [.dumbbell],
                difficulty: .beginner,
                category: .legs,
                instructions: [
                    "Stand holding dumbbells at your sides.",
                    "Step forward with one foot and lower your rear knee toward the floor.",
                    "Keep your front knee over your toes.",
                    "Push through your front heel to return to standing.",
                    "Alternate legs each rep or complete all reps on one side."
                ],
                tips: [
                    "The longer your stride, the more glute activation. Shorter strides = more quads.",
                    "Walking lunges increase the difficulty and add a balance component."
                ],
                commonMistakes: [
                    "Front knee caving inward.",
                    "Too short a stride, causing the front knee to go far past the toes."
                ],
                videoURL: nil,
                thumbnailName: nil,
                isCompound: true,
                alternatives: ["barbell_squat", "leg_press"]
            )
        ]
    }

    // MARK: - Core

    private static func coreExercises() -> [Exercise] {
        [
            Exercise(
                id: "plank",
                name: "Plank",
                muscleGroups: [.abs, .lowerBack],
                primaryMuscle: .abs,
                equipment: [.bodyweight],
                difficulty: .beginner,
                category: .core,
                instructions: [
                    "Get into a forearm plank position with elbows under shoulders.",
                    "Form a straight line from head to heels — no sagging or piking.",
                    "Squeeze your glutes and abs hard.",
                    "Hold for the prescribed time."
                ],
                tips: [
                    "Quality over duration — a 30-second plank with perfect form beats 2 minutes of sagging.",
                    "Push the floor away with your forearms to increase lat and core activation."
                ],
                commonMistakes: [
                    "Sagging hips.",
                    "Piking the hips up too high.",
                    "Holding the breath instead of breathing steadily."
                ],
                videoURL: nil,
                thumbnailName: nil,
                isCompound: false,
                alternatives: ["ab_wheel_rollout", "dead_bug"]
            ),
            Exercise(
                id: "ab_wheel_rollout",
                name: "Ab Wheel Rollout",
                muscleGroups: [.abs, .lowerBack],
                primaryMuscle: .abs,
                equipment: [.bodyweight],
                difficulty: .advanced,
                category: .core,
                instructions: [
                    "Kneel on the floor holding the ab wheel.",
                    "Brace your core and roll the wheel forward, extending your body.",
                    "Go as far as you can without your hips dropping or lower back arching.",
                    "Engage your abs to pull the wheel back to the starting position."
                ],
                tips: [
                    "One of the most effective ab exercises for building a strong, stable core.",
                    "Think about 'pulling your ribcage toward your pelvis' during the rollout.",
                    "Start with a partial range and gradually increase as you get stronger."
                ],
                commonMistakes: [
                    "Letting the hips sag on the way out.",
                    "Using the hip flexors instead of the abs to return."
                ],
                videoURL: nil,
                thumbnailName: nil,
                isCompound: false,
                alternatives: ["plank", "hanging_leg_raise"]
            ),
            Exercise(
                id: "hanging_leg_raise",
                name: "Hanging Leg Raise",
                muscleGroups: [.abs, .obliques],
                primaryMuscle: .abs,
                equipment: [.pullupBar],
                difficulty: .intermediate,
                category: .core,
                instructions: [
                    "Hang from a pull-up bar with straight arms.",
                    "Brace your core and raise your legs until they are parallel to the floor (or higher).",
                    "Control the descent — don't swing.",
                    "Keep the movement strict — no kipping."
                ],
                tips: [
                    "Posterior pelvic tilt (tucking the pelvis) at the top maximizes rectus abdominis contraction.",
                    "Bent knee version is easier; straight leg version is more advanced.",
                    "The hanging position also provides a lat stretch."
                ],
                commonMistakes: [
                    "Swinging and using momentum.",
                    "Not tilting the pelvis at the top."
                ],
                videoURL: nil,
                thumbnailName: nil,
                isCompound: false,
                alternatives: ["plank", "ab_wheel_rollout"]
            ),
            Exercise(
                id: "dead_bug",
                name: "Dead Bug",
                muscleGroups: [.abs, .lowerBack],
                primaryMuscle: .abs,
                equipment: [.bodyweight],
                difficulty: .beginner,
                category: .core,
                instructions: [
                    "Lie on your back with arms pointing to the ceiling and knees bent at 90°.",
                    "Press your lower back into the floor and brace your core.",
                    "Slowly extend the opposite arm and leg toward the floor simultaneously.",
                    "Return to start and repeat on the other side."
                ],
                tips: [
                    "The key is keeping your lower back pressed into the floor throughout.",
                    "An excellent anti-extension core exercise that is safe for beginners.",
                    "Breathe out as you extend — this helps maintain intra-abdominal pressure."
                ],
                commonMistakes: [
                    "Letting the lower back arch off the floor.",
                    "Moving too fast — this is a slow, controlled exercise."
                ],
                videoURL: nil,
                thumbnailName: nil,
                isCompound: false,
                alternatives: ["plank"]
            )
        ]
    }

    // MARK: - Additional Compounds

    private static func compoundExercises() -> [Exercise] {
        [
            Exercise(
                id: "trap_bar_deadlift",
                name: "Trap Bar Deadlift",
                muscleGroups: [.quads, .glutes, .hamstrings, .back, .traps],
                primaryMuscle: .quads,
                equipment: [.trapBar],
                difficulty: .intermediate,
                category: .legs,
                instructions: [
                    "Stand inside the trap bar with feet hip-width apart.",
                    "Hinge down and grip the handles.",
                    "Brace your core, take a deep breath, and drive through your legs.",
                    "Stand tall at the top, then lower the bar with control."
                ],
                tips: [
                    "More quad-dominant than the conventional deadlift due to more upright torso.",
                    "Great option for beginners learning to hinge.",
                    "The neutral grip reduces wrist strain."
                ],
                commonMistakes: [
                    "Rounding the lower back.",
                    "Letting the hips rise faster than the shoulders."
                ],
                videoURL: nil,
                thumbnailName: nil,
                isCompound: true,
                alternatives: ["deadlift", "barbell_squat"]
            ),
            Exercise(
                id: "glute_bridge",
                name: "Glute Bridge",
                muscleGroups: [.glutes, .hamstrings],
                primaryMuscle: .glutes,
                equipment: [.bodyweight],
                difficulty: .beginner,
                category: .legs,
                instructions: [
                    "Lie on your back with knees bent and feet flat on the floor.",
                    "Drive through your heels to lift your hips toward the ceiling.",
                    "Squeeze your glutes hard at the top.",
                    "Lower your hips back to the floor slowly."
                ],
                tips: [
                    "An accessible alternative to the hip thrust.",
                    "Add a barbell or dumbbell across the hips to increase difficulty."
                ],
                commonMistakes: [
                    "Not fully extending at the top.",
                    "Hyperextending the lower back."
                ],
                videoURL: nil,
                thumbnailName: nil,
                isCompound: false,
                alternatives: ["hip_thrust"]
            ),
            Exercise(
                id: "cable_curl",
                name: "Cable Curl",
                muscleGroups: [.biceps, .forearms],
                primaryMuscle: .biceps,
                equipment: [.cables],
                difficulty: .beginner,
                category: .pull,
                instructions: [
                    "Set the cable to the lowest position with a straight bar or EZ-bar.",
                    "Stand and curl the bar up to your chin.",
                    "Squeeze at the top, then lower slowly.",
                    "Don't let the weight touch the stack between reps — maintain tension."
                ],
                tips: [
                    "Cables provide constant tension throughout the range of motion, unlike free weights.",
                    "Standing with your arms slightly in front of you (behind the cable line) places the biceps in a more stretched position."
                ],
                commonMistakes: [
                    "Using momentum.",
                    "Letting the elbows drift forward."
                ],
                videoURL: nil,
                thumbnailName: nil,
                isCompound: false,
                alternatives: ["barbell_curl", "dumbbell_curl"]
            ),
            Exercise(
                id: "arnold_press",
                name: "Arnold Press",
                muscleGroups: [.shoulders, .triceps],
                primaryMuscle: .shoulders,
                equipment: [.dumbbell],
                difficulty: .intermediate,
                category: .push,
                instructions: [
                    "Start with dumbbells at shoulder height, palms facing you.",
                    "As you press the dumbbells overhead, rotate your palms to face outward.",
                    "Finish with a full overhead extension and palms facing forward.",
                    "Reverse the movement on the way down."
                ],
                tips: [
                    "The rotation hits the anterior and lateral delts through a wider range of motion.",
                    "Invented by Arnold Schwarzenegger to maximize shoulder activation."
                ],
                commonMistakes: [
                    "Rushing the rotation.",
                    "Not achieving full extension at the top."
                ],
                videoURL: nil,
                thumbnailName: nil,
                isCompound: true,
                alternatives: ["dumbbell_shoulder_press", "overhead_press"]
            ),
            Exercise(
                id: "seated_db_press",
                name: "Seated Dumbbell Shoulder Press",
                muscleGroups: [.shoulders, .triceps],
                primaryMuscle: .shoulders,
                equipment: [.dumbbell],
                difficulty: .beginner,
                category: .push,
                instructions: [
                    "Sit on an upright bench holding dumbbells at shoulder height.",
                    "Press the dumbbells overhead to full extension.",
                    "Lower under control back to shoulder height."
                ],
                tips: [
                    "The seated position reduces the ability to use leg drive, increasing shoulder demand.",
                    "Keep core braced to protect the lower back."
                ],
                commonMistakes: [
                    "Arching the lower back excessively.",
                    "Partial reps."
                ],
                videoURL: nil,
                thumbnailName: nil,
                isCompound: true,
                alternatives: ["overhead_press", "arnold_press"]
            ),
            Exercise(
                id: "pec_deck",
                name: "Pec Deck / Machine Fly",
                muscleGroups: [.chest],
                primaryMuscle: .chest,
                equipment: [.machine],
                difficulty: .beginner,
                category: .push,
                instructions: [
                    "Sit in the machine with pads or handles at chest height.",
                    "Push the pads together in an arc, squeezing the chest at the peak.",
                    "Control the return — don't let the weight stretch your chest too aggressively."
                ],
                tips: [
                    "Great for isolation — removes triceps from the movement.",
                    "The machine guides the path, making it easy to learn the chest squeeze."
                ],
                commonMistakes: [
                    "Letting the pads come back too far, stressing the shoulder joint.",
                    "Using too much weight and losing the squeeze."
                ],
                videoURL: nil,
                thumbnailName: nil,
                isCompound: false,
                alternatives: ["cable_fly", "dumbbell_bench_press"]
            ),
            Exercise(
                id: "dumbbell_fly",
                name: "Dumbbell Fly",
                muscleGroups: [.chest, .shoulders],
                primaryMuscle: .chest,
                equipment: [.dumbbell],
                difficulty: .beginner,
                category: .push,
                instructions: [
                    "Lie on a flat bench holding dumbbells above your chest.",
                    "With a slight bend in the elbows, lower the dumbbells out to the sides in an arc.",
                    "Stop when you feel a strong stretch in the chest.",
                    "Squeeze the chest to bring the dumbbells back to the start."
                ],
                tips: [
                    "Think of hugging a giant tree — that's the motion.",
                    "Don't go so deep that the shoulder feels uncomfortable."
                ],
                commonMistakes: [
                    "Bending the elbows too much — converts it to a press.",
                    "Going too heavy, which limits range of motion."
                ],
                videoURL: nil,
                thumbnailName: nil,
                isCompound: false,
                alternatives: ["cable_fly", "pec_deck"]
            ),
            Exercise(
                id: "cable_lateral_raise",
                name: "Cable Lateral Raise",
                muscleGroups: [.shoulders],
                primaryMuscle: .shoulders,
                equipment: [.cables],
                difficulty: .beginner,
                category: .push,
                instructions: [
                    "Set a cable to the lowest position and stand beside it.",
                    "Grab the handle with the far hand and raise your arm out to the side.",
                    "Stop at shoulder height, then lower under control."
                ],
                tips: [
                    "Cables provide superior tension at the bottom of the movement vs dumbbells.",
                    "Cross-body cable raises maintain tension throughout the entire range."
                ],
                commonMistakes: [
                    "Shrugging the traps.",
                    "Using momentum."
                ],
                videoURL: nil,
                thumbnailName: nil,
                isCompound: false,
                alternatives: ["lateral_raise"]
            )
        ]
    }
}

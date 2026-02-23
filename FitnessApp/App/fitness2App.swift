import SwiftUI
import SwiftData

@main
struct fitness2App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [
            UserProfile.self,
            WorkoutProgram.self,
            WorkoutDay.self,
            WorkoutExercise.self,
            WorkoutLog.self,
            ExerciseSetLog.self,
            FoodItem.self,
            NutritionLog.self,
            NutritionEntry.self,
            BodyMeasurement.self,
            PersonalRecord.self
        ])
    }
}

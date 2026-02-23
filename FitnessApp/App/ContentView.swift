import SwiftUI
import SwiftData

struct ContentView: View {
    @Query private var profiles: [UserProfile]
    @State private var selectedTab: Tab = .home
    @State private var showOnboarding = false

    var body: some View {
        Group {
            if profiles.isEmpty || showOnboarding {
                OnboardingView(showOnboarding: $showOnboarding)
            } else {
                MainTabView(selectedTab: $selectedTab)
            }
        }
        .onAppear {
            if profiles.isEmpty {
                showOnboarding = true
            }
        }
    }
}

enum Tab: String, CaseIterable {
    case home = "Home"
    case workout = "Workout"
    case nutrition = "Nutrition"
    case progress = "Progress"
    case profile = "Profile"

    var icon: String {
        switch self {
        case .home: return "house.fill"
        case .workout: return "dumbbell.fill"
        case .nutrition: return "fork.knife"
        case .progress: return "chart.line.uptrend.xyaxis"
        case .profile: return "person.fill"
        }
    }
}

struct MainTabView: View {
    @Binding var selectedTab: Tab

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem { Label(Tab.home.rawValue, systemImage: Tab.home.icon) }
                .tag(Tab.home)

            WorkoutProgramView()
                .tabItem { Label(Tab.workout.rawValue, systemImage: Tab.workout.icon) }
                .tag(Tab.workout)

            NutritionView()
                .tabItem { Label(Tab.nutrition.rawValue, systemImage: Tab.nutrition.icon) }
                .tag(Tab.nutrition)

            ProgressTrackingView()
                .tabItem { Label(Tab.progress.rawValue, systemImage: Tab.progress.icon) }
                .tag(Tab.progress)

            ProfileView()
                .tabItem { Label(Tab.profile.rawValue, systemImage: Tab.profile.icon) }
                .tag(Tab.profile)
        }
        .tint(.blue)
    }
}

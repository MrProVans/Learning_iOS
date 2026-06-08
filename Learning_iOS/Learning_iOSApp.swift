import SwiftUI

@main
struct Learning_iOSApp: App {
    @StateObject private var localization = LocalizationManager.shared
    @StateObject private var notifications = NotificationManager.shared
    @StateObject private var feedback = AppFeedbackManager.shared
    @AppStorage("has_completed_onboarding") private var hasCompletedOnboarding = false

    var body: some Scene {
        WindowGroup {
            Group {
                if hasCompletedOnboarding {
                    RootTabView()
                } else {
                    OnboardingView {
                        hasCompletedOnboarding = true
                    }
                }
            }
            .environmentObject(localization)
            .environmentObject(notifications)
            .environmentObject(feedback)
            .preferredColorScheme(.dark)
        }
    }
}

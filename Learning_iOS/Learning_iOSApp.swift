import SwiftUI

@main
struct Learning_iOSApp: App {
    @StateObject private var localization = LocalizationManager.shared
    @StateObject private var notifications = NotificationManager.shared
    @StateObject private var feedback = AppFeedbackManager.shared

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environmentObject(localization)
                .environmentObject(notifications)
                .environmentObject(feedback)
                .preferredColorScheme(.dark)
        }
    }
}

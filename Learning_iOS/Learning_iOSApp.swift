import SwiftUI

@main
struct Learning_iOSApp: App {
    @StateObject private var localization = LocalizationManager.shared
    @StateObject private var notifications = NotificationManager.shared

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environmentObject(localization)
                .environmentObject(notifications)
                .preferredColorScheme(.dark)
        }
    }
}

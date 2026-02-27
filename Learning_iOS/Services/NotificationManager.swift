import Foundation
import Combine
import UserNotifications

final class NotificationManager: ObservableObject {
    static let shared = NotificationManager()

    @Published var notificationsEnabled: Bool
    @Published var defaultReminderTime: Date

    private let enabledKey = "notifications_enabled"
    private let timeKey = "default_reminder_time"

    private init() {
        notificationsEnabled = UserDefaults.standard.bool(forKey: enabledKey)

        if let savedTime = UserDefaults.standard.object(forKey: timeKey) as? Date {
            defaultReminderTime = savedTime
        } else {
            defaultReminderTime = Calendar.current.date(from: DateComponents(hour: 20, minute: 0)) ?? Date()
        }
    }

    func setNotificationsEnabled(_ enabled: Bool) async -> Bool {
        if enabled {
            let granted = await requestPermissionIfNeeded()
            DispatchQueue.main.async {
                self.notificationsEnabled = granted
                UserDefaults.standard.set(granted, forKey: self.enabledKey)
            }
            if !granted {
                return false
            }
            return true
        } else {
            DispatchQueue.main.async {
                self.notificationsEnabled = false
                UserDefaults.standard.set(false, forKey: self.enabledKey)
            }
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            return true
        }
    }

    func setDefaultReminderTime(_ time: Date) {
        defaultReminderTime = time
        UserDefaults.standard.set(time, forKey: timeKey)
    }

    func scheduleReminders(for habits: [Habit]) {
        guard notificationsEnabled else {
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            return
        }

        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()

        for habit in habits where habit.reminderEnabled {
            var dateComponents = DateComponents()
            dateComponents.hour = habit.reminderHour
            dateComponents.minute = habit.reminderMinute

            let content = UNMutableNotificationContent()
            content.title = L("notifications_title")
            content.body = String(format: L("habit_not_completed_message"), habit.title)
            content.sound = .default

            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(
                identifier: "habit_reminder_\(habit.id.uuidString)",
                content: content,
                trigger: trigger
            )
            center.add(request)
        }
    }

    private func requestPermissionIfNeeded() async -> Bool {
        await withCheckedContinuation { continuation in
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
                continuation.resume(returning: granted)
            }
        }
    }
}

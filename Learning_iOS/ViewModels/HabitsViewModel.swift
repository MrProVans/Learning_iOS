import Foundation
import Combine

@MainActor
final class HabitsViewModel: ObservableObject {
    @Published var habits: [Habit]
    @Published var pendingReminderHabitName: String?

    let iconChoices: [String] = [
        "figure.walk",
        "timer",
        "book.fill",
        "drop.fill",
        "moon.zzz.fill",
        "pencil.and.list.clipboard",
        "heart.fill",
        "leaf.fill",
        "bolt.fill",
        "figure.yoga"
    ]

    private let store: HabitsStore
    private let notifications: NotificationManager

    init(store: HabitsStore, notifications: NotificationManager) {
        self.store = store
        self.notifications = notifications

        let savedHabits = store.loadHabits()
        if savedHabits.isEmpty {
            self.habits = [
                Habit(title: "Morning Walk", sfSymbolName: "figure.walk", streak: 6),
                Habit(title: "Deep Work", sfSymbolName: "timer", streak: 4),
                Habit(title: "Read 20 min", sfSymbolName: "book.fill", streak: 9),
                Habit(title: "Hydrate", sfSymbolName: "drop.fill", streak: 11)
            ]
        } else {
            self.habits = savedHabits
        }

        normalizeForToday()
        persistAndSchedule()
    }

    convenience init() {
        self.init(store: HabitsStore(), notifications: .shared)
    }

    var completedTodayCount: Int {
        habits.filter(\.isDoneToday).count
    }

    var totalHabitsCount: Int {
        habits.count
    }

    var completionProgress: Double {
        guard !habits.isEmpty else { return 0 }
        return Double(completedTodayCount) / Double(habits.count)
    }

    func toggle(_ habit: Habit) {
        guard let index = habits.firstIndex(where: { $0.id == habit.id }) else { return }

        if habits[index].isDoneToday {
            habits[index].isDoneToday = false
            habits[index].streak = max(0, habits[index].streak - 1)
            habits[index].lastCompletedDate = nil
        } else {
            let calendar = Calendar.current
            let yesterday = calendar.date(byAdding: .day, value: -1, to: Date()) ?? Date()

            if let last = habits[index].lastCompletedDate {
                if calendar.isDate(last, inSameDayAs: yesterday) {
                    habits[index].streak += 1
                } else if !calendar.isDateInToday(last) {
                    habits[index].streak = 1
                }
            } else {
                habits[index].streak = max(1, habits[index].streak)
            }

            habits[index].isDoneToday = true
            habits[index].lastCompletedDate = Date()
        }

        persistAndSchedule()
        habits[index].isDoneToday ? AppFeedbackManager.shared.success() : AppFeedbackManager.shared.selectionChanged()
    }

    func addHabit(title: String, symbol: String, reminderEnabled: Bool, reminderTime: Date) {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty else { return }

        let components = Calendar.current.dateComponents([.hour, .minute], from: reminderTime)
        let habit = Habit(
            title: trimmedTitle,
            sfSymbolName: symbol,
            reminderEnabled: reminderEnabled,
            reminderHour: components.hour ?? 20,
            reminderMinute: components.minute ?? 0
        )

        habits.append(habit)
        persistAndSchedule()
        AppFeedbackManager.shared.success()
    }

    func updateHabit(_ updated: Habit, reminderTime: Date) {
        guard let index = habits.firstIndex(where: { $0.id == updated.id }) else { return }

        let components = Calendar.current.dateComponents([.hour, .minute], from: reminderTime)
        habits[index].title = updated.title
        habits[index].sfSymbolName = updated.sfSymbolName
        habits[index].reminderEnabled = updated.reminderEnabled
        habits[index].reminderHour = components.hour ?? habits[index].reminderHour
        habits[index].reminderMinute = components.minute ?? habits[index].reminderMinute

        persistAndSchedule()
        AppFeedbackManager.shared.success()
    }

    func deleteHabit(_ habit: Habit) {
        habits.removeAll(where: { $0.id == habit.id })
        persistAndSchedule()
        AppFeedbackManager.shared.warning()
    }

    func reminderDate(for habit: Habit) -> Date {
        Calendar.current.date(from: DateComponents(hour: habit.reminderHour, minute: habit.reminderMinute)) ?? Date()
    }

    func normalizeForToday() {
        let calendar = Calendar.current
        for index in habits.indices {
            let isToday = habits[index].lastCompletedDate.map { calendar.isDateInToday($0) } ?? false
            if !isToday {
                habits[index].isDoneToday = false
            }
        }
        persistAndSchedule()
    }

    func checkForegroundReminder() {
        guard notifications.notificationsEnabled else { return }

        let now = Date()
        let calendar = Calendar.current
        let current = calendar.dateComponents([.hour, .minute], from: now)

        for habit in habits where habit.reminderEnabled && !habit.isDoneToday {
            let hasPassedHour = (current.hour ?? 0) > habit.reminderHour
            let hasPassedMinute = (current.hour == habit.reminderHour) && ((current.minute ?? 0) >= habit.reminderMinute)
            if hasPassedHour || hasPassedMinute {
                pendingReminderHabitName = habit.title
                return
            }
        }
    }

    func clearReminderAlert() {
        pendingReminderHabitName = nil
    }

    private func persistAndSchedule() {
        store.saveHabits(habits)
        notifications.scheduleReminders(for: habits)
    }
}

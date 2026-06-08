import Foundation
import Combine

@MainActor
final class AchievementsViewModel: ObservableObject {
    @Published private(set) var achievements: [Achievement] = []

    private let energyStore: EnergyStore
    private let habitsStore: HabitsStore
    private let tasksStore: TasksStore
    private let favoriteQuotesStore: FavoriteQuotesStore
    private let seenKey = "seen_unlocked_achievement_ids_v1"

    init(
        energyStore: EnergyStore,
        habitsStore: HabitsStore,
        tasksStore: TasksStore,
        favoriteQuotesStore: FavoriteQuotesStore
    ) {
        self.energyStore = energyStore
        self.habitsStore = habitsStore
        self.tasksStore = tasksStore
        self.favoriteQuotesStore = favoriteQuotesStore
        refresh()
    }

    convenience init() {
        self.init(
            energyStore: EnergyStore(),
            habitsStore: HabitsStore(),
            tasksStore: TasksStore(),
            favoriteQuotesStore: FavoriteQuotesStore()
        )
    }

    var unlockedCount: Int {
        achievements.filter(\.isUnlocked).count
    }

    func refresh() {
        let entries = energyStore.loadEntries()
        let habits = habitsStore.loadHabits()
        let tasks = tasksStore.loadTasks()
        let favoriteIDs = favoriteQuotesStore.loadIDs()

        let todayCategoryIDs = Set(entries.filter { Calendar.current.isDateInToday($0.date) }.map(\.categoryId))
        let completedHabits = habits.filter(\.isDoneToday)
        let completedTasks = tasks.filter(\.isDone)

        achievements = [
            Achievement(
                id: "first_energy",
                titleKey: "achievement_first_energy_title",
                descriptionKey: "achievement_first_energy_desc",
                sfSymbolName: "bolt.fill",
                isUnlocked: !entries.isEmpty
            ),
            Achievement(
                id: "balanced_day",
                titleKey: "achievement_balanced_day_title",
                descriptionKey: "achievement_balanced_day_desc",
                sfSymbolName: "circle.grid.2x2.fill",
                isUnlocked: todayCategoryIDs.count >= 4
            ),
            Achievement(
                id: "habit_starter",
                titleKey: "achievement_habit_starter_title",
                descriptionKey: "achievement_habit_starter_desc",
                sfSymbolName: "checkmark.circle.fill",
                isUnlocked: !completedHabits.isEmpty
            ),
            Achievement(
                id: "discipline_day",
                titleKey: "achievement_discipline_day_title",
                descriptionKey: "achievement_discipline_day_desc",
                sfSymbolName: "flame.fill",
                isUnlocked: !habits.isEmpty && completedHabits.count == habits.count
            ),
            Achievement(
                id: "task_crusher",
                titleKey: "achievement_task_crusher_title",
                descriptionKey: "achievement_task_crusher_desc",
                sfSymbolName: "list.bullet.clipboard.fill",
                isUnlocked: completedTasks.count >= 5
            ),
            Achievement(
                id: "focus_master",
                titleKey: "achievement_focus_master_title",
                descriptionKey: "achievement_focus_master_desc",
                sfSymbolName: "exclamationmark.circle.fill",
                isUnlocked: completedTasks.contains { $0.priority == .high }
            ),
            Achievement(
                id: "explorer",
                titleKey: "achievement_explorer_title",
                descriptionKey: "achievement_explorer_desc",
                sfSymbolName: "star.fill",
                isUnlocked: !favoriteIDs.isEmpty
            )
        ]

        playFeedbackForNewUnlocks()
    }

    private func playFeedbackForNewUnlocks() {
        let unlockedIDs = Set(achievements.filter(\.isUnlocked).map(\.id))
        let seenIDs = Set(UserDefaults.standard.stringArray(forKey: seenKey) ?? [])
        let newIDs = unlockedIDs.subtracting(seenIDs)

        if !newIDs.isEmpty {
            AppFeedbackManager.shared.success()
        }

        UserDefaults.standard.set(Array(unlockedIDs), forKey: seenKey)
    }
}

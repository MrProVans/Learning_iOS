import Foundation
import Combine

@MainActor
final class TodayViewModel: ObservableObject {
    @Published private(set) var name = ""
    @Published private(set) var todayAverageEnergy: Double?
    @Published private(set) var completedEnergyCategories = 0
    @Published private(set) var totalEnergyCategories = 4
    @Published private(set) var completedHabits = 0
    @Published private(set) var totalHabits = 0
    @Published private(set) var completedTasks = 0
    @Published private(set) var totalTasks = 0
    @Published private(set) var focusTask: TaskItem?
    @Published private(set) var quote: QuoteItem = QuoteItem(
        id: -100,
        quote: L("today_fallback_quote"),
        author: L("app_name")
    )

    private let energyStore: EnergyStore
    private let habitsStore: HabitsStore
    private let tasksStore: TasksStore

    init(
        energyStore: EnergyStore,
        habitsStore: HabitsStore,
        tasksStore: TasksStore
    ) {
        self.energyStore = energyStore
        self.habitsStore = habitsStore
        self.tasksStore = tasksStore
        refresh()
    }

    convenience init() {
        self.init(
            energyStore: EnergyStore(),
            habitsStore: HabitsStore(),
            tasksStore: TasksStore()
        )
    }

    var habitProgress: Double {
        guard totalHabits > 0 else { return 0 }
        return Double(completedHabits) / Double(totalHabits)
    }

    var taskProgress: Double {
        guard totalTasks > 0 else { return 0 }
        return Double(completedTasks) / Double(totalTasks)
    }

    var energyProgress: Double {
        guard totalEnergyCategories > 0 else { return 0 }
        return Double(completedEnergyCategories) / Double(totalEnergyCategories)
    }

    var overallProgress: Double {
        (energyProgress + habitProgress + taskProgress) / 3
    }

    func refresh() {
        name = UserDefaults.standard.string(forKey: "focus_energy_name") ?? ""

        let entries = energyStore.loadEntries()
        let todayEntries = entries.filter { Calendar.current.isDateInToday($0.date) }
        completedEnergyCategories = Set(todayEntries.map(\.categoryId)).count
        if !todayEntries.isEmpty {
            todayAverageEnergy = Double(todayEntries.map(\.rating).reduce(0, +)) / Double(todayEntries.count)
        } else {
            todayAverageEnergy = nil
        }

        let habits = habitsStore.loadHabits()
        totalHabits = habits.count
        completedHabits = habits.filter(\.isDoneToday).count

        let loadedTasks = tasksStore.loadTasks()
        let tasks = loadedTasks.isEmpty ? [
            TaskItem(title: L("starter_task_plan"), priority: .high),
            TaskItem(title: L("starter_task_focus"), priority: .medium),
            TaskItem(title: L("starter_task_review"), priority: .low)
        ] : loadedTasks
        totalTasks = tasks.count
        completedTasks = tasks.filter(\.isDone).count
        focusTask = tasks
            .filter { !$0.isDone }
            .sorted { lhs, rhs in
                if lhs.priority.sortingWeight != rhs.priority.sortingWeight {
                    return lhs.priority.sortingWeight > rhs.priority.sortingWeight
                }
                return lhs.createdAt > rhs.createdAt
            }
            .first

        quote = QuoteItem(
            id: -100,
            quote: L("today_fallback_quote"),
            author: L("app_name")
        )
    }
}

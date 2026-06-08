import Foundation
import Combine

enum TaskFilter: String, CaseIterable, Identifiable {
    case all
    case active
    case completed

    var id: String { rawValue }

    var titleKey: String {
        switch self {
        case .all: return "task_filter_all"
        case .active: return "task_filter_active"
        case .completed: return "task_filter_done"
        }
    }
}

@MainActor
final class TasksViewModel: ObservableObject {
    @Published private(set) var tasks: [TaskItem]
    @Published var filter: TaskFilter = .all

    private let store: TasksStore

    init(store: TasksStore) {
        self.store = store
        let savedTasks = store.loadTasks()
        if savedTasks.isEmpty {
            self.tasks = [
                TaskItem(title: L("starter_task_plan"), priority: .high),
                TaskItem(title: L("starter_task_focus"), priority: .medium),
                TaskItem(title: L("starter_task_review"), priority: .low)
            ]
        } else {
            self.tasks = savedTasks
        }
    }

    convenience init() {
        self.init(store: TasksStore())
    }

    var filteredTasks: [TaskItem] {
        sortedTasks.filter { task in
            switch filter {
            case .all: return true
            case .active: return !task.isDone
            case .completed: return task.isDone
            }
        }
    }

    var completedCount: Int {
        tasks.filter(\.isDone).count
    }

    var activeCount: Int {
        tasks.filter { !$0.isDone }.count
    }

    var completionProgress: Double {
        guard !tasks.isEmpty else { return 0 }
        return Double(completedCount) / Double(tasks.count)
    }

    func addTask(title: String, priority: TaskPriority, dueDate: Date?, notes: String?) {
        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        let trimmedNotes = notes?.trimmingCharacters(in: .whitespacesAndNewlines)
        tasks.insert(
            TaskItem(
                title: trimmed,
                priority: priority,
                dueDate: dueDate,
                notes: trimmedNotes?.isEmpty == true ? nil : trimmedNotes
            ),
            at: 0
        )
        persist()
        AppFeedbackManager.shared.success()
    }

    func updateTask(_ task: TaskItem, title: String, priority: TaskPriority, dueDate: Date?, notes: String?) {
        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else { return }
        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        let trimmedNotes = notes?.trimmingCharacters(in: .whitespacesAndNewlines)

        tasks[index].title = trimmed
        tasks[index].priority = priority
        tasks[index].dueDate = dueDate
        tasks[index].notes = trimmedNotes?.isEmpty == true ? nil : trimmedNotes
        persist()
        AppFeedbackManager.shared.success()
    }

    func toggle(_ task: TaskItem) {
        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else { return }
        tasks[index].isDone.toggle()
        persist()
        tasks[index].isDone ? AppFeedbackManager.shared.success() : AppFeedbackManager.shared.selectionChanged()
    }

    func delete(at offsets: IndexSet) {
        let visible = filteredTasks
        let ids = offsets.compactMap { index in
            visible.indices.contains(index) ? visible[index].id : nil
        }
        deleteTasks(ids: ids)
    }

    func delete(_ task: TaskItem) {
        deleteTasks(ids: [task.id])
    }

    func move(from source: IndexSet, to destination: Int) {
        let visible = filteredTasks
        let sourceIDs = source.compactMap { index in
            visible.indices.contains(index) ? visible[index].id : nil
        }
        let movedItems = sourceIDs.compactMap { id in tasks.first(where: { $0.id == id }) }

        tasks.removeAll { sourceIDs.contains($0.id) }

        let visibleDestinationID = visible.indices.contains(destination) ? visible[destination].id : nil
        let targetIndex = visibleDestinationID.flatMap { id in tasks.firstIndex(where: { $0.id == id }) } ?? tasks.count
        tasks.insert(contentsOf: movedItems, at: min(targetIndex, tasks.count))
        persist()
    }

    private var sortedTasks: [TaskItem] {
        tasks.sorted { lhs, rhs in
            if lhs.isDone != rhs.isDone { return !lhs.isDone }
            if lhs.priority.sortingWeight != rhs.priority.sortingWeight {
                return lhs.priority.sortingWeight > rhs.priority.sortingWeight
            }

            switch (lhs.dueDate, rhs.dueDate) {
            case let (left?, right?) where left != right:
                return left < right
            case (.some, .none):
                return true
            case (.none, .some):
                return false
            default:
                return lhs.createdAt > rhs.createdAt
            }
        }
    }

    private func deleteTasks(ids: [UUID]) {
        guard !ids.isEmpty else { return }
        tasks.removeAll { ids.contains($0.id) }
        persist()
        AppFeedbackManager.shared.warning()
    }

    private func persist() {
        store.saveTasks(tasks)
    }
}

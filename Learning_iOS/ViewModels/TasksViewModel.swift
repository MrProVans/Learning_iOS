import Foundation
import Combine

@MainActor
final class TasksViewModel: ObservableObject {
    @Published var tasks: [TaskItem] = [
        TaskItem(title: "Plan top 3 priorities"),
        TaskItem(title: "Focus block: 45 minutes"),
        TaskItem(title: "Evening energy review")
    ]

    func addTask(title: String) {
        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        tasks.insert(TaskItem(title: trimmed), at: 0)
    }

    func toggle(_ task: TaskItem) {
        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else { return }
        tasks[index].isDone.toggle()
    }

    func delete(at offsets: IndexSet) {
        for index in offsets.sorted(by: >) {
            tasks.remove(at: index)
        }
    }

    func move(from source: IndexSet, to destination: Int) {
        let movedItems = source.sorted().map { tasks[$0] }
        for index in source.sorted(by: >) {
            tasks.remove(at: index)
        }

        let targetIndex = min(destination, tasks.count)
        tasks.insert(contentsOf: movedItems, at: targetIndex)
    }
}

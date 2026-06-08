import Foundation

final class TasksStore {
    private let key = "tasks_items_v1"
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    init() {
        encoder = JSONEncoder()
        decoder = JSONDecoder()
        encoder.dateEncodingStrategy = .iso8601
        decoder.dateDecodingStrategy = .iso8601
    }

    func loadTasks() -> [TaskItem] {
        guard let data = UserDefaults.standard.data(forKey: key) else { return [] }
        return (try? decoder.decode([TaskItem].self, from: data)) ?? []
    }

    func saveTasks(_ tasks: [TaskItem]) {
        guard let data = try? encoder.encode(tasks) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }
}

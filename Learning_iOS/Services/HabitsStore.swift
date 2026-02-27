import Foundation

final class HabitsStore {
    private let key = "habits_items_v2"
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    init() {
        encoder = JSONEncoder()
        decoder = JSONDecoder()
        encoder.dateEncodingStrategy = .iso8601
        decoder.dateDecodingStrategy = .iso8601
    }

    func loadHabits() -> [Habit] {
        guard let data = UserDefaults.standard.data(forKey: key) else { return [] }
        return (try? decoder.decode([Habit].self, from: data)) ?? []
    }

    func saveHabits(_ habits: [Habit]) {
        guard let data = try? encoder.encode(habits) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }
}

import Foundation

final class EnergyStore {
    private let key = "energy_entries_v1"
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    init() {
        encoder = JSONEncoder()
        decoder = JSONDecoder()
        encoder.dateEncodingStrategy = .iso8601
        decoder.dateDecodingStrategy = .iso8601
    }

    func loadEntries() -> [EnergyEntry] {
        guard let data = UserDefaults.standard.data(forKey: key) else { return [] }
        return (try? decoder.decode([EnergyEntry].self, from: data)) ?? []
    }

    func saveEntries(_ entries: [EnergyEntry]) {
        guard let data = try? encoder.encode(entries) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }
}

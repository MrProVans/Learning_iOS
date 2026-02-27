import Foundation
import Combine

@MainActor
final class EnergyViewModel: ObservableObject {
    @Published private(set) var categories: [EnergyCategory] = [
        EnergyCategory(id: "physical", titleKey: "energy_physical", sfSymbolName: "figure.run", descriptionKey: "energy_physical_desc"),
        EnergyCategory(id: "emotional", titleKey: "energy_emotional", sfSymbolName: "heart.text.square", descriptionKey: "energy_emotional_desc"),
        EnergyCategory(id: "intellectual", titleKey: "energy_intellectual", sfSymbolName: "brain.head.profile", descriptionKey: "energy_intellectual_desc"),
        EnergyCategory(id: "spiritual", titleKey: "energy_spiritual", sfSymbolName: "sparkles", descriptionKey: "energy_spiritual_desc")
    ]
    @Published var currentIndex = 0
    @Published var metricRating = 5.0
    @Published var note = ""
    @Published private(set) var entries: [EnergyEntry] = []

    private let store: EnergyStore

    init(store: EnergyStore) {
        self.store = store
        self.entries = store.loadEntries().sorted(by: { $0.date > $1.date })
    }

    convenience init() {
        self.init(store: EnergyStore())
    }

    var currentCategory: EnergyCategory {
        categories[currentIndex]
    }

    func next() {
        guard !categories.isEmpty else { return }
        currentIndex = (currentIndex + 1) % categories.count
    }

    func previous() {
        guard !categories.isEmpty else { return }
        currentIndex = (currentIndex - 1 + categories.count) % categories.count
    }

    func saveCurrentEntry() {
        let trimmedNote = note.trimmingCharacters(in: .whitespacesAndNewlines)
        let dayDate = Calendar.current.startOfDay(for: Date())

        let entry = EnergyEntry(
            categoryId: currentCategory.id,
            date: dayDate,
            rating: Int(metricRating),
            note: trimmedNote.isEmpty ? nil : trimmedNote
        )

        entries.insert(entry, at: 0)
        store.saveEntries(entries)
        note = ""
    }

    func recentEntries(for categoryId: String, limit: Int = 7) -> [EnergyEntry] {
        Array(
            entries
                .filter { $0.categoryId == categoryId }
                .sorted(by: { $0.date > $1.date })
                .prefix(limit)
        )
    }

    func summary(for categoryId: String, days: Int) -> EnergySummary? {
        let filtered = entriesForRange(categoryId: categoryId, days: days)
        guard !filtered.isEmpty else { return nil }

        let ratings = filtered.map(\.rating)
        let average = Double(ratings.reduce(0, +)) / Double(ratings.count)

        return EnergySummary(
            average: average,
            minimum: ratings.min() ?? 0,
            maximum: ratings.max() ?? 0
        )
    }

    func trend(for categoryId: String, days: Int) -> [EnergyTrendPoint] {
        let filtered = entriesForRange(categoryId: categoryId, days: days)

        let grouped = Dictionary(grouping: filtered) {
            Calendar.current.startOfDay(for: $0.date)
        }

        return grouped.keys.sorted().compactMap { date in
            guard let dayEntries = grouped[date], !dayEntries.isEmpty else { return nil }
            let avg = Double(dayEntries.map(\.rating).reduce(0, +)) / Double(dayEntries.count)
            return EnergyTrendPoint(date: date, value: avg)
        }
    }

    private func entriesForRange(categoryId: String, days: Int) -> [EnergyEntry] {
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: calendar.date(byAdding: .day, value: -(days - 1), to: Date()) ?? Date())

        return entries.filter {
            $0.categoryId == categoryId && $0.date >= startDate
        }
    }
}

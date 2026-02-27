import Foundation

struct EnergyCategory: Identifiable, Codable, Hashable {
    let id: String
    let titleKey: String
    let sfSymbolName: String
    let descriptionKey: String
}

struct EnergyEntry: Identifiable, Codable {
    let id: UUID
    let categoryId: String
    let date: Date
    let rating: Int
    let note: String?

    init(id: UUID = UUID(), categoryId: String, date: Date, rating: Int, note: String? = nil) {
        self.id = id
        self.categoryId = categoryId
        self.date = date
        self.rating = rating
        self.note = note
    }
}

struct Habit: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var sfSymbolName: String
    var isDoneToday: Bool
    var streak: Int
    var reminderEnabled: Bool
    var reminderHour: Int
    var reminderMinute: Int
    var lastCompletedDate: Date?

    init(
        id: UUID = UUID(),
        title: String,
        sfSymbolName: String,
        isDoneToday: Bool = false,
        streak: Int = 0,
        reminderEnabled: Bool = false,
        reminderHour: Int = 20,
        reminderMinute: Int = 0,
        lastCompletedDate: Date? = nil
    ) {
        self.id = id
        self.title = title
        self.sfSymbolName = sfSymbolName
        self.isDoneToday = isDoneToday
        self.streak = streak
        self.reminderEnabled = reminderEnabled
        self.reminderHour = reminderHour
        self.reminderMinute = reminderMinute
        self.lastCompletedDate = lastCompletedDate
    }
}

struct TaskItem: Identifiable {
    let id: UUID
    let title: String
    var isDone: Bool
    let createdAt: Date

    init(id: UUID = UUID(), title: String, isDone: Bool = false, createdAt: Date = Date()) {
        self.id = id
        self.title = title
        self.isDone = isDone
        self.createdAt = createdAt
    }
}

struct QuoteItem: Codable, Identifiable, Equatable {
    let id: Int
    let quote: String
    let author: String
}

struct QuoteResponse: Codable {
    let quotes: [QuoteItem]
    let total: Int
    let skip: Int
    let limit: Int
}

struct EnergySummary {
    let average: Double
    let minimum: Int
    let maximum: Int
}

struct EnergyTrendPoint: Identifiable {
    let id = UUID()
    let date: Date
    let value: Double
}

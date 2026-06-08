import Foundation

struct EnergyCategory: Identifiable, Codable, Hashable {
    let id: String
    let titleKey: String
    let sfSymbolName: String
    let descriptionKey: String
    let imageAssetName: String
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

enum TaskPriority: String, Codable, CaseIterable, Identifiable {
    case low
    case medium
    case high

    var id: String { rawValue }

    var titleKey: String {
        switch self {
        case .low: return "task_priority_low"
        case .medium: return "task_priority_medium"
        case .high: return "task_priority_high"
        }
    }

    var sfSymbolName: String {
        switch self {
        case .low: return "arrow.down.circle"
        case .medium: return "minus.circle"
        case .high: return "exclamationmark.circle.fill"
        }
    }

    var sortingWeight: Int {
        switch self {
        case .low: return 0
        case .medium: return 1
        case .high: return 2
        }
    }
}

struct TaskItem: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var isDone: Bool
    let createdAt: Date
    var priority: TaskPriority
    var dueDate: Date?
    var notes: String?

    init(
        id: UUID = UUID(),
        title: String,
        isDone: Bool = false,
        createdAt: Date = Date(),
        priority: TaskPriority = .medium,
        dueDate: Date? = nil,
        notes: String? = nil
    ) {
        self.id = id
        self.title = title
        self.isDone = isDone
        self.createdAt = createdAt
        self.priority = priority
        self.dueDate = dueDate
        self.notes = notes
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

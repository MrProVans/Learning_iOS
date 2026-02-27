import Foundation

struct EnergyCategory: Identifiable {
    let id = UUID()
    let title: String
    let sfSymbolName: String
    let description: String
}

struct Habit: Identifiable {
    let id: UUID
    let title: String
    let sfSymbolName: String
    var isDoneToday: Bool
    var streak: Int

    init(id: UUID = UUID(), title: String, sfSymbolName: String, isDoneToday: Bool = false, streak: Int = 0) {
        self.id = id
        self.title = title
        self.sfSymbolName = sfSymbolName
        self.isDoneToday = isDoneToday
        self.streak = streak
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
    let id: String
    let content: String
    let author: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case content
        case author
    }
}

struct QuoteResponse: Codable {
    let results: [QuoteItem]
    let page: Int
    let totalPages: Int
}

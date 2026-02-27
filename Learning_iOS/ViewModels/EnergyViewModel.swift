import Foundation
import Combine

@MainActor
final class EnergyViewModel: ObservableObject {
    @Published private(set) var categories: [EnergyCategory] = [
        EnergyCategory(title: "Physical", sfSymbolName: "figure.run", description: "Movement, sleep, and nutrition are your base fuel."),
        EnergyCategory(title: "Emotional", sfSymbolName: "heart.text.square", description: "Mood and stress shape your daily momentum."),
        EnergyCategory(title: "Intellectual", sfSymbolName: "brain.head.profile", description: "Deep focus and learning keep your edge sharp."),
        EnergyCategory(title: "Spiritual", sfSymbolName: "sparkles", description: "Meaning and reflection anchor your priorities.")
    ]
    @Published var currentIndex: Int = 0

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
}

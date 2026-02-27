import Foundation
import Combine

@MainActor
final class HabitsViewModel: ObservableObject {
    @Published var habits: [Habit] = [
        Habit(title: "Morning Walk", sfSymbolName: "figure.walk", streak: 6),
        Habit(title: "Deep Work", sfSymbolName: "timer", streak: 4),
        Habit(title: "Read 20 min", sfSymbolName: "book.fill", streak: 9),
        Habit(title: "Hydrate", sfSymbolName: "drop.fill", streak: 11),
        Habit(title: "No Late Scroll", sfSymbolName: "moon.zzz.fill", streak: 3),
        Habit(title: "Journal", sfSymbolName: "pencil.and.list.clipboard", streak: 5)
    ]

    func toggle(_ habit: Habit) {
        guard let index = habits.firstIndex(where: { $0.id == habit.id }) else { return }
        habits[index].isDoneToday.toggle()
        if habits[index].isDoneToday {
            habits[index].streak += 1
        } else {
            habits[index].streak = max(0, habits[index].streak - 1)
        }
    }
}

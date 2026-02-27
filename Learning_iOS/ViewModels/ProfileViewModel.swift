import Foundation
import Combine

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var name: String = ""

    private let key = "focus_energy_name"

    init() {
        load()
    }

    func load() {
        name = UserDefaults.standard.string(forKey: key) ?? ""
    }

    func save(_ newName: String) {
        let trimmed = newName.trimmingCharacters(in: .whitespacesAndNewlines)
        name = trimmed
        UserDefaults.standard.set(trimmed, forKey: key)
    }
}

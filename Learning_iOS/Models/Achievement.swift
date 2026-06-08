import Foundation

struct Achievement: Identifiable, Hashable {
    let id: String
    let titleKey: String
    let descriptionKey: String
    let sfSymbolName: String
    let isUnlocked: Bool
}

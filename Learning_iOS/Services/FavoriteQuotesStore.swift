import Foundation

final class FavoriteQuotesStore {
    private let key = "favorite_quote_ids_v1"

    func loadIDs() -> Set<Int> {
        let ids = UserDefaults.standard.array(forKey: key) as? [Int] ?? []
        return Set(ids)
    }

    func saveIDs(_ ids: Set<Int>) {
        UserDefaults.standard.set(Array(ids), forKey: key)
    }
}

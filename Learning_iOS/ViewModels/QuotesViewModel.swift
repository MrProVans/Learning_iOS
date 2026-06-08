import Foundation
import Combine

enum QuoteFilter: String, CaseIterable, Identifiable {
    case all
    case favorites

    var id: String { rawValue }

    var titleKey: String {
        switch self {
        case .all: return "quote_filter_all"
        case .favorites: return "quote_filter_favorites"
        }
    }
}

@MainActor
final class QuotesViewModel: ObservableObject {
    @Published private(set) var quotes: [QuoteItem] = []
    @Published private(set) var isLoading = false
    @Published private(set) var skip = 0
    @Published private(set) var limit = 20
    @Published private(set) var total = 0
    @Published private(set) var favoriteIDs: Set<Int> = []
    @Published var filter: QuoteFilter = .all
    @Published var errorMessage: String?

    private let service: QuoteServicing
    private let favoritesStore: FavoriteQuotesStore

    init(service: QuoteServicing, favoritesStore: FavoriteQuotesStore) {
        self.service = service
        self.favoritesStore = favoritesStore
        self.favoriteIDs = favoritesStore.loadIDs()
    }

    convenience init() {
        self.init(service: QuoteService(), favoritesStore: FavoriteQuotesStore())
    }

    var visibleQuotes: [QuoteItem] {
        switch filter {
        case .all:
            return quotes
        case .favorites:
            return quotes.filter { favoriteIDs.contains($0.id) }
        }
    }

    func loadInitial() async {
        skip = 0
        total = 0
        quotes = []
        errorMessage = nil
        await loadMore()
    }

    func loadMoreIfNeeded(currentItem: QuoteItem?) async {
        guard !isLoading else { return }

        if let currentItem,
           let index = quotes.firstIndex(where: { $0.id == currentItem.id }),
           index < max(quotes.count - 3, 0) {
            return
        }

        guard total == 0 || skip < total else { return }
        await loadMore()
    }

    private func loadMore() async {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil

        do {
            let response = try await service.fetchQuotes(limit: limit, skip: skip)
            total = response.total
            skip = response.skip + response.limit

            if response.skip == 0 {
                quotes = response.quotes
            } else {
                let existingIDs = Set(quotes.map(\.id))
                quotes.append(contentsOf: response.quotes.filter { !existingIDs.contains($0.id) })
            }
        } catch {
            errorMessage = error.localizedDescription
            if quotes.isEmpty {
                quotes = Self.makeFallbackQuotes()
                total = quotes.count
                skip = quotes.count
            }
            AppFeedbackManager.shared.error()
        }

        isLoading = false
    }

    func isFavorite(_ quote: QuoteItem) -> Bool {
        favoriteIDs.contains(quote.id)
    }

    func toggleFavorite(_ quote: QuoteItem) {
        if favoriteIDs.contains(quote.id) {
            favoriteIDs.remove(quote.id)
            AppFeedbackManager.shared.selectionChanged()
        } else {
            favoriteIDs.insert(quote.id)
            AppFeedbackManager.shared.success()
        }
        favoritesStore.saveIDs(favoriteIDs)
    }

    private static func makeFallbackQuotes() -> [QuoteItem] {
        [
            QuoteItem(id: -1, quote: L("quote_fallback_one"), author: L("app_name")),
            QuoteItem(id: -2, quote: L("quote_fallback_two"), author: L("app_name")),
            QuoteItem(id: -3, quote: L("quote_fallback_three"), author: L("app_name"))
        ]
    }
}

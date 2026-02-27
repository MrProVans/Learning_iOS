import Foundation
import Combine

@MainActor
final class QuotesViewModel: ObservableObject {
    @Published private(set) var quotes: [QuoteItem] = []
    @Published private(set) var isLoading = false
    @Published private(set) var skip = 0
    @Published private(set) var limit = 20
    @Published private(set) var total = 0
    @Published var errorMessage: String?

    private let service: QuoteServicing

    init(service: QuoteServicing) {
        self.service = service
    }

    convenience init() {
        self.init(service: QuoteService())
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
        }

        isLoading = false
    }
}

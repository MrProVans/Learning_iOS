import Foundation
import Combine

@MainActor
final class QuotesViewModel: ObservableObject {
    @Published private(set) var quotes: [QuoteItem] = []
    @Published private(set) var isLoading = false
    @Published private(set) var page = 1
    @Published private(set) var totalPages = 1
    @Published var errorMessage: String?

    private let service: QuoteServicing

    init(service: QuoteServicing) {
        self.service = service
    }

    convenience init() {
        self.init(service: QuoteService())
    }

    var canLoadMore: Bool {
        page <= totalPages
    }

    func loadInitialIfNeeded() async {
        guard quotes.isEmpty else { return }
        await reload()
    }

    func reload() async {
        page = 1
        totalPages = 1
        quotes = []
        errorMessage = nil
        await loadNextPage()
    }

    func loadNextIfNeeded(currentItem: QuoteItem?) async {
        guard let currentItem else {
            if quotes.isEmpty { await loadNextPage() }
            return
        }

        let thresholdIndex = max(quotes.count - 4, 0)
        if let index = quotes.firstIndex(where: { $0.id == currentItem.id }), index >= thresholdIndex {
            await loadNextPage()
        }
    }

    private func loadNextPage() async {
        guard !isLoading, canLoadMore else { return }

        isLoading = true
        errorMessage = nil

        do {
            let response = try await service.fetchQuotes(page: page)
            quotes.append(contentsOf: response.results)
            totalPages = response.totalPages
            page = response.page + 1
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}

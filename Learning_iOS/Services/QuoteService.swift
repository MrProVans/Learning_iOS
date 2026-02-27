import Foundation

protocol QuoteServicing {
    func fetchQuotes(page: Int) async throws -> QuoteResponse
}

struct QuoteService: QuoteServicing {
    func fetchQuotes(page: Int) async throws -> QuoteResponse {
        guard let url = URL(string: "https://api.quotable.io/quotes?page=\(page)") else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode(QuoteResponse.self, from: data)
    }
}

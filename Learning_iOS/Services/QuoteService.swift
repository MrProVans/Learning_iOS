import Foundation

protocol QuoteServicing {
    func fetchQuotes(limit: Int, skip: Int) async throws -> QuoteResponse
}

struct QuoteService: QuoteServicing {
    func fetchQuotes(limit: Int, skip: Int) async throws -> QuoteResponse {
        var components = URLComponents(string: "https://dummyjson.com/quotes")
        components?.queryItems = [
            URLQueryItem(name: "limit", value: String(limit)),
            URLQueryItem(name: "skip", value: String(skip))
        ]

        guard let url = components?.url else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode(QuoteResponse.self, from: data)
    }
}

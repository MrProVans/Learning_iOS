import SwiftUI

struct ExploreView: View {
    @StateObject private var viewModel = QuotesViewModel()

    var body: some View {
        List {
            if let errorMessage = viewModel.errorMessage, viewModel.quotes.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Unable to load quotes")
                        .font(.headline)
                        .foregroundStyle(AppTheme.textPrimary)

                    Text(errorMessage)
                        .font(.subheadline)
                        .foregroundStyle(AppTheme.textSecondary)

                    Button("Retry") {
                        Task { await viewModel.reload() }
                    }
                    .buttonStyle(GoldPrimaryButtonStyle())
                }
                .listRowBackground(AppTheme.background)
            }

            ForEach(viewModel.quotes) { quote in
                VStack(alignment: .leading, spacing: 10) {
                    Text("\"\(quote.content)\"")
                        .font(.body)
                        .foregroundStyle(AppTheme.textPrimary)

                    Text("- \(quote.author)")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(AppTheme.textSecondary)
                }
                .padding(.vertical, 8)
                .listRowBackground(AppTheme.cardBackground)
                .onAppear {
                    Task { await viewModel.loadNextIfNeeded(currentItem: quote) }
                }
            }

            if viewModel.isLoading {
                HStack {
                    Spacer()
                    ProgressView()
                        .tint(AppTheme.accentGold)
                    Spacer()
                }
                .listRowBackground(AppTheme.background)
            }
        }
        .listStyle(.plain)
        .appScreenBackground()
        .navigationTitle("Explore")
        .navigationBarTitleDisplayMode(.large)
        .toolbarBackground(AppTheme.background, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    Task { await viewModel.reload() }
                } label: {
                    Image(systemName: "arrow.clockwise")
                        .foregroundStyle(AppTheme.accentGold)
                }
            }
        }
        .task {
            await viewModel.loadInitialIfNeeded()
        }
    }
}


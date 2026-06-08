import SwiftUI

struct ExploreView: View {
    @EnvironmentObject private var localization: LocalizationManager
    @StateObject private var viewModel = QuotesViewModel()

    var body: some View {
        let _ = localization.currentLanguage

        List {
            Section {
                Picker(L("quote_filter_title"), selection: $viewModel.filter) {
                    ForEach(QuoteFilter.allCases) { filter in
                        Text(L(filter.titleKey)).tag(filter)
                    }
                }
                .pickerStyle(.segmented)
                .listRowBackground(AppTheme.cardBackground)
            }

            if let errorMessage = viewModel.errorMessage, viewModel.quotes.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    Text(L("explore_error"))
                        .font(.headline)
                        .foregroundStyle(AppTheme.textPrimary)

                    Text(errorMessage)
                        .font(.subheadline)
                        .foregroundStyle(AppTheme.textSecondary)

                    Button(L("explore_retry")) {
                        Task { await viewModel.loadInitial() }
                    }
                    .buttonStyle(GoldPrimaryButtonStyle())
                }
                .listRowBackground(AppTheme.background)
            }

            if viewModel.visibleQuotes.isEmpty && viewModel.filter == .favorites && !viewModel.isLoading {
                EmptyStateView(
                    title: L("quotes_no_favorites_title"),
                    message: L("quotes_no_favorites_message"),
                    systemImage: "star"
                )
                .listRowInsets(EdgeInsets())
                .listRowBackground(AppTheme.background)
            }

            ForEach(viewModel.visibleQuotes) { quote in
                HStack(alignment: .top, spacing: 10) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("\"\(quote.quote)\"")
                            .font(.body)
                            .foregroundStyle(AppTheme.textPrimary)

                        Text("- \(quote.author)")
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(AppTheme.textSecondary)
                    }

                    Spacer()

                    Button {
                        viewModel.toggleFavorite(quote)
                    } label: {
                        Image(systemName: viewModel.isFavorite(quote) ? "star.fill" : "star")
                            .foregroundStyle(AppTheme.accentGold)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.vertical, 8)
                .listRowBackground(AppTheme.cardBackground)
                .onAppear {
                    Task { await viewModel.loadMoreIfNeeded(currentItem: quote) }
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
        .navigationTitle(L("tab_explore"))
        .navigationBarTitleDisplayMode(.large)
        .toolbarBackground(AppTheme.background, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    AppFeedbackManager.shared.tap()
                    Task { await viewModel.loadInitial() }
                } label: {
                    Image(systemName: "arrow.clockwise")
                        .foregroundStyle(AppTheme.accentGold)
                }
            }
        }
        .refreshable {
            AppFeedbackManager.shared.tap()
            await viewModel.loadInitial()
        }
        .task {
            if viewModel.quotes.isEmpty {
                await viewModel.loadInitial()
            }
        }
    }
}

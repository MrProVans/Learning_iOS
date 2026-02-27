import SwiftUI
#if canImport(Charts)
import Charts
#endif

struct EnergyAnalyticsView: View {
    @EnvironmentObject private var localization: LocalizationManager
    @ObservedObject var viewModel: EnergyViewModel
    let category: EnergyCategory

    var body: some View {
        let _ = localization.currentLanguage
        let summary7 = viewModel.summary(for: category.id, days: 7)
        let summary30 = viewModel.summary(for: category.id, days: 30)
        let trend7 = viewModel.trend(for: category.id, days: 7)
        let trend30 = viewModel.trend(for: category.id, days: 30)

        ScrollView {
            VStack(spacing: 16) {
                summaryCard(title: L("last_7_days"), summary: summary7)
                summaryCard(title: L("last_30_days"), summary: summary30)
                trendCard(title: L("last_7_days"), points: trend7)
                trendCard(title: L("last_30_days"), points: trend30)
            }
            .padding(16)
        }
        .appScreenBackground()
        .navigationTitle("\(L("energy_analytics")): \(L(category.titleKey))")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(AppTheme.background, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }

    private func summaryCard(title: String, summary: EnergySummary?) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
                .foregroundStyle(AppTheme.textPrimary)

            if let summary {
                HStack {
                    metricItem(title: L("energy_avg"), value: String(format: "%.1f", summary.average))
                    metricItem(title: L("energy_min"), value: "\(summary.minimum)")
                    metricItem(title: L("energy_max"), value: "\(summary.maximum)")
                }
            } else {
                Text(L("trend_empty"))
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.textSecondary)
            }
        }
        .appCardStyle()
    }

    private func metricItem(title: String, value: String) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.caption)
                .foregroundStyle(AppTheme.textSecondary)
            Text(value)
                .font(.title3.weight(.semibold))
                .foregroundStyle(AppTheme.textPrimary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    @ViewBuilder
    private func trendCard(title: String, points: [EnergyTrendPoint]) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("\(L("energy_trend")): \(title)")
                .font(.headline)
                .foregroundStyle(AppTheme.textPrimary)

            if points.isEmpty {
                Text(L("trend_empty"))
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.textSecondary)
            } else {
                #if canImport(Charts)
                Chart(points) { point in
                    LineMark(
                        x: .value("Date", point.date),
                        y: .value("Rating", point.value)
                    )
                    .foregroundStyle(AppTheme.accentGold)

                    PointMark(
                        x: .value("Date", point.date),
                        y: .value("Rating", point.value)
                    )
                    .foregroundStyle(AppTheme.accentGold)
                }
                .frame(height: 180)
                #endif

                ForEach(points) { point in
                    HStack {
                        Text(point.date, style: .date)
                            .font(.caption)
                            .foregroundStyle(AppTheme.textSecondary)
                        Spacer()
                        Text(String(format: "%.1f", point.value))
                            .foregroundStyle(AppTheme.textPrimary)
                    }
                }
            }
        }
        .appCardStyle()
    }
}

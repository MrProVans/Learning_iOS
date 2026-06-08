import SwiftUI

struct ProgressSummaryCard: View {
    let title: String
    let subtitle: String
    let progress: Double
    let detail: String
    var symbolName: String = "chart.line.uptrend.xyaxis"

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                Image(systemName: symbolName)
                    .foregroundStyle(AppTheme.accentGold)
                Text(title)
                    .font(.headline)
                    .foregroundStyle(AppTheme.textPrimary)
            }

            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(AppTheme.textSecondary)

            ProgressView(value: min(max(progress, 0), 1))
                .tint(AppTheme.accentGold)

            Text(detail)
                .font(.caption)
                .foregroundStyle(AppTheme.textSecondary)
        }
        .appCardStyle()
    }
}

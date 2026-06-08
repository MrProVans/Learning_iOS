import SwiftUI

struct AchievementsView: View {
    @EnvironmentObject private var localization: LocalizationManager
    @StateObject private var viewModel = AchievementsViewModel()

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        let _ = localization.currentLanguage

        ScrollView {
            VStack(spacing: 16) {
                ProgressSummaryCard(
                    title: L("achievements_title"),
                    subtitle: String(format: L("achievements_unlocked_format"), viewModel.unlockedCount, viewModel.achievements.count),
                    progress: Double(viewModel.unlockedCount) / Double(max(viewModel.achievements.count, 1)),
                    detail: L("achievements_hint"),
                    symbolName: "trophy.fill"
                )

                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(viewModel.achievements) { achievement in
                        AchievementCard(achievement: achievement)
                    }
                }
            }
            .padding(16)
        }
        .appScreenBackground()
        .navigationTitle(L("achievements_title"))
        .navigationBarTitleDisplayMode(.large)
        .toolbarBackground(AppTheme.background, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .onAppear {
            viewModel.refresh()
        }
    }
}

private struct AchievementCard: View {
    let achievement: Achievement

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: achievement.isUnlocked ? achievement.sfSymbolName : "lock.fill")
                .font(.title2)
                .foregroundStyle(achievement.isUnlocked ? AppTheme.accentGold : AppTheme.textSecondary)

            Text(L(achievement.titleKey))
                .font(.headline)
                .foregroundStyle(AppTheme.textPrimary)
                .fixedSize(horizontal: false, vertical: true)

            Text(L(achievement.descriptionKey))
                .font(.caption)
                .foregroundStyle(AppTheme.textSecondary)
                .fixedSize(horizontal: false, vertical: true)

            Text(achievement.isUnlocked ? L("achievements_unlocked") : L("achievements_locked"))
                .font(.caption.weight(.semibold))
                .foregroundStyle(achievement.isUnlocked ? AppTheme.accentGold : AppTheme.textSecondary)
        }
        .frame(maxWidth: .infinity, minHeight: 180, alignment: .topLeading)
        .appCardStyle()
        .opacity(achievement.isUnlocked ? 1.0 : 0.62)
        .accessibilityElement(children: .combine)
    }
}

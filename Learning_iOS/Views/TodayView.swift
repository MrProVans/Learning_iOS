import SwiftUI

struct TodayView: View {
    @EnvironmentObject private var localization: LocalizationManager
    @Binding var selectedTab: RootTab
    @StateObject private var viewModel = TodayViewModel()

    var body: some View {
        let _ = localization.currentLanguage

        ScrollView {
            VStack(spacing: 16) {
                greetingCard
                dailyProgressCard
                focusCard
                metricGrid
                quoteCard
                achievementsLink
                quickActions
            }
            .padding(16)
        }
        .appScreenBackground()
        .navigationTitle(L("today_title"))
        .navigationBarTitleDisplayMode(.large)
        .toolbarBackground(AppTheme.background, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.25)) {
                viewModel.refresh()
            }
        }
    }

    private var greetingCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(viewModel.name.isEmpty ? L("today_greeting") : String(format: L("today_greeting_name"), viewModel.name))
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .foregroundStyle(AppTheme.textPrimary)

            Text(L("today_subtitle"))
                .font(.subheadline)
                .foregroundStyle(AppTheme.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .appCardStyle()
    }

    private var dailyProgressCard: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .stroke(AppTheme.textSecondary.opacity(0.2), lineWidth: 10)
                    .frame(width: 88, height: 88)
                Circle()
                    .trim(from: 0, to: viewModel.overallProgress)
                    .stroke(AppTheme.accentGold, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .frame(width: 88, height: 88)
                Text("\(Int(viewModel.overallProgress * 100))%")
                    .font(.headline)
                    .foregroundStyle(AppTheme.textPrimary)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text(L("today_daily_progress"))
                    .font(.headline)
                    .foregroundStyle(AppTheme.textPrimary)
                Text(String(format: L("today_habits_progress"), viewModel.completedHabits, viewModel.totalHabits))
                    .foregroundStyle(AppTheme.textSecondary)
                Text(String(format: L("today_tasks_progress"), viewModel.completedTasks, viewModel.totalTasks))
                    .foregroundStyle(AppTheme.textSecondary)
            }
            .font(.subheadline)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .appCardStyle()
    }

    private var focusCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label(L("today_focus_task"), systemImage: "target")
                .font(.headline)
                .foregroundStyle(AppTheme.textPrimary)

            if let task = viewModel.focusTask {
                HStack {
                    Image(systemName: task.priority.sfSymbolName)
                        .foregroundStyle(AppTheme.accentGold)
                    Text(task.title)
                        .foregroundStyle(AppTheme.textPrimary)
                    Spacer()
                    Text(L(task.priority.titleKey))
                        .font(.caption)
                        .foregroundStyle(AppTheme.textSecondary)
                }
            } else {
                Text(L("today_no_focus_task"))
                    .foregroundStyle(AppTheme.textSecondary)
            }
        }
        .appCardStyle()
    }

    private var metricGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            smallMetricCard(
                title: L("today_energy_average"),
                value: viewModel.todayAverageEnergy.map { String(format: "%.1f", $0) } ?? L("energy_no_score"),
                detail: String(format: L("energy_completed_categories_format"), viewModel.completedEnergyCategories, viewModel.totalEnergyCategories),
                symbol: "bolt.heart"
            )

            smallMetricCard(
                title: L("today_habits_progress_title"),
                value: "\(Int(viewModel.habitProgress * 100))%",
                detail: String(format: L("today_habits_progress"), viewModel.completedHabits, viewModel.totalHabits),
                symbol: "checkmark.seal"
            )
        }
    }

    private func smallMetricCard(title: String, value: String, detail: String, symbol: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: symbol)
                .foregroundStyle(AppTheme.accentGold)
            Text(title)
                .font(.caption)
                .foregroundStyle(AppTheme.textSecondary)
            Text(value)
                .font(.title2.weight(.bold))
                .foregroundStyle(AppTheme.textPrimary)
            Text(detail)
                .font(.caption)
                .foregroundStyle(AppTheme.textSecondary)
        }
        .frame(maxWidth: .infinity, minHeight: 132, alignment: .topLeading)
        .appCardStyle()
    }

    private var quoteCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label(L("today_quote"), systemImage: "quote.bubble.fill")
                .font(.headline)
                .foregroundStyle(AppTheme.textPrimary)
            Text("\"\(viewModel.quote.quote)\"")
                .foregroundStyle(AppTheme.textPrimary)
            Text("- \(viewModel.quote.author)")
                .font(.subheadline)
                .foregroundStyle(AppTheme.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .appCardStyle()
    }

    private var achievementsLink: some View {
        NavigationLink {
            AchievementsView()
        } label: {
            Label(L("achievements_title"), systemImage: "trophy.fill")
        }
        .buttonStyle(GoldOutlineButtonStyle())
    }

    private var quickActions: some View {
        VStack(spacing: 10) {
            Button(L("today_log_energy")) {
                AppFeedbackManager.shared.tap()
                selectedTab = .energy
            }
            .buttonStyle(GoldPrimaryButtonStyle())

            HStack(spacing: 10) {
                Button(L("today_add_habit")) {
                    AppFeedbackManager.shared.tap()
                    selectedTab = .habits
                }
                .buttonStyle(GoldOutlineButtonStyle())

                Button(L("today_add_task")) {
                    AppFeedbackManager.shared.tap()
                    selectedTab = .tasks
                }
                .buttonStyle(GoldOutlineButtonStyle())
            }
        }
    }
}

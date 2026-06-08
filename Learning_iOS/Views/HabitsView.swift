import SwiftUI

struct HabitsView: View {
    @EnvironmentObject private var localization: LocalizationManager
    @EnvironmentObject private var notifications: NotificationManager
    @Environment(\.scenePhase) private var scenePhase

    @StateObject private var viewModel = HabitsViewModel()
    @State private var showEditor = false
    @State private var editingHabit: Habit?
    @State private var habitForDelete: Habit?
    @State private var showDeleteAlert = false

    private let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        let _ = localization.currentLanguage

        ScrollView {
            VStack(spacing: 16) {
                ProgressSummaryCard(
                    title: L("habits_today_title"),
                    subtitle: String(format: L("habits_completed_total_format"), viewModel.completedTodayCount, viewModel.totalHabitsCount),
                    progress: viewModel.completionProgress,
                    detail: String(format: L("tasks_progress_percent_format"), Int(viewModel.completionProgress * 100)),
                    symbolName: "checkmark.seal"
                )

                NavigationLink {
                    HabitsUIKitHostView()
                        .navigationTitle("\(L("tab_habits")) (UIKit)")
                        .navigationBarTitleDisplayMode(.inline)
                } label: {
                    Text(L("open_uikit_version"))
                }
                .buttonStyle(GoldOutlineButtonStyle())

                if viewModel.habits.isEmpty {
                    EmptyStateView(
                        title: L("habits_empty_title"),
                        message: L("habits_empty_message"),
                        systemImage: "square.grid.2x2",
                        buttonTitle: L("add_habit")
                    ) {
                        editingHabit = nil
                        showEditor = true
                    }
                } else {
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(viewModel.habits) { habit in
                            HabitCard(habit: habit)
                                .onTapGesture {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                                        viewModel.toggle(habit)
                                    }
                                }
                                .contextMenu {
                                    Button(L("edit_habit")) {
                                        editingHabit = habit
                                        showEditor = true
                                    }

                                    Button(L("delete"), role: .destructive) {
                                        habitForDelete = habit
                                        showDeleteAlert = true
                                    }
                                }
                        }
                    }
                }
            }
            .padding(16)
        }
        .appScreenBackground()
        .navigationTitle(L("tab_habits"))
        .navigationBarTitleDisplayMode(.large)
        .toolbarBackground(AppTheme.background, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    editingHabit = nil
                    showEditor = true
                } label: {
                    Image(systemName: "plus")
                        .foregroundStyle(AppTheme.accentGold)
                }
                .accessibilityLabel(L("add_habit"))
            }
        }
        .sheet(isPresented: $showEditor) {
            HabitEditorView(
                existingHabit: editingHabit,
                iconChoices: viewModel.iconChoices,
                defaultReminderTime: notifications.defaultReminderTime
            ) { title, icon, reminderEnabled, reminderTime in
                if let editingHabit {
                    var updated = editingHabit
                    updated.title = title
                    updated.sfSymbolName = icon
                    updated.reminderEnabled = reminderEnabled
                    viewModel.updateHabit(updated, reminderTime: reminderTime)
                } else {
                    viewModel.addHabit(
                        title: title,
                        symbol: icon,
                        reminderEnabled: reminderEnabled,
                        reminderTime: reminderTime
                    )
                }
            }
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active {
                viewModel.normalizeForToday()
                viewModel.checkForegroundReminder()
            }
        }
        .alert(L("delete"), isPresented: $showDeleteAlert) {
            Button(L("cancel"), role: .cancel) {}
            Button(L("delete"), role: .destructive) {
                guard let habitForDelete else { return }
                viewModel.deleteHabit(habitForDelete)
            }
        } message: {
            Text(habitForDelete?.title ?? "")
        }
        .alert(L("notifications_title"), isPresented: Binding(
            get: { viewModel.pendingReminderHabitName != nil },
            set: { show in
                if !show { viewModel.clearReminderAlert() }
            }
        )) {
            Button(L("ok"), role: .cancel) {
                viewModel.clearReminderAlert()
            }
        } message: {
            Text(String(format: L("habit_not_completed_message"), viewModel.pendingReminderHabitName ?? ""))
        }
    }
}

private struct HabitCard: View {
    let habit: Habit

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                AppIconImageView(assetName: nil, fallbackSystemName: habit.sfSymbolName, size: 24)

                Spacer()

                Image(systemName: habit.isDoneToday ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(habit.isDoneToday ? AppTheme.accentGold : AppTheme.textSecondary)
            }

            Text(habit.title)
                .font(.headline)
                .foregroundStyle(AppTheme.textPrimary)

            Text(String(format: L("streak_format"), habit.streak))
                .font(.caption)
                .foregroundStyle(AppTheme.textSecondary)
        }
        .frame(maxWidth: .infinity, minHeight: 120, alignment: .topLeading)
        .appCardStyle()
        .scaleEffect(habit.isDoneToday ? 0.98 : 1.0)
        .opacity(habit.isDoneToday ? 0.92 : 1.0)
    }
}

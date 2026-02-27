import SwiftUI

struct HabitsView: View {
    @StateObject private var viewModel = HabitsViewModel()
    private let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                NavigationLink {
                    HabitsUIKitHostView()
                        .navigationTitle("Habits (UIKit)")
                        .navigationBarTitleDisplayMode(.inline)
                } label: {
                    Text("Open UIKit Version")
                }
                .buttonStyle(GoldOutlineButtonStyle())

                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(viewModel.habits) { habit in
                        HabitCard(habit: habit)
                            .onTapGesture {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                                    viewModel.toggle(habit)
                                }
                            }
                    }
                }
            }
            .padding(16)
        }
        .appScreenBackground()
        .navigationTitle("Habits")
        .navigationBarTitleDisplayMode(.large)
        .toolbarBackground(AppTheme.background, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}

private struct HabitCard: View {
    let habit: Habit

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: habit.sfSymbolName)
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(AppTheme.accentGold)

                Spacer()

                Image(systemName: habit.isDoneToday ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(habit.isDoneToday ? AppTheme.accentGold : AppTheme.textSecondary)
            }

            Text(habit.title)
                .font(.headline)
                .foregroundStyle(AppTheme.textPrimary)

            Text("Streak: \(habit.streak) days")
                .font(.caption)
                .foregroundStyle(AppTheme.textSecondary)
        }
        .frame(maxWidth: .infinity, minHeight: 120, alignment: .topLeading)
        .appCardStyle()
        .scaleEffect(habit.isDoneToday ? 0.98 : 1.0)
        .opacity(habit.isDoneToday ? 0.92 : 1.0)
    }
}


import SwiftUI

struct HabitEditorView: View {
    @EnvironmentObject private var localization: LocalizationManager
    @Environment(\.dismiss) private var dismiss

    let existingHabit: Habit?
    let iconChoices: [String]
    let defaultReminderTime: Date
    let onSave: (String, String, Bool, Date) -> Void

    @State private var title = ""
    @State private var selectedIcon = "figure.walk"
    @State private var reminderEnabled = false
    @State private var reminderTime = Date()

    var body: some View {
        let _ = localization.currentLanguage

        NavigationStack {
            Form {
                Section(L("habit_title")) {
                    TextField(L("habit_name_placeholder"), text: $title)
                        .foregroundStyle(AppTheme.textPrimary)
                }
                .listRowBackground(AppTheme.cardBackground)

                Section(L("habit_icon")) {
                    Picker(L("habit_icon"), selection: $selectedIcon) {
                        ForEach(iconChoices, id: \.self) { icon in
                            HStack {
                                Image(systemName: icon)
                                Text(icon)
                            }
                            .tag(icon)
                        }
                    }
                }
                .listRowBackground(AppTheme.cardBackground)

                Section(L("notifications_title")) {
                    Toggle(L("reminder_enabled"), isOn: $reminderEnabled)
                    if reminderEnabled {
                        DatePicker(
                            L("reminder_time"),
                            selection: $reminderTime,
                            displayedComponents: .hourAndMinute
                        )
                    }
                }
                .listRowBackground(AppTheme.cardBackground)
            }
            .scrollContentBackground(.hidden)
            .background(AppTheme.background.ignoresSafeArea())
            .navigationTitle(existingHabit == nil ? L("add_habit") : L("edit_habit"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(L("cancel")) {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(L("save")) {
                        onSave(title, selectedIcon, reminderEnabled, reminderTime)
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            if let habit = existingHabit {
                title = habit.title
                selectedIcon = habit.sfSymbolName
                reminderEnabled = habit.reminderEnabled
                reminderTime = Calendar.current.date(
                    from: DateComponents(hour: habit.reminderHour, minute: habit.reminderMinute)
                ) ?? defaultReminderTime
            } else {
                reminderTime = defaultReminderTime
                selectedIcon = iconChoices.first ?? "figure.walk"
            }
        }
    }
}

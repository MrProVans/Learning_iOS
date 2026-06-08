import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var localization: LocalizationManager
    @EnvironmentObject private var notifications: NotificationManager
    @EnvironmentObject private var feedback: AppFeedbackManager

    @State private var showNotificationAlert = false

    var body: some View {
        let _ = localization.currentLanguage

        Form {
            Section(L("settings_language")) {
                Picker(L("settings_language"), selection: $localization.currentLanguage) {
                    ForEach(AppLanguage.allCases) { language in
                        Text(L(language.titleKey)).tag(language)
                    }
                }
                .pickerStyle(.segmented)
                .onChange(of: localization.currentLanguage) { _, _ in
                    feedback.selectionChanged()
                }
            }
            .listRowBackground(AppTheme.cardBackground)

            Section(L("notifications_title")) {
                Toggle(
                    L("notifications_enabled"),
                    isOn: Binding(
                        get: { notifications.notificationsEnabled },
                        set: { value in
                            Task {
                                let success = await notifications.setNotificationsEnabled(value)
                                if !success {
                                    showNotificationAlert = true
                                    feedback.error()
                                } else {
                                    feedback.success()
                                }
                            }
                        }
                    )
                )

                DatePicker(
                    L("global_default_reminder"),
                    selection: Binding(
                        get: { notifications.defaultReminderTime },
                        set: {
                            notifications.setDefaultReminderTime($0)
                            feedback.selectionChanged()
                        }
                    ),
                    displayedComponents: .hourAndMinute
                )
            }
            .listRowBackground(AppTheme.cardBackground)

            Section(L("settings_interaction")) {
                Toggle(L("settings_haptics_enabled"), isOn: $feedback.hapticsEnabled)
                Toggle(L("settings_sound_enabled"), isOn: $feedback.soundEffectsEnabled)
            }
            .listRowBackground(AppTheme.cardBackground)

            Section(L("settings_about")) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Focus & Energy")
                        .font(.headline)
                        .foregroundStyle(AppTheme.textPrimary)
                    Text(L("settings_version"))
                        .font(.subheadline)
                        .foregroundStyle(AppTheme.textSecondary)
                    Text(L("settings_app_description"))
                        .font(.subheadline)
                        .foregroundStyle(AppTheme.textSecondary)
                }
                .padding(.vertical, 4)
            }
            .listRowBackground(AppTheme.cardBackground)
        }
        .scrollContentBackground(.hidden)
        .background(AppTheme.background.ignoresSafeArea())
        .navigationTitle(L("settings_title"))
        .navigationBarTitleDisplayMode(.large)
        .toolbarBackground(AppTheme.background, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .alert(L("notifications_title"), isPresented: $showNotificationAlert) {
            Button(L("ok"), role: .cancel) {}
        } message: {
            Text(L("notifications_permission_denied"))
        }
    }
}

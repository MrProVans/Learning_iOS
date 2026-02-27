import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var localization: LocalizationManager
    @EnvironmentObject private var notifications: NotificationManager

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
                                }
                            }
                        }
                    )
                )

                DatePicker(
                    L("global_default_reminder"),
                    selection: Binding(
                        get: { notifications.defaultReminderTime },
                        set: { notifications.setDefaultReminderTime($0) }
                    ),
                    displayedComponents: .hourAndMinute
                )
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

import SwiftUI

struct RootTabView: View {
    @EnvironmentObject private var localization: LocalizationManager

    var body: some View {
        let _ = localization.currentLanguage

        TabView {
            NavigationStack {
                EnergyView()
            }
            .tabItem {
                Label(L("tab_energy"), systemImage: "bolt.fill")
            }

            NavigationStack {
                HabitsView()
            }
            .tabItem {
                Label(L("tab_habits"), systemImage: "square.grid.2x2.fill")
            }

            NavigationStack {
                TasksView()
            }
            .tabItem {
                Label(L("tab_tasks"), systemImage: "checklist")
            }

            NavigationStack {
                ExploreView()
            }
            .tabItem {
                Label(L("tab_explore"), systemImage: "globe")
            }

            NavigationStack {
                SettingsView()
            }
            .tabItem {
                Label(L("tab_settings"), systemImage: "gearshape.fill")
            }
        }
        .tint(AppTheme.accentGold)
        .toolbarBackground(AppTheme.background, for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
    }
}

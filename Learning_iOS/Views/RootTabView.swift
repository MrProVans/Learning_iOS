import SwiftUI

enum RootTab: Hashable {
    case today
    case energy
    case habits
    case tasks
    case explore
    case settings
}

struct RootTabView: View {
    @EnvironmentObject private var localization: LocalizationManager
    @State private var selectedTab: RootTab = .today

    var body: some View {
        let _ = localization.currentLanguage

        TabView(selection: $selectedTab) {
            NavigationStack {
                TodayView(selectedTab: $selectedTab)
            }
            .tabItem {
                Label(L("tab_today"), systemImage: "sun.max.fill")
            }
            .tag(RootTab.today)

            NavigationStack {
                EnergyView()
            }
            .tabItem {
                Label(L("tab_energy"), systemImage: "bolt.fill")
            }
            .tag(RootTab.energy)

            NavigationStack {
                HabitsView()
            }
            .tabItem {
                Label(L("tab_habits"), systemImage: "square.grid.2x2.fill")
            }
            .tag(RootTab.habits)

            NavigationStack {
                TasksView()
            }
            .tabItem {
                Label(L("tab_tasks"), systemImage: "checklist")
            }
            .tag(RootTab.tasks)

            NavigationStack {
                ExploreView()
            }
            .tabItem {
                Label(L("tab_explore"), systemImage: "globe")
            }
            .tag(RootTab.explore)

            NavigationStack {
                SettingsView()
            }
            .tabItem {
                Label(L("tab_settings"), systemImage: "gearshape.fill")
            }
            .tag(RootTab.settings)
        }
        .tint(AppTheme.accentGold)
        .toolbarBackground(AppTheme.background, for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
    }
}

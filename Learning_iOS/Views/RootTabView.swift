import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            NavigationStack {
                EnergyView()
            }
            .tabItem {
                Label("Energy", systemImage: "bolt.fill")
            }

            NavigationStack {
                HabitsView()
            }
            .tabItem {
                Label("Habits", systemImage: "square.grid.2x2.fill")
            }

            NavigationStack {
                TasksView()
            }
            .tabItem {
                Label("Tasks", systemImage: "checklist")
            }

            NavigationStack {
                ExploreView()
            }
            .tabItem {
                Label("Explore", systemImage: "globe")
            }
        }
        .tint(AppTheme.accentGold)
        .toolbarBackground(AppTheme.background, for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
    }
}


import SwiftUI

// How to run:
// 1) Open Learning_iOS.xcodeproj in Xcode 26.x.
// 2) Select an iOS simulator and Run.
//
// Where each assignment is implemented:
// 1) Image + title + two switch buttons: Views/EnergyView.swift
// 2) Hello label + name entry + pass back + UserDefaults: Views/EnergyView.swift + Views/NameEntryView.swift + ViewModels/ProfileViewModel.swift
// 3) Tasks list actions (SwiftUI) + UITableViewController version: Views/TasksView.swift + ViewModels/TasksViewModel.swift + UIKit/TasksTableViewController.swift + UIKit/TasksUIKitHostView.swift
// 4) Habits grid (SwiftUI) + UICollectionViewController version: Views/HabitsView.swift + ViewModels/HabitsViewModel.swift + UIKit/HabitsCollectionViewController.swift + UIKit/HabitsUIKitHostView.swift
// 5) API list + pagination + retry: Views/ExploreView.swift + ViewModels/QuotesViewModel.swift + Services/QuoteService.swift

@main
struct Learning_iOSApp: App {
    var body: some Scene {
        WindowGroup {
            RootTabView()
        }
    }
}

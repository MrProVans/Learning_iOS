import SwiftUI
import UIKit

struct HabitsUIKitHostView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UINavigationController {
        let controller = HabitsCollectionViewController()
        let nav = UINavigationController(rootViewController: controller)
        nav.navigationBar.prefersLargeTitles = true
        nav.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.appTextPrimary]
        nav.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.appTextPrimary]
        nav.navigationBar.tintColor = .appAccentGold
        nav.view.backgroundColor = .appBackground
        return nav
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        uiViewController.topViewController?.title = L("tab_habits")
    }
}

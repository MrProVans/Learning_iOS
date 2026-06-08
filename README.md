# Learning_iOS

Learning_iOS is a SwiftUI university learning project for **InnerDrive**, a personal energy, habits and focus tracker for self-development. The app combines a dark black/gold/white visual identity with daily tracking, reminders, quotes, localization, achievements, and interaction feedback.

## Final Feature List

- Today dashboard with greeting, daily progress, focus task, energy, habits, quote and quick actions.
- First-launch onboarding with three short product pages.
- Energy tracker with physical, emotional, intellectual and spiritual categories.
- Daily energy logging with notes, recent entries, update-on-same-day behavior, and 7/30 day analytics.
- Habit tracker with streaks, add/edit/delete, reminders, and daily completion progress.
- Task tracker with persistence, priorities, due dates, notes, filters, editing, and progress summary.
- Explore screen with paginated quotes from DummyJSON and persistent favorites.
- Achievements screen with locked and unlocked badges based on app activity.
- Settings for Russian/English language, notifications, onboarding replay, haptics, and sound effects.
- UIKit assignment screens for table and collection views remain available.
- Custom app icon and support for future custom image assets.

## Screens

- Today dashboard
- Energy
- Habits
- Tasks
- Explore
- Settings
- Achievements
- Onboarding

## Technologies

- Swift
- SwiftUI
- MVVM-light architecture
- UserDefaults with Codable JSON
- UserNotifications
- URLSession
- Runtime localization
- Haptics and sound feedback
- UIKit wrappers for assignment requirements

## How To Run In Xcode

1. Clone the repository:
   `git clone https://github.com/MrProVans/Learning_iOS.git`
2. Open `Learning_iOS.xcodeproj`.
3. Select an iPhone simulator.
4. Press `Cmd + R`.

## How To Test On A Real iPhone

1. Connect the iPhone to the Mac.
2. Select the iPhone as the run destination in Xcode.
3. Open Signing & Capabilities and select a valid development team if needed.
4. Press `Cmd + R`.
5. If iOS asks, trust the developer profile in device settings.
6. Test notifications after granting permission in the app.

## Manual QA Checklist

- Launch app and confirm onboarding appears on first launch.
- Use Skip and Get Started, then confirm onboarding does not reappear automatically.
- Reopen onboarding from Settings.
- Switch between all tabs.
- Confirm Today dashboard loads with no data and updates after adding activity.
- Save an energy entry.
- Save another entry for the same category on the same day and confirm it updates instead of duplicating.
- Open energy analytics and review 7/30 day summaries.
- Add a habit.
- Complete and uncomplete a habit.
- Edit a habit.
- Delete a habit.
- Enable notifications if the simulator or device allows it.
- Add a task with priority and due date.
- Complete a task.
- Edit a task.
- Delete a task.
- Restart the app and verify tasks persist.
- Open Explore and refresh quotes.
- Mark a quote as favorite.
- Switch to the favorites filter.
- Open Achievements and confirm locked/unlocked states display correctly.
- Switch language between Russian and English.
- Toggle haptics and sounds.
- Confirm the app keeps the black/gold/white dark visual style.

## Future Improvements

- Custom generated images for energy categories.
- Home screen widgets.
- Swift Charts advanced analytics.
- Data export.
- iCloud sync.

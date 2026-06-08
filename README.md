# Learning_iOS

Learning_iOS is a SwiftUI university learning project for a personal productivity app called **Focus & Energy**. It combines energy tracking, habit tracking, tasks, quotes, localization, reminders, and interaction feedback in one dark black/gold/white interface.

## Features

- Energy tracker with four categories: physical, emotional, intellectual, spiritual.
- Daily energy logging with notes, recent entries, and 7/30 day analytics.
- Habit tracker with streaks, add/edit/delete, reminders, and daily completion progress.
- Task tracker with persistence, priorities, due dates, notes, filters, editing, and progress summary.
- Explore tab with paginated quotes from DummyJSON and persistent favorites.
- Settings for Russian/English language, notifications, haptics, and sound effects.
- UIKit assignment screens for table and collection views remain available.

## Technologies Used

- Swift
- SwiftUI
- MVVM-light architecture
- UserDefaults with Codable JSON
- UserNotifications
- URLSession
- Runtime localization
- UIKit wrappers for assignment requirements
- AudioToolbox and UIKit haptic feedback

## How To Run In Xcode

1. Clone the repository:
   `git clone https://github.com/MrProVans/Learning_iOS.git`
2. Open `Learning_iOS.xcodeproj`.
3. Select an iPhone simulator.
4. Press `Cmd + R`.

## How To Test On A Real iPhone

1. Connect the iPhone to the Mac.
2. Select the iPhone as the run destination in Xcode.
3. Open Signing & Capabilities and select a valid development team.
4. Run the app.
5. If iOS asks, trust the developer profile in device settings.

## Manual Testing Checklist

- Launch app and switch between all tabs.
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
- Switch language between Russian and English.
- Toggle haptics and sounds.
- Confirm the app keeps the black/gold/white dark visual style.

## Future Improvements

- Custom generated images for energy and habit categories.
- Home screen widgets.
- Advanced analytics and deeper charts.
- Data export.
- iCloud sync.

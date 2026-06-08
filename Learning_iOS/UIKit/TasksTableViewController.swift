import UIKit

final class TasksTableViewController: UITableViewController {
    private var tasks: [TaskItem] = [
        TaskItem(title: L("starter_task_plan"), priority: .high),
        TaskItem(title: L("starter_task_focus"), priority: .medium),
        TaskItem(title: L("starter_task_review"), priority: .low)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = L("tab_tasks")
        tableView.backgroundColor = .appBackground
        tableView.separatorColor = UIColor.appTextSecondary.withAlphaComponent(0.2)
        navigationItem.rightBarButtonItem = editButtonItem
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let task = tasks[indexPath.row]
        cell.backgroundColor = .appCardBackground
        cell.textLabel?.text = task.title
        cell.textLabel?.textColor = .appTextPrimary
        cell.detailTextLabel?.text = task.isDone ? L("completed") : L("pending")
        cell.detailTextLabel?.textColor = .appTextSecondary
        cell.accessoryType = task.isDone ? .checkmark : .none
        cell.tintColor = .appAccentGold
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tasks[indexPath.row].isDone.toggle()
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }

    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        true
    }

    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let moved = tasks.remove(at: sourceIndexPath.row)
        tasks.insert(moved, at: destinationIndexPath.row)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        tasks.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}

import UIKit

final class HabitsCollectionViewController: UICollectionViewController {
    private var habits: [Habit] = [
        Habit(title: "Morning Walk", sfSymbolName: "figure.walk", streak: 6),
        Habit(title: "Deep Work", sfSymbolName: "timer", streak: 4),
        Habit(title: "Read 20 min", sfSymbolName: "book.fill", streak: 9),
        Habit(title: "Hydrate", sfSymbolName: "drop.fill", streak: 11),
        Habit(title: "No Late Scroll", sfSymbolName: "moon.zzz.fill", streak: 3),
        Habit(title: "Journal", sfSymbolName: "pencil.and.list.clipboard", streak: 5)
    ]

    init() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 12
        super.init(collectionViewLayout: layout)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Habits"
        collectionView.backgroundColor = .appBackground
        collectionView.register(HabitCell.self, forCellWithReuseIdentifier: HabitCell.reuseID)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        habits.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HabitCell.reuseID, for: indexPath)
        guard let habitCell = cell as? HabitCell else { return cell }
        habitCell.configure(with: habits[indexPath.item])
        return habitCell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        habits[indexPath.item].isDoneToday.toggle()
        if habits[indexPath.item].isDoneToday {
            habits[indexPath.item].streak += 1
        } else {
            habits[indexPath.item].streak = max(0, habits[indexPath.item].streak - 1)
        }
        collectionView.reloadItems(at: [indexPath])
    }
}

extension HabitsCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalSpacing: CGFloat = 12
        let width = (collectionView.bounds.width - totalSpacing - 2) / 2
        return CGSize(width: width, height: 120)
    }
}

private final class HabitCell: UICollectionViewCell {
    static let reuseID = "HabitCell"

    private let iconView = UIImageView()
    private let titleLabel = UILabel()
    private let streakLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        layer.cornerRadius = 14
        layer.borderWidth = 1
        layer.borderColor = UIColor.appAccentGold.withAlphaComponent(0.7).cgColor
        backgroundColor = .appCardBackground

        iconView.tintColor = .appAccentGold
        iconView.contentMode = .scaleAspectFit

        titleLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        titleLabel.textColor = .appTextPrimary

        streakLabel.font = .systemFont(ofSize: 12, weight: .regular)
        streakLabel.textColor = .appTextSecondary

        let stack = UIStackView(arrangedSubviews: [iconView, titleLabel, streakLabel])
        stack.axis = .vertical
        stack.spacing = 6
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            stack.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -12),
            iconView.heightAnchor.constraint(equalToConstant: 24),
            iconView.widthAnchor.constraint(equalToConstant: 24)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with habit: Habit) {
        iconView.image = UIImage(systemName: habit.sfSymbolName)
        titleLabel.text = habit.title
        streakLabel.text = "Streak: \(habit.streak) days"
        alpha = habit.isDoneToday ? 0.9 : 1.0
    }
}

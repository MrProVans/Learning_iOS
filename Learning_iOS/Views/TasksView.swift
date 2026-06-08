import SwiftUI

struct TasksView: View {
    @EnvironmentObject private var localization: LocalizationManager
    @StateObject private var viewModel = TasksViewModel()
    @State private var isPresentingAdd = false
    @State private var editingTask: TaskItem?

    var body: some View {
        let _ = localization.currentLanguage

        List {
            Section {
                ProgressSummaryCard(
                    title: L("tasks_today_focus"),
                    subtitle: String(format: L("tasks_completed_total_format"), viewModel.completedCount, viewModel.tasks.count),
                    progress: viewModel.completionProgress,
                    detail: String(format: L("tasks_progress_percent_format"), Int(viewModel.completionProgress * 100)),
                    symbolName: "target"
                )
                .listRowInsets(EdgeInsets())
                .listRowBackground(AppTheme.background)
            }

            Section {
                Picker(L("task_filter_title"), selection: $viewModel.filter) {
                    ForEach(TaskFilter.allCases) { filter in
                        Text(L(filter.titleKey)).tag(filter)
                    }
                }
                .pickerStyle(.segmented)
                .listRowBackground(AppTheme.cardBackground)
            }

            Section {
                NavigationLink {
                    TasksUIKitHostView()
                        .navigationTitle("\(L("tab_tasks")) (UIKit)")
                        .navigationBarTitleDisplayMode(.inline)
                } label: {
                    Text(L("open_uikit_version"))
                        .foregroundStyle(AppTheme.accentGold)
                }
                .listRowBackground(AppTheme.cardBackground)
            }

            if viewModel.filteredTasks.isEmpty {
                EmptyStateView(
                    title: L("tasks_empty_title"),
                    message: viewModel.tasks.isEmpty ? L("empty_tasks") : L("tasks_filter_empty"),
                    systemImage: "checklist",
                    buttonTitle: L("add_task")
                ) {
                    isPresentingAdd = true
                }
                .listRowInsets(EdgeInsets())
                .listRowBackground(AppTheme.background)
            } else {
                ForEach(viewModel.filteredTasks) { task in
                    TaskRow(task: task)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            viewModel.toggle(task)
                        }
                        .contextMenu {
                            Button(L("edit_task")) {
                                editingTask = task
                            }
                            Button(L("delete"), role: .destructive) {
                                viewModel.delete(task)
                            }
                        }
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                viewModel.delete(task)
                            } label: {
                                Label(L("delete"), systemImage: "trash")
                            }

                            Button {
                                editingTask = task
                            } label: {
                                Label(L("edit_task"), systemImage: "pencil")
                            }
                            .tint(AppTheme.accentGold)
                        }
                        .listRowBackground(AppTheme.cardBackground)
                }
                .onDelete(perform: viewModel.delete)
                .onMove(perform: viewModel.move)
            }
        }
        .listStyle(.plain)
        .appScreenBackground()
        .navigationTitle(L("tab_tasks"))
        .navigationBarTitleDisplayMode(.large)
        .toolbarBackground(AppTheme.background, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                EditButton().foregroundStyle(AppTheme.accentGold)
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isPresentingAdd = true
                } label: {
                    Image(systemName: "plus")
                        .foregroundStyle(AppTheme.accentGold)
                }
            }
        }
        .sheet(isPresented: $isPresentingAdd) {
            TaskEditorSheet(mode: .add) { title, priority, dueDate, notes in
                viewModel.addTask(title: title, priority: priority, dueDate: dueDate, notes: notes)
            }
            .presentationDetents([.medium, .large])
        }
        .sheet(item: $editingTask) { task in
            TaskEditorSheet(mode: .edit(task)) { title, priority, dueDate, notes in
                viewModel.updateTask(task, title: title, priority: priority, dueDate: dueDate, notes: notes)
            }
            .presentationDetents([.medium, .large])
        }
    }
}

private struct TaskRow: View {
    let task: TaskItem

    private static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: task.isDone ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(task.isDone ? AppTheme.accentGold : AppTheme.textSecondary)

            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Image(systemName: task.priority.sfSymbolName)
                        .foregroundStyle(AppTheme.accentGold)
                        .font(.caption)

                    Text(task.title)
                        .foregroundStyle(AppTheme.textPrimary)
                        .strikethrough(task.isDone, color: AppTheme.textSecondary)
                }

                Text(Self.formatter.string(from: task.createdAt))
                    .font(.caption)
                    .foregroundStyle(AppTheme.textSecondary)

                if let dueDate = task.dueDate {
                    Text("\(L("task_due_date")): \(Self.formatter.string(from: dueDate))")
                        .font(.caption)
                        .foregroundStyle(AppTheme.textSecondary)
                }

                if let notes = task.notes, !notes.isEmpty {
                    Text(notes)
                        .font(.caption)
                        .foregroundStyle(AppTheme.textSecondary)
                        .lineLimit(2)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

private enum TaskEditorMode: Identifiable {
    case add
    case edit(TaskItem)

    var id: String {
        switch self {
        case .add: return "add"
        case let .edit(task): return task.id.uuidString
        }
    }
}

private struct TaskEditorSheet: View {
    @EnvironmentObject private var localization: LocalizationManager
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @State private var priority: TaskPriority = .medium
    @State private var hasDueDate = false
    @State private var dueDate = Date()
    @State private var notes = ""

    let mode: TaskEditorMode
    let onSave: (String, TaskPriority, Date?, String?) -> Void

    var body: some View {
        let _ = localization.currentLanguage

        NavigationStack {
            Form {
                Section(L("task_details")) {
                    TextField(L("task_title_placeholder"), text: $title)
                        .foregroundStyle(AppTheme.textPrimary)

                    Picker(L("task_priority"), selection: $priority) {
                        ForEach(TaskPriority.allCases) { priority in
                            Label(L(priority.titleKey), systemImage: priority.sfSymbolName)
                                .tag(priority)
                        }
                    }

                    Toggle(L("task_has_due_date"), isOn: $hasDueDate)
                    if hasDueDate {
                        DatePicker(L("task_due_date"), selection: $dueDate)
                    }

                    TextField(L("task_notes_placeholder"), text: $notes, axis: .vertical)
                        .lineLimit(3...5)
                }
                .listRowBackground(AppTheme.cardBackground)
            }
            .scrollContentBackground(.hidden)
            .background(AppTheme.background.ignoresSafeArea())
            .navigationTitle(navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(L("cancel")) { dismiss() }
                        .foregroundStyle(AppTheme.accentGold)
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button(L("save")) {
                        onSave(title, priority, hasDueDate ? dueDate : nil, notes)
                        dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
        .onAppear(perform: populate)
    }

    private var navigationTitle: String {
        switch mode {
        case .add: return L("new_task")
        case .edit: return L("edit_task")
        }
    }

    private func populate() {
        guard case let .edit(task) = mode else { return }
        title = task.title
        priority = task.priority
        hasDueDate = task.dueDate != nil
        dueDate = task.dueDate ?? Date()
        notes = task.notes ?? ""
    }
}

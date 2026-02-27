import SwiftUI

struct TasksView: View {
    @StateObject private var viewModel = TasksViewModel()
    @State private var isPresentingAdd = false

    var body: some View {
        List {
            Section {
                NavigationLink {
                    TasksUIKitHostView()
                        .navigationTitle("Tasks (UIKit)")
                        .navigationBarTitleDisplayMode(.inline)
                } label: {
                    Text("Open UIKit Version")
                        .foregroundStyle(AppTheme.accentGold)
                }
                .listRowBackground(AppTheme.cardBackground)
            }

            if viewModel.tasks.isEmpty {
                Text("No tasks yet. Add one to start focused work.")
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.textSecondary)
                    .padding(.vertical, 12)
                    .listRowBackground(AppTheme.background)
            } else {
                ForEach(viewModel.tasks) { task in
                    TaskRow(task: task)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            viewModel.toggle(task)
                        }
                        .listRowBackground(AppTheme.cardBackground)
                }
                .onDelete(perform: viewModel.delete)
                .onMove(perform: viewModel.move)
            }
        }
        .listStyle(.plain)
        .appScreenBackground()
        .navigationTitle("Tasks")
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
            AddTaskSheet { title in
                viewModel.addTask(title: title)
            }
            .presentationDetents([.height(240)])
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
                Text(task.title)
                    .foregroundStyle(AppTheme.textPrimary)
                    .strikethrough(task.isDone, color: AppTheme.textSecondary)

                Text(Self.formatter.string(from: task.createdAt))
                    .font(.caption)
                    .foregroundStyle(AppTheme.textSecondary)
            }
        }
        .padding(.vertical, 4)
    }
}

private struct AddTaskSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    let onSave: (String) -> Void

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                TextField("Task title", text: $title)
                    .padding(12)
                    .background(AppTheme.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(AppTheme.accentGold.opacity(0.65), lineWidth: 1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .foregroundStyle(AppTheme.textPrimary)

                Button("Add Task") {
                    onSave(title)
                    dismiss()
                }
                .buttonStyle(GoldPrimaryButtonStyle())

                Spacer()
            }
            .padding(16)
            .appScreenBackground()
            .navigationTitle("New Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundStyle(AppTheme.accentGold)
                }
            }
        }
    }
}


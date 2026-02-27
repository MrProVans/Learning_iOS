import SwiftUI

struct NameEntryView: View {
    @ObservedObject var profileVM: ProfileViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var draftName = ""

    var body: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 10) {
                Text("Your Name")
                    .font(.headline)
                    .foregroundStyle(AppTheme.textPrimary)

                TextField("Type your name", text: $draftName)
                    .textInputAutocapitalization(.words)
                    .autocorrectionDisabled()
                    .padding(12)
                    .background(AppTheme.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(AppTheme.accentGold.opacity(0.65), lineWidth: 1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .foregroundStyle(AppTheme.textPrimary)
            }
            .appCardStyle()

            Button("Save") {
                profileVM.save(draftName)
                dismiss()
            }
            .buttonStyle(GoldPrimaryButtonStyle())

            Spacer()
        }
        .padding(16)
        .appScreenBackground()
        .navigationTitle("Enter name")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(AppTheme.background, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .task {
            draftName = profileVM.name
        }
    }
}


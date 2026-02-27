import SwiftUI

struct NameEntryView: View {
    @EnvironmentObject private var localization: LocalizationManager
    @ObservedObject var profileVM: ProfileViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var draftName = ""

    var body: some View {
        let _ = localization.currentLanguage

        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 10) {
                Text(L("your_name"))
                    .font(.headline)
                    .foregroundStyle(AppTheme.textPrimary)

                TextField(L("name_placeholder"), text: $draftName)
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

            Button(L("save")) {
                profileVM.save(draftName)
                dismiss()
            }
            .buttonStyle(GoldPrimaryButtonStyle())

            Spacer()
        }
        .padding(16)
        .appScreenBackground()
        .navigationTitle(L("enter_name"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(AppTheme.background, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .task {
            draftName = profileVM.name
        }
    }
}

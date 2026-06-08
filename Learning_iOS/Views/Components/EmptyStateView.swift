import SwiftUI

struct EmptyStateView: View {
    let title: String
    let message: String
    var systemImage: String = "tray"
    var buttonTitle: String?
    var action: (() -> Void)?

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: systemImage)
                .font(.largeTitle)
                .foregroundStyle(AppTheme.accentGold)

            Text(title)
                .font(.headline)
                .foregroundStyle(AppTheme.textPrimary)
                .multilineTextAlignment(.center)

            Text(message)
                .font(.subheadline)
                .foregroundStyle(AppTheme.textSecondary)
                .multilineTextAlignment(.center)

            if let buttonTitle, let action {
                Button(buttonTitle, action: action)
                    .buttonStyle(GoldPrimaryButtonStyle())
            }
        }
        .frame(maxWidth: .infinity)
        .appCardStyle()
    }
}

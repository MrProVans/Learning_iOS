import SwiftUI

struct AppTheme {
    static let background = Color(red: 11.0 / 255.0, green: 11.0 / 255.0, blue: 15.0 / 255.0)
    static let cardBackground = Color(red: 20.0 / 255.0, green: 20.0 / 255.0, blue: 26.0 / 255.0)
    static let accentGold = Color(red: 245.0 / 255.0, green: 166.0 / 255.0, blue: 35.0 / 255.0)
    static let textPrimary = Color(red: 242.0 / 255.0, green: 242.0 / 255.0, blue: 242.0 / 255.0)
    static let textSecondary = Color(red: 160.0 / 255.0, green: 160.0 / 255.0, blue: 168.0 / 255.0)

    static let cardCornerRadius: CGFloat = 14

    static let heroGradient = LinearGradient(
        colors: [accentGold.opacity(0.95), accentGold.opacity(0.65)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

#if canImport(UIKit)
import UIKit

extension UIColor {
    static let appBackground = UIColor(red: 11.0 / 255.0, green: 11.0 / 255.0, blue: 15.0 / 255.0, alpha: 1)
    static let appCardBackground = UIColor(red: 20.0 / 255.0, green: 20.0 / 255.0, blue: 26.0 / 255.0, alpha: 1)
    static let appAccentGold = UIColor(red: 245.0 / 255.0, green: 166.0 / 255.0, blue: 35.0 / 255.0, alpha: 1)
    static let appTextPrimary = UIColor(red: 242.0 / 255.0, green: 242.0 / 255.0, blue: 242.0 / 255.0, alpha: 1)
    static let appTextSecondary = UIColor(red: 160.0 / 255.0, green: 160.0 / 255.0, blue: 168.0 / 255.0, alpha: 1)
}
#endif

struct CardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(16)
            .background(AppTheme.cardBackground)
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.cardCornerRadius)
                    .stroke(AppTheme.accentGold.opacity(0.65), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.cardCornerRadius))
            .shadow(color: .black.opacity(0.35), radius: 8, x: 0, y: 4)
    }
}

extension View {
    func appCardStyle() -> some View {
        modifier(CardModifier())
    }

    func appScreenBackground() -> some View {
        self
            .scrollContentBackground(.hidden)
            .background(AppTheme.background.ignoresSafeArea())
    }
}

struct GoldPrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundStyle(.black)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(AppTheme.heroGradient)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
    }
}

struct GoldOutlineButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundStyle(AppTheme.accentGold)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(AppTheme.accentGold, lineWidth: 1)
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .opacity(configuration.isPressed ? 0.85 : 1.0)
    }
}

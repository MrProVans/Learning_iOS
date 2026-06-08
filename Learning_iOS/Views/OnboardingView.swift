import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject private var localization: LocalizationManager
    @State private var page = 0

    let onFinish: () -> Void

    private let pages: [(titleKey: String, textKey: String, symbol: String)] = [
        ("onboarding_energy_title", "onboarding_energy_text", "bolt.heart.fill"),
        ("onboarding_discipline_title", "onboarding_discipline_text", "checkmark.seal.fill"),
        ("onboarding_focus_title", "onboarding_focus_text", "target")
    ]

    var body: some View {
        let _ = localization.currentLanguage

        VStack(spacing: 24) {
            TabView(selection: $page) {
                ForEach(pages.indices, id: \.self) { index in
                    onboardingPage(pages[index])
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))

            HStack(spacing: 12) {
                Button(L("onboarding_skip")) {
                    AppFeedbackManager.shared.tap()
                    onFinish()
                }
                .buttonStyle(GoldOutlineButtonStyle())

                Button(page == pages.count - 1 ? L("onboarding_get_started") : L("onboarding_next")) {
                    AppFeedbackManager.shared.selectionChanged()
                    if page == pages.count - 1 {
                        AppFeedbackManager.shared.success()
                        onFinish()
                    } else {
                        withAnimation(.easeInOut) {
                            page += 1
                        }
                    }
                }
                .buttonStyle(GoldPrimaryButtonStyle())
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 24)
        }
        .background(AppTheme.background.ignoresSafeArea())
    }

    private func onboardingPage(_ page: (titleKey: String, textKey: String, symbol: String)) -> some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: page.symbol)
                .font(.system(size: 84, weight: .bold))
                .foregroundStyle(AppTheme.accentGold)
                .accessibilityHidden(true)

            Text(L(page.titleKey))
                .font(.system(size: 34, weight: .heavy, design: .rounded))
                .foregroundStyle(AppTheme.textPrimary)
                .multilineTextAlignment(.center)

            Text(L(page.textKey))
                .font(.body)
                .foregroundStyle(AppTheme.textSecondary)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .padding(.horizontal, 28)

            Spacer()
        }
        .padding(20)
    }
}

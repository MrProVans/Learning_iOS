import SwiftUI

struct EnergyView: View {
    @StateObject private var profileVM = ProfileViewModel()
    @StateObject private var energyVM = EnergyViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                greetingCard
                energyCarouselCard
            }
            .padding(16)
        }
        .appScreenBackground()
        .navigationTitle("Focus & Energy")
        .navigationBarTitleDisplayMode(.large)
        .toolbarBackground(AppTheme.background, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }

    private var greetingCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(profileVM.name.isEmpty ? "Hello" : "Hello, \(profileVM.name)")
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .foregroundStyle(AppTheme.textPrimary)

            NavigationLink {
                NameEntryView(profileVM: profileVM)
            } label: {
                Text("Enter name")
            }
            .buttonStyle(GoldOutlineButtonStyle())
        }
        .appCardStyle()
    }

    private var energyCarouselCard: some View {
        VStack(spacing: 16) {
            Text(energyVM.currentCategory.title)
                .font(.system(size: 32, weight: .heavy, design: .rounded))
                .foregroundStyle(AppTheme.textPrimary)

            HStack(spacing: 14) {
                Button {
                    energyVM.previous()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2.weight(.bold))
                        .frame(width: 42, height: 42)
                }
                .buttonStyle(GoldOutlineButtonStyle())
                .frame(maxWidth: 80)

                Image(systemName: energyVM.currentCategory.sfSymbolName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 112, height: 112)
                    .foregroundStyle(AppTheme.accentGold)
                    .padding(24)
                    .background(AppTheme.accentGold.opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: 16))

                Button {
                    energyVM.next()
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.title2.weight(.bold))
                        .frame(width: 42, height: 42)
                }
                .buttonStyle(GoldOutlineButtonStyle())
                .frame(maxWidth: 80)
            }

            Text(energyVM.currentCategory.description)
                .font(.subheadline)
                .foregroundStyle(AppTheme.textSecondary)
                .multilineTextAlignment(.center)
        }
        .appCardStyle()
    }
}


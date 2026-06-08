import SwiftUI

struct EnergyView: View {
    @EnvironmentObject private var localization: LocalizationManager
    @StateObject private var profileVM = ProfileViewModel()
    @StateObject private var energyVM = EnergyViewModel()

    private static let entryDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()

    var body: some View {
        let _ = localization.currentLanguage

        ScrollView {
            VStack(spacing: 20) {
                energyOverviewCard
                greetingCard
                energyCarouselCard
                metricLogCard
                recentEntriesCard
            }
            .padding(16)
        }
        .appScreenBackground()
        .navigationTitle(L("tab_energy"))
        .navigationBarTitleDisplayMode(.large)
        .toolbarBackground(AppTheme.background, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }

    private var energyOverviewCard: some View {
        let averageText = energyVM.todayAverageEnergy.map { String(format: "%.1f / 10", $0) } ?? L("energy_no_score")
        let completedText = String(
            format: L("energy_completed_categories_format"),
            energyVM.completedCategoriesToday,
            energyVM.totalCategoriesCount
        )

        return ProgressSummaryCard(
            title: L("energy_today_title"),
            subtitle: "\(averageText) · \(completedText)",
            progress: Double(energyVM.completedCategoriesToday) / Double(max(energyVM.totalCategoriesCount, 1)),
            detail: L(energyVM.energyStatusTextKey),
            symbolName: "bolt.heart"
        )
    }

    private var greetingCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            if profileVM.name.isEmpty {
                Text(L("hello"))
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .foregroundStyle(AppTheme.textPrimary)
            } else {
                Text(String(format: L("hello_with_name"), profileVM.name))
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .foregroundStyle(AppTheme.textPrimary)
            }

            NavigationLink {
                NameEntryView(profileVM: profileVM)
            } label: {
                Text(L("enter_name"))
            }
            .buttonStyle(GoldOutlineButtonStyle())
        }
        .appCardStyle()
    }

    private var energyCarouselCard: some View {
        VStack(spacing: 16) {
            Text(L(energyVM.currentCategory.titleKey))
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
                .accessibilityLabel(L("accessibility_previous_energy"))
                .buttonStyle(GoldOutlineButtonStyle())
                .frame(maxWidth: 80)

                AppIconImageView(
                    assetName: energyVM.currentCategory.imageAssetName,
                    fallbackSystemName: energyVM.currentCategory.sfSymbolName,
                    size: 112
                )
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
                .accessibilityLabel(L("accessibility_next_energy"))
                .buttonStyle(GoldOutlineButtonStyle())
                .frame(maxWidth: 80)
            }

            Text(L(energyVM.currentCategory.descriptionKey))
                .font(.subheadline)
                .foregroundStyle(AppTheme.textSecondary)
                .multilineTextAlignment(.center)
        }
        .appCardStyle()
    }

    private var metricLogCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(L("energy_log_metric"))
                .font(.headline)
                .foregroundStyle(AppTheme.textPrimary)

            Text("\(L("energy_rating")): \(Int(energyVM.metricRating))")
                .font(.subheadline)
                .foregroundStyle(AppTheme.textSecondary)

            Slider(value: $energyVM.metricRating, in: 1...10, step: 1)
                .tint(AppTheme.accentGold)

            TextField(L("energy_note_placeholder"), text: $energyVM.note)
                .padding(12)
                .background(AppTheme.background)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(AppTheme.accentGold.opacity(0.65), lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .foregroundStyle(AppTheme.textPrimary)

            HStack(spacing: 10) {
                NavigationLink {
                    EnergyAnalyticsView(viewModel: energyVM, category: energyVM.currentCategory)
                } label: {
                    Text(L("energy_analytics"))
                }
                .buttonStyle(GoldOutlineButtonStyle())

                Button(L("save_entry")) {
                    energyVM.saveCurrentEntry()
                }
                .buttonStyle(GoldPrimaryButtonStyle())
            }
        }
        .appCardStyle()
    }

    private var recentEntriesCard: some View {
        let entries = energyVM.recentEntries(for: energyVM.currentCategory.id)

        return VStack(alignment: .leading, spacing: 10) {
            Text(L("recent_entries"))
                .font(.headline)
                .foregroundStyle(AppTheme.textPrimary)

            if entries.isEmpty {
                Text(L("no_entries"))
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.textSecondary)
            } else {
                ForEach(entries) { entry in
                    VStack(alignment: .leading, spacing: 2) {
                        Text("\(Self.entryDateFormatter.string(from: entry.date)) · \(entry.rating)/10")
                            .foregroundStyle(AppTheme.textPrimary)
                        if let note = entry.note, !note.isEmpty {
                            Text(note)
                                .font(.caption)
                                .foregroundStyle(AppTheme.textSecondary)
                        }
                    }
                }
            }
        }
        .appCardStyle()
    }
}

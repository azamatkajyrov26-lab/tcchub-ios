import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var auth: AuthService

    private var greeting: LocalizedStringKey {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12:  return L10n.Dashboard.greetingMorning
        case 12..<18: return L10n.Dashboard.greetingAfternoon
        default:      return L10n.Dashboard.greetingEvening
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Theme.Spacing.l) {
                    header
                    statsRow
                    SectionHeader(title: L10n.Dashboard.continueLearning)
                    DashboardCard(title: L10n.Dashboard.continueLearning,
                                  subtitle: L10n.Dashboard.continueLearningSubtitle,
                                  icon: "play.circle.fill")
                    SectionHeader(title: L10n.Dashboard.upcoming)
                    DashboardCard(title: L10n.Dashboard.upcoming,
                                  subtitle: L10n.Dashboard.upcomingSubtitle,
                                  icon: "calendar")
                    SectionHeader(title: L10n.Dashboard.stats)
                    DashboardCard(title: L10n.Dashboard.stats,
                                  subtitle: L10n.Dashboard.statsSubtitle,
                                  icon: "rosette")
                }
                .padding(Theme.Spacing.l)
            }
            .background(Theme.Color.background)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Image("LogoFull").resizable().scaledToFit().frame(height: 28)
                }
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(greeting)
                .font(.system(size: 14))
                .foregroundStyle(Theme.Color.textMid)
            Text(auth.currentUser?.fullName.isEmpty == false
                 ? auth.currentUser!.fullName
                 : (auth.currentUser?.email ?? "Learner"))
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(Theme.Color.navy)
        }
    }

    private var statsRow: some View {
        HStack(spacing: Theme.Spacing.m) {
            StatTile(value: "3", label: L10n.Tabs.courses, icon: "book.fill")
            StatTile(value: "7", label: L10n.Profile.certificates, icon: "rosette")
            StatTile(value: "12", label: L10n.Profile.badges, icon: "star.fill")
        }
    }
}

struct SectionHeader: View {
    let title: LocalizedStringKey
    var body: some View {
        Text(title)
            .font(.system(size: 13, weight: .semibold))
            .foregroundStyle(Theme.Color.textLight)
            .textCase(.uppercase)
            .padding(.top, 8)
    }
}

struct StatTile: View {
    let value: String
    let label: LocalizedStringKey
    let icon: String

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundStyle(Theme.Color.primary)
            Text(value)
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(Theme.Color.navy)
            Text(label)
                .font(.system(size: 11))
                .foregroundStyle(Theme.Color.textMid)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Theme.Spacing.m)
        .background(
            RoundedRectangle(cornerRadius: Theme.Radius.card)
                .fill(Theme.Color.card)
                .shadow(color: Theme.Color.navy.opacity(0.05), radius: 6, y: 2)
        )
    }
}

struct DashboardCard: View {
    let title: LocalizedStringKey
    let subtitle: LocalizedStringKey
    let icon: String

    var body: some View {
        HStack(spacing: Theme.Spacing.m) {
            Image(systemName: icon)
                .font(.system(size: 26))
                .foregroundStyle(Theme.Color.primary)
                .frame(width: 52, height: 52)
                .background(Theme.Color.primaryMuted)
                .clipShape(Circle())
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Theme.Color.navy)
                Text(subtitle)
                    .font(.system(size: 13))
                    .foregroundStyle(Theme.Color.textMid)
            }
            Spacer()
            Image(systemName: "chevron.right").foregroundStyle(Theme.Color.textLight)
        }
        .padding(Theme.Spacing.m)
        .background(
            RoundedRectangle(cornerRadius: Theme.Radius.card)
                .fill(Theme.Color.card)
                .shadow(color: Theme.Color.navy.opacity(0.05), radius: 8, y: 2)
        )
    }
}

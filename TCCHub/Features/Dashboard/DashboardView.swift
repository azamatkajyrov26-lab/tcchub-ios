import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var auth: AuthService

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Theme.Spacing.l) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Welcome back,")
                            .font(.system(size: 15))
                            .foregroundStyle(Theme.Color.textMid)
                        Text(auth.currentUser?.fullName ?? "Learner")
                            .font(.system(size: 26, weight: .bold))
                            .foregroundStyle(Theme.Color.navy)
                    }

                    DashboardCard(title: "Continue learning",
                                  subtitle: "Pick up where you left off",
                                  icon: "play.circle.fill")
                    DashboardCard(title: "Upcoming deadlines",
                                  subtitle: "No items due",
                                  icon: "calendar")
                    DashboardCard(title: "Your progress",
                                  subtitle: "Track certificates & badges",
                                  icon: "rosette")
                }
                .padding(Theme.Spacing.l)
            }
            .background(Theme.Color.surface)
            .navigationTitle("Dashboard")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct DashboardCard: View {
    let title: String
    let subtitle: String
    let icon: String

    var body: some View {
        HStack(spacing: Theme.Spacing.m) {
            Image(systemName: icon)
                .font(.system(size: 28))
                .foregroundStyle(Theme.Color.primary)
                .frame(width: 52, height: 52)
                .background(Theme.Color.primary.opacity(0.12))
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
                .fill(Color.white)
                .shadow(color: Theme.Color.navy.opacity(0.05), radius: 8, y: 2)
        )
    }
}

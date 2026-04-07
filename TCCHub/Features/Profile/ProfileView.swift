import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var auth: AuthService

    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack(spacing: Theme.Spacing.m) {
                        Circle()
                            .fill(Theme.Color.primary.opacity(0.15))
                            .frame(width: 64, height: 64)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .font(.system(size: 28))
                                    .foregroundStyle(Theme.Color.primary)
                            )
                        VStack(alignment: .leading, spacing: 2) {
                            Text(auth.currentUser?.fullName ?? "Learner")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundStyle(Theme.Color.navy)
                            Text(auth.currentUser?.email ?? "")
                                .font(.system(size: 13))
                                .foregroundStyle(Theme.Color.textMid)
                        }
                    }
                    .padding(.vertical, 6)
                }

                Section {
                    Label(L10n.Profile.grades,       systemImage: "chart.bar.fill")
                    Label(L10n.Profile.certificates, systemImage: "rosette")
                    Label(L10n.Profile.badges,       systemImage: "star.fill")
                    Label(L10n.Profile.calendar,     systemImage: "calendar")
                }

                Section {
                    Button(role: .destructive) {
                        auth.logout()
                    } label: {
                        Label(L10n.Profile.signOut, systemImage: "rectangle.portrait.and.arrow.right")
                    }
                }
            }
            .navigationTitle(L10n.Profile.title)
        }
    }
}

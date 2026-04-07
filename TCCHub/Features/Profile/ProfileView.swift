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
                    Label("Grades", systemImage: "chart.bar.fill")
                    Label("Certificates", systemImage: "rosette")
                    Label("Badges", systemImage: "star.fill")
                    Label("Calendar", systemImage: "calendar")
                }

                Section {
                    Button(role: .destructive) {
                        auth.logout()
                    } label: {
                        Label("Log out", systemImage: "rectangle.portrait.and.arrow.right")
                    }
                }
            }
            .navigationTitle("Profile")
        }
    }
}

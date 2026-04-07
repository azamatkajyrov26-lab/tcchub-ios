import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var auth: AuthService

    private let badges = [
        "badge-first-course", "badge-perfect-score", "badge-streak-7",
        "badge-streak-30", "badge-first-certificate", "badge-peer-helper"
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Theme.Spacing.l) {
                    profileHeader
                    badgesSection
                    menuSection
                    signOutButton
                }
                .padding(Theme.Spacing.l)
            }
            .background(Theme.Color.background)
            .navigationTitle(L10n.Profile.title)
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var profileHeader: some View {
        VStack(spacing: Theme.Spacing.m) {
            ZStack {
                Circle().fill(Theme.Color.primaryMuted).frame(width: 96, height: 96)
                Image("LogoMark").resizable().scaledToFit().frame(width: 56, height: 56)
            }
            VStack(spacing: 4) {
                Text(auth.currentUser?.fullName.isEmpty == false
                     ? auth.currentUser!.fullName
                     : "Learner")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(Theme.Color.navy)
                Text(auth.currentUser?.email ?? "")
                    .font(.system(size: 14))
                    .foregroundStyle(Theme.Color.textMid)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(Theme.Spacing.l)
        .background(
            RoundedRectangle(cornerRadius: Theme.Radius.card)
                .fill(Theme.Color.card)
                .shadow(color: Theme.Color.navy.opacity(0.05), radius: 8, y: 2)
        )
    }

    private var badgesSection: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.s) {
            HStack {
                Text(L10n.Profile.badges)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Theme.Color.textLight)
                    .textCase(.uppercase)
                Spacer()
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Theme.Spacing.m) {
                    ForEach(badges, id: \.self) { name in
                        Image(name)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 64, height: 64)
                            .padding(8)
                            .background(Theme.Color.card)
                            .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.md))
                            .shadow(color: Theme.Color.navy.opacity(0.05), radius: 4, y: 1)
                    }
                }
            }
        }
    }

    private var menuSection: some View {
        VStack(spacing: 0) {
            NavigationLink { CertificateGalleryView() } label: {
                ProfileMenuRow(icon: "rosette", title: L10n.Profile.certificates)
            }
            Divider().padding(.leading, 56)
            ProfileMenuRow(icon: "chart.bar.fill", title: L10n.Profile.grades)
            Divider().padding(.leading, 56)
            ProfileMenuRow(icon: "calendar",       title: L10n.Profile.calendar)
            Divider().padding(.leading, 56)
            NavigationLink { SettingsView() } label: {
                ProfileMenuRow(icon: "gearshape.fill", title: "settings.title")
            }
        }
        .buttonStyle(.plain)
        .background(
            RoundedRectangle(cornerRadius: Theme.Radius.card)
                .fill(Theme.Color.card)
                .shadow(color: Theme.Color.navy.opacity(0.05), radius: 6, y: 2)
        )
    }

    private var signOutButton: some View {
        Button(role: .destructive) {
            auth.logout()
        } label: {
            HStack {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                Text(L10n.Profile.signOut)
                    .font(.system(size: 16, weight: .semibold))
            }
            .frame(maxWidth: .infinity, minHeight: 52)
            .foregroundStyle(Theme.Color.error)
            .background(Theme.Color.card)
            .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.pill))
        }
    }
}

struct ProfileMenuRow: View {
    let icon: String
    let title: LocalizedStringKey

    var body: some View {
        HStack(spacing: Theme.Spacing.m) {
            Image(systemName: icon)
                .foregroundStyle(Theme.Color.primary)
                .frame(width: 24)
            Text(title)
                .foregroundStyle(Theme.Color.navy)
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 13))
                .foregroundStyle(Theme.Color.textLight)
        }
        .padding(Theme.Spacing.m)
    }
}

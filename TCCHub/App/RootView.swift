import SwiftUI

struct RootView: View {
    @EnvironmentObject var auth: AuthService
    @AppStorage("hasCompletedOnboarding") private var didOnboard = false

    var body: some View {
        Group {
            if !didOnboard {
                OnboardingView()
            } else if auth.isAuthenticated {
                AdaptiveRoot()
            } else {
                NavigationStack { LoginView() }
            }
        }
        .task { await auth.restoreSession() }
    }
}

/// Picks tab bar (compact / iPhone) or sidebar (regular / iPad) based on size class.
struct AdaptiveRoot: View {
    @Environment(\.horizontalSizeClass) private var hSize

    var body: some View {
        if hSize == .regular {
            SidebarRoot()
        } else {
            MainTabView()
        }
    }
}

// MARK: - iPhone tab layout

struct MainTabView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem { Label(L10n.Tabs.home, systemImage: "house.fill") }
            CoursesListView()
                .tabItem { Label(L10n.Tabs.courses, systemImage: "book.fill") }
            EmptyState(image: "empty-messages",
                       title: L10n.Tabs.messages,
                       subtitle: L10n.Common.loading)
                .tabItem { Label(L10n.Tabs.messages, systemImage: "bubble.left.and.bubble.right.fill") }
            EmptyState(image: "empty-notifications",
                       title: L10n.Tabs.notifications,
                       subtitle: L10n.Common.loading)
                .tabItem { Label(L10n.Tabs.notifications, systemImage: "bell.fill") }
            ProfileView()
                .tabItem { Label(L10n.Tabs.profile, systemImage: "person.fill") }
        }
        .tint(Theme.Color.primary)
    }
}

// MARK: - iPad sidebar layout

enum SidebarItem: String, Hashable, CaseIterable, Identifiable {
    case home, courses, messages, notifications, profile
    var id: Self { self }

    var title: LocalizedStringKey {
        switch self {
        case .home:          return L10n.Tabs.home
        case .courses:       return L10n.Tabs.courses
        case .messages:      return L10n.Tabs.messages
        case .notifications: return L10n.Tabs.notifications
        case .profile:       return L10n.Tabs.profile
        }
    }

    var icon: String {
        switch self {
        case .home:          return "house.fill"
        case .courses:       return "book.fill"
        case .messages:      return "bubble.left.and.bubble.right.fill"
        case .notifications: return "bell.fill"
        case .profile:       return "person.fill"
        }
    }
}

struct SidebarRoot: View {
    @State private var selection: SidebarItem? = .home

    var body: some View {
        NavigationSplitView {
            List(SidebarItem.allCases, selection: $selection) { item in
                Label(item.title, systemImage: item.icon).tag(item)
            }
            .navigationTitle("TCC Hub")
            .listStyle(.sidebar)
        } detail: {
            switch selection ?? .home {
            case .home:          DashboardView()
            case .courses:       CoursesListView()
            case .messages:      EmptyState(image: "empty-messages",
                                            title: L10n.Tabs.messages,
                                            subtitle: L10n.Common.loading)
            case .notifications: EmptyState(image: "empty-notifications",
                                            title: L10n.Tabs.notifications,
                                            subtitle: L10n.Common.loading)
            case .profile:       ProfileView()
            }
        }
        .tint(Theme.Color.primary)
    }
}

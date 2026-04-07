import SwiftUI

struct RootView: View {
    @EnvironmentObject var auth: AuthService

    var body: some View {
        Group {
            if auth.isAuthenticated {
                MainTabView()
            } else {
                NavigationStack { LoginView() }
            }
        }
        .task { await auth.restoreSession() }
    }
}

struct MainTabView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem { Label("Home", systemImage: "house.fill") }
            CoursesListView()
                .tabItem { Label("Courses", systemImage: "book.fill") }
            Text("Messages")
                .tabItem { Label("Messages", systemImage: "bubble.left.and.bubble.right.fill") }
            Text("Notifications")
                .tabItem { Label("Alerts", systemImage: "bell.fill") }
            ProfileView()
                .tabItem { Label("Profile", systemImage: "person.fill") }
        }
    }
}

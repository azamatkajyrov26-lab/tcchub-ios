import SwiftUI

@main
struct TCCHubApp: App {
    @StateObject private var auth  = AuthService()
    @StateObject private var prefs = AppPreferences()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(auth)
                .environmentObject(prefs)
                .tint(Theme.Color.primary)
                .preferredColorScheme(prefs.theme.colorScheme)
                .environment(\.locale, prefs.language.locale ?? .current)
        }
    }
}

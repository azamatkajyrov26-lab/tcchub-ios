import SwiftUI

@main
struct TCCHubApp: App {
    @StateObject private var auth = AuthService()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(auth)
                .tint(Theme.Color.primary)
        }
    }
}

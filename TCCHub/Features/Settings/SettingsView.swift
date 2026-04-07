import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var prefs: AppPreferences

    var body: some View {
        Form {
            Section {
                Picker(selection: Binding(
                    get: { prefs.theme },
                    set: { prefs.theme = $0 }
                )) {
                    ForEach(AppTheme.allCases) { Text($0.label).tag($0) }
                } label: {
                    Label("settings.theme", systemImage: "paintbrush.fill")
                }

                Picker(selection: Binding(
                    get: { prefs.language },
                    set: { prefs.language = $0 }
                )) {
                    ForEach(AppLanguage.allCases) { Text($0.label).tag($0) }
                } label: {
                    Label("settings.language", systemImage: "globe")
                }
            }

            Section(header: Text("settings.about")) {
                HStack {
                    Label("settings.version", systemImage: "info.circle")
                    Spacer()
                    Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.1.0")
                        .foregroundStyle(Theme.Color.textMid)
                }
            }
        }
        .navigationTitle("settings.title")
        .navigationBarTitleDisplayMode(.inline)
    }
}

import SwiftUI

struct AppNotification: Identifiable {
    enum Kind { case grade, message, certificate, deadline, system }
    let id = UUID()
    let kind: Kind
    let title: String
    let body: String
    let when: String
    let read: Bool
}

private let demoNotifications: [AppNotification] = [
    .init(kind: .grade, title: "Quiz graded",
          body: "You scored 92% on “Customs Basics”.", when: "2h", read: false),
    .init(kind: .certificate, title: "Certificate issued",
          body: "Your “Logistics from Scratch” certificate is ready.", when: "Yesterday", read: false),
    .init(kind: .message, title: "New message from Dana",
          body: "Thanks for the notes on warehousing 👍", when: "Yesterday", read: true),
    .init(kind: .deadline, title: "Assignment due tomorrow",
          body: "Submit “Route planning case study” by 17:00.", when: "Mon", read: true),
    .init(kind: .system, title: "Welcome to TCC Hub",
          body: "Get started by enrolling in your first course.", when: "Mar 28", read: true),
]

struct NotificationsView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Theme.Spacing.s) {
                    ForEach(demoNotifications) { NotificationRow(item: $0) }
                }
                .padding(Theme.Spacing.m)
            }
            .background(Theme.Color.background)
            .navigationTitle(L10n.Tabs.notifications)
        }
    }
}

private struct NotificationRow: View {
    let item: AppNotification

    private var icon: String {
        switch item.kind {
        case .grade:       return "checkmark.seal.fill"
        case .message:     return "bubble.left.fill"
        case .certificate: return "rosette"
        case .deadline:    return "clock.fill"
        case .system:      return "sparkles"
        }
    }

    private var tint: Color {
        switch item.kind {
        case .grade:       return Theme.Color.success
        case .message:     return Theme.Color.info
        case .certificate: return Theme.Color.primary
        case .deadline:    return Theme.Color.warning
        case .system:      return Theme.Color.navyLight
        }
    }

    var body: some View {
        HStack(alignment: .top, spacing: Theme.Spacing.m) {
            ZStack {
                Circle().fill(tint.opacity(0.15))
                Image(systemName: icon).foregroundStyle(tint)
            }
            .frame(width: 40, height: 40)

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(item.title)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(Theme.Color.navy)
                    Spacer()
                    Text(item.when)
                        .font(.system(size: 11))
                        .foregroundStyle(Theme.Color.textLight)
                }
                Text(item.body)
                    .font(.system(size: 13))
                    .foregroundStyle(Theme.Color.textMid)
                    .lineLimit(2)
            }

            if !item.read {
                Circle().fill(Theme.Color.primary).frame(width: 8, height: 8)
                    .padding(.top, 6)
            }
        }
        .padding(Theme.Spacing.m)
        .background(
            RoundedRectangle(cornerRadius: Theme.Radius.card)
                .fill(Theme.Color.card)
                .shadow(color: Theme.Color.navy.opacity(0.04), radius: 4, y: 1)
        )
    }
}

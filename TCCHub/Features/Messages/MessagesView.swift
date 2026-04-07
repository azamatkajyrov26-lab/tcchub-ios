import SwiftUI

struct ConversationPreview: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let initials: String
    let lastMessage: String
    let timestamp: String
    let unread: Int
}

private let demoConversations: [ConversationPreview] = [
    .init(name: "Aigerim Abdrakhmanova", initials: "AA",
          lastMessage: "Hi! Did you finish the customs module yet?",
          timestamp: "09:42", unread: 2),
    .init(name: "Dana Tursunova", initials: "DT",
          lastMessage: "Thanks for the notes on warehousing 👍",
          timestamp: "Yesterday", unread: 0),
    .init(name: "Logistics Cohort #14", initials: "L#",
          lastMessage: "Bekzat: assignment uploaded",
          timestamp: "Mon", unread: 0),
    .init(name: "TCC Support", initials: "TC",
          lastMessage: "Welcome to TCC Hub! Let us know if you need help.",
          timestamp: "Mar 28", unread: 0),
]

struct MessagesView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(demoConversations) { c in
                        ConversationRow(conversation: c)
                        Divider().padding(.leading, 76)
                    }
                }
                .background(Theme.Color.card)
                .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.card))
                .padding(Theme.Spacing.m)
            }
            .background(Theme.Color.background)
            .navigationTitle(L10n.Tabs.messages)
        }
    }
}

private struct ConversationRow: View {
    let conversation: ConversationPreview

    var body: some View {
        HStack(spacing: Theme.Spacing.m) {
            ZStack {
                Circle().fill(Theme.Color.primaryMuted)
                Text(conversation.initials)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(Theme.Color.primaryHover)
            }
            .frame(width: 48, height: 48)

            VStack(alignment: .leading, spacing: 3) {
                HStack {
                    Text(conversation.name)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(Theme.Color.navy)
                    Spacer()
                    Text(conversation.timestamp)
                        .font(.system(size: 11))
                        .foregroundStyle(Theme.Color.textLight)
                }
                HStack {
                    Text(conversation.lastMessage)
                        .font(.system(size: 13))
                        .foregroundStyle(Theme.Color.textMid)
                        .lineLimit(1)
                    Spacer()
                    if conversation.unread > 0 {
                        Text("\(conversation.unread)")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundStyle(Theme.Color.onPrimary)
                            .padding(.horizontal, 7)
                            .padding(.vertical, 3)
                            .background(Theme.Color.primary)
                            .clipShape(Capsule())
                    }
                }
            }
        }
        .padding(Theme.Spacing.m)
    }
}

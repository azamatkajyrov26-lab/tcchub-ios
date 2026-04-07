import SwiftUI
import AVKit

struct ActivityDetailView: View {
    let activity: Activity
    @State private var isMarking = false
    @State private var marked = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Theme.Spacing.l) {
                Text(activity.name)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(Theme.Color.navy)

                switch activity.kind {
                case .video:
                    VideoPlaceholder()
                case .document, .resource:
                    DocumentPlaceholder()
                case .quiz:
                    InfoBox(text: "Quiz — take it in Phase 3.")
                case .assignment:
                    InfoBox(text: "Assignment — submission coming in Phase 3.")
                default:
                    if let details = activity.details, !details.isEmpty {
                        Text(details).foregroundStyle(Theme.Color.textMid)
                    } else {
                        InfoBox(text: "Lesson content renders here.")
                    }
                }

                PrimaryButton(
                    title: marked ? "Completed" : "Mark as complete",
                    isLoading: isMarking
                ) {
                    Task { await markComplete() }
                }
                .disabled(marked)
            }
            .padding(Theme.Spacing.l)
        }
        .background(Theme.Color.surface)
        .navigationBarTitleDisplayMode(.inline)
    }

    private func markComplete() async {
        isMarking = true
        defer { isMarking = false }
        _ = try? await APIClient.shared.sendRaw(.completeActivity(id: activity.id))
        marked = true
    }
}

private struct InfoBox: View {
    let text: String
    var body: some View {
        Text(text)
            .font(.system(size: 14))
            .foregroundStyle(Theme.Color.textMid)
            .padding(Theme.Spacing.m)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Theme.Color.surfaceAlt)
            .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.card))
    }
}

private struct VideoPlaceholder: View {
    var body: some View {
        RoundedRectangle(cornerRadius: Theme.Radius.card)
            .fill(Theme.Color.navy)
            .frame(height: 200)
            .overlay(
                Image(systemName: "play.circle.fill")
                    .font(.system(size: 56))
                    .foregroundStyle(Theme.Color.primary)
            )
    }
}

private struct DocumentPlaceholder: View {
    var body: some View {
        HStack {
            Image(systemName: "doc.fill").font(.system(size: 32)).foregroundStyle(Theme.Color.primary)
            VStack(alignment: .leading) {
                Text("Document").font(.system(size: 15, weight: .semibold))
                Text("Preview & download").font(.caption).foregroundStyle(Theme.Color.textMid)
            }
            Spacer()
        }
        .padding(Theme.Spacing.m)
        .background(Theme.Color.surfaceAlt)
        .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.card))
    }
}

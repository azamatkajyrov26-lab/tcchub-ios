import SwiftUI

@MainActor
final class CourseDetailViewModel: ObservableObject {
    @Published var detail: CourseDetail?
    @Published var isLoading = false
    @Published var errorMessage: String?

    func load(slug: String) async {
        isLoading = true; errorMessage = nil
        defer { isLoading = false }
        do {
            detail = try await APIClient.shared.send(.courseDetail(slug: slug), as: CourseDetail.self)
        } catch {
            errorMessage = "Couldn't load course"
        }
    }

    func enroll(slug: String) async {
        _ = try? await APIClient.shared.sendRaw(.enroll(slug: slug))
    }
}

struct CourseDetailView: View {
    let slug: String
    let title: String
    @StateObject private var vm = CourseDetailViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Theme.Spacing.l) {
                if let d = vm.detail {
                    Text(d.title)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(Theme.Color.navy)
                    if let s = d.summary { Text(s).foregroundStyle(Theme.Color.textMid) }

                    PrimaryButton(title: "Enroll") {
                        Task { await vm.enroll(slug: slug) }
                    }

                    ForEach(d.sections ?? []) { section in
                        VStack(alignment: .leading, spacing: Theme.Spacing.s) {
                            Text(section.title)
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(Theme.Color.navy)
                            ForEach(section.activities ?? []) { activity in
                                NavigationLink(value: activity) {
                                    ActivityRow(activity: activity)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(Theme.Spacing.m)
                        .background(
                            RoundedRectangle(cornerRadius: Theme.Radius.card)
                                .fill(Color.white)
                        )
                    }
                } else if vm.isLoading {
                    ProgressView().tint(Theme.Color.primary).frame(maxWidth: .infinity).padding(40)
                } else if let err = vm.errorMessage {
                    Text(err).foregroundStyle(.red)
                }
            }
            .padding(Theme.Spacing.m)
        }
        .background(Theme.Color.surface)
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: Activity.self) { ActivityDetailView(activity: $0) }
        .task { await vm.load(slug: slug) }
    }
}

struct ActivityRow: View {
    let activity: Activity

    var icon: String {
        switch activity.kind {
        case .video: return "play.rectangle.fill"
        case .document, .resource: return "doc.fill"
        case .quiz: return "questionmark.circle.fill"
        case .assignment: return "square.and.pencil"
        case .forum: return "bubble.left.and.bubble.right.fill"
        case .url: return "link"
        case .folder: return "folder.fill"
        default: return "book.fill"
        }
    }

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(Theme.Color.primary)
                .frame(width: 28)
            Text(activity.name)
                .foregroundStyle(Theme.Color.navy)
                .lineLimit(2)
            Spacer()
            if activity.completed == true {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)
            }
            Image(systemName: "chevron.right").foregroundStyle(Theme.Color.textLight)
        }
        .padding(.vertical, 8)
    }
}

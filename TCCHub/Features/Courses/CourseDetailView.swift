import SwiftUI

@MainActor
final class CourseDetailViewModel: ObservableObject {
    @Published var detail: CourseDetail?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isEnrolled = false

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
        isEnrolled = true
    }
}

struct CourseDetailView: View {
    let slug: String
    let title: String
    @StateObject private var vm = CourseDetailViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Theme.Spacing.l) {
                cover
                if let d = vm.detail {
                    titleSection(d)
                    metaRow(d)
                    enrollButton
                    curriculumSection(d)
                } else if vm.isLoading {
                    ProgressView().tint(Theme.Color.primary).frame(maxWidth: .infinity).padding(40)
                } else if let err = vm.errorMessage {
                    Text(err).foregroundStyle(Theme.Color.error)
                }
            }
            .padding(Theme.Spacing.m)
        }
        .background(Theme.Color.background)
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: Activity.self) { ActivityDetailView(activity: $0) }
        .task { await vm.load(slug: slug) }
    }

    private var cover: some View {
        ZStack {
            LinearGradient(
                colors: [Theme.Color.navy, Theme.Color.primary],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
            Image("LogoMark")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .opacity(0.85)
        }
        .frame(height: 180)
        .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.card))
    }

    private func titleSection(_ d: CourseDetail) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(d.title)
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(Theme.Color.navy)
            if let s = d.summary, !s.isEmpty {
                Text(s).foregroundStyle(Theme.Color.textMid)
            }
        }
    }

    private func metaRow(_ d: CourseDetail) -> some View {
        HStack(spacing: Theme.Spacing.m) {
            MetaChip(icon: "clock", text: "\(d.durationHours ?? 0)h")
            MetaChip(icon: "list.bullet.rectangle", text: "\(d.sections?.count ?? 0) modules")
            MetaChip(icon: "person.2.fill", text: "30+ learners")
        }
    }

    private var enrollButton: some View {
        PrimaryButton(
            title: vm.isEnrolled ? String(localized: "courseDetail.curriculum") : String(localized: "courseDetail.enroll")
        ) {
            Task { await vm.enroll(slug: slug) }
        }
    }

    private func curriculumSection(_ d: CourseDetail) -> some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.m) {
            Text(L10n.CourseDetail.curriculum)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(Theme.Color.textLight)
                .textCase(.uppercase)
            ForEach(d.sections ?? []) { section in
                VStack(alignment: .leading, spacing: Theme.Spacing.s) {
                    Text(section.title)
                        .font(.system(size: 16, weight: .semibold))
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
                        .fill(Theme.Color.card)
                        .shadow(color: Theme.Color.navy.opacity(0.04), radius: 4, y: 1)
                )
            }
        }
    }
}

private struct MetaChip: View {
    let icon: String
    let text: String
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon).font(.system(size: 11))
            Text(text).font(.system(size: 12, weight: .medium))
        }
        .foregroundStyle(Theme.Color.textMid)
        .padding(.horizontal, 10).padding(.vertical, 6)
        .background(Theme.Color.surfaceAlt)
        .clipShape(Capsule())
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
                    .foregroundStyle(Theme.Color.success)
            }
            Image(systemName: "chevron.right").foregroundStyle(Theme.Color.textLight)
        }
        .padding(.vertical, 8)
    }
}

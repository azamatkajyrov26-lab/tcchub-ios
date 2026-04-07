import SwiftUI

@MainActor
final class CoursesListViewModel: ObservableObject {
    @Published var courses: [Course] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    func load() async {
        isLoading = true; errorMessage = nil
        defer { isLoading = false }
        do {
            // API may return either a paginated envelope or a raw array.
            let data = try await APIClient.shared.sendRaw(.courses)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            if let page = try? decoder.decode(Paginated<Course>.self, from: data) {
                self.courses = page.results
            } else {
                self.courses = (try? decoder.decode([Course].self, from: data)) ?? []
            }
        } catch {
            errorMessage = "Couldn't load courses"
        }
    }
}

struct CoursesListView: View {
    @StateObject private var vm = CoursesListViewModel()
    @State private var query = ""

    private var filtered: [Course] {
        guard !query.isEmpty else { return vm.courses }
        return vm.courses.filter { $0.title.localizedCaseInsensitiveContains(query) }
    }

    var body: some View {
        NavigationStack {
            Group {
                if vm.isLoading && vm.courses.isEmpty {
                    ProgressView().tint(Theme.Color.primary)
                } else if vm.errorMessage != nil, vm.courses.isEmpty {
                    EmptyState(image: "error-offline",
                               title: L10n.Common.offline,
                               subtitle: L10n.Courses.loadError,
                               actionTitle: String(localized: "common.retry")) {
                        Task { await vm.load() }
                    }
                } else if vm.courses.isEmpty {
                    EmptyState(image: "empty-courses",
                               title: L10n.Courses.empty,
                               subtitle: L10n.Courses.emptyHint)
                } else {
                    ScrollView {
                        LazyVStack(spacing: Theme.Spacing.m) {
                            ForEach(filtered) { course in
                                NavigationLink(value: course) {
                                    CourseRow(course: course)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(Theme.Spacing.m)
                    }
                    .refreshable { await vm.load() }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Theme.Color.surface)
            .navigationTitle(L10n.Courses.title)
            .searchable(text: $query, prompt: Text("courses.searchPlaceholder"))
            .navigationDestination(for: Course.self) { CourseDetailView(slug: $0.slug, title: $0.title) }
            .task { if vm.courses.isEmpty { await vm.load() } }
        }
    }
}

struct CourseRow: View {
    let course: Course

    var body: some View {
        HStack(alignment: .top, spacing: Theme.Spacing.m) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Theme.Color.primary.opacity(0.15))
                .frame(width: 72, height: 72)
                .overlay(
                    Image(systemName: "book.closed.fill")
                        .font(.system(size: 26))
                        .foregroundStyle(Theme.Color.primary)
                )
            VStack(alignment: .leading, spacing: 4) {
                Text(course.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Theme.Color.navy)
                    .lineLimit(2)
                if let summary = course.summary, !summary.isEmpty {
                    Text(summary)
                        .font(.system(size: 13))
                        .foregroundStyle(Theme.Color.textMid)
                        .lineLimit(2)
                }
                if let p = course.progressPercent {
                    ProgressView(value: min(max(p, 0), 100), total: 100)
                        .tint(Theme.Color.primary)
                        .padding(.top, 4)
                }
            }
            Spacer(minLength: 0)
        }
        .padding(Theme.Spacing.m)
        .background(
            RoundedRectangle(cornerRadius: Theme.Radius.card)
                .fill(Color.white)
                .shadow(color: Theme.Color.navy.opacity(0.05), radius: 6, y: 2)
        )
    }
}

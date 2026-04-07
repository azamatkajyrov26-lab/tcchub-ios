import SwiftUI
import Shimmer

struct CourseSkeletonRow: View {
    var body: some View {
        HStack(alignment: .top, spacing: Theme.Spacing.m) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Theme.Color.surfaceAlt)
                .frame(width: 72, height: 72)
            VStack(alignment: .leading, spacing: 8) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Theme.Color.surfaceAlt)
                    .frame(height: 14)
                    .frame(maxWidth: .infinity)
                RoundedRectangle(cornerRadius: 4)
                    .fill(Theme.Color.surfaceAlt)
                    .frame(height: 12)
                    .frame(maxWidth: 220)
                RoundedRectangle(cornerRadius: 4)
                    .fill(Theme.Color.surfaceAlt)
                    .frame(height: 10)
                    .frame(maxWidth: 140)
            }
            Spacer(minLength: 0)
        }
        .padding(Theme.Spacing.m)
        .background(
            RoundedRectangle(cornerRadius: Theme.Radius.card)
                .fill(Theme.Color.card)
        )
        .shimmering()
    }
}

struct CourseSkeletonList: View {
    var body: some View {
        VStack(spacing: Theme.Spacing.m) {
            ForEach(0..<5, id: \.self) { _ in CourseSkeletonRow() }
        }
        .padding(Theme.Spacing.m)
    }
}

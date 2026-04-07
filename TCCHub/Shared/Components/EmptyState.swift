import SwiftUI

struct EmptyState: View {
    let image: String
    let title: LocalizedStringKey
    var subtitle: LocalizedStringKey? = nil
    var actionTitle: String? = nil
    var action: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: Theme.Spacing.m) {
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 200, maxHeight: 180)
                .padding(.bottom, 8)
            Text(title)
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(Theme.Color.navy)
            if let subtitle {
                Text(subtitle)
                    .font(.system(size: 14))
                    .foregroundStyle(Theme.Color.textMid)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Theme.Spacing.l)
            }
            if let actionTitle, let action {
                Button(actionTitle, action: action)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(Theme.Color.primary)
                    .padding(.top, 4)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(Theme.Spacing.l)
    }
}

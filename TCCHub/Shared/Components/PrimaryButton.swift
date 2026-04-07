import SwiftUI

struct PrimaryButton: View {
    let title: String
    var isLoading: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                if isLoading {
                    ProgressView().tint(.white)
                } else {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white)
                }
            }
            .frame(maxWidth: .infinity, minHeight: 52)
            .background(Theme.Color.primary)
            .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.pill))
        }
        .disabled(isLoading)
    }
}

struct RoundedField: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 20)
            .frame(height: 52)
            .background(Theme.Color.surfaceAlt)
            .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.pill))
            .overlay(
                RoundedRectangle(cornerRadius: Theme.Radius.pill)
                    .stroke(Theme.Color.divider, lineWidth: 1)
            )
    }
}

extension View {
    func roundedField() -> some View { modifier(RoundedField()) }
}

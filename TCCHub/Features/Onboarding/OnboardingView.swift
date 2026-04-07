import SwiftUI

struct OnboardingPage: Identifiable {
    let id = UUID()
    let image: String
    let title: LocalizedStringKey
    let body: LocalizedStringKey
}

struct OnboardingView: View {
    @AppStorage("hasCompletedOnboarding") private var done = false
    @State private var index = 0

    private let pages: [OnboardingPage] = [
        .init(image: "onboarding-1", title: L10n.Onboarding.title1, body: L10n.Onboarding.body1),
        .init(image: "onboarding-2", title: L10n.Onboarding.title2, body: L10n.Onboarding.body2),
        .init(image: "onboarding-3", title: L10n.Onboarding.title3, body: L10n.Onboarding.body3),
    ]

    var body: some View {
        ZStack {
            Theme.Color.background.ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    if index < pages.count - 1 {
                        Button(L10n.Onboarding.skip) { done = true }
                            .foregroundStyle(Theme.Color.textMid)
                    }
                }
                .padding(Theme.Spacing.l)

                TabView(selection: $index) {
                    ForEach(Array(pages.enumerated()), id: \.offset) { i, page in
                        VStack(spacing: Theme.Spacing.l) {
                            Image(page.image)
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 280)
                                .padding(.horizontal, Theme.Spacing.xl)
                            Text(page.title)
                                .font(.system(size: 26, weight: .bold))
                                .foregroundStyle(Theme.Color.navy)
                                .multilineTextAlignment(.center)
                            Text(page.body)
                                .font(.system(size: 16))
                                .foregroundStyle(Theme.Color.textMid)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, Theme.Spacing.xl)
                        }
                        .tag(i)
                        .padding(.bottom, 40)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .indexViewStyle(.page(backgroundDisplayMode: .always))

                VStack(spacing: 12) {
                    PrimaryButton(
                        title: index == pages.count - 1
                            ? String(localized: "onboarding.getStarted")
                            : String(localized: "onboarding.next")
                    ) {
                        if index == pages.count - 1 {
                            done = true
                        } else {
                            withAnimation { index += 1 }
                        }
                    }
                }
                .padding(.horizontal, Theme.Spacing.l)
                .padding(.bottom, Theme.Spacing.l)
            }
        }
    }
}

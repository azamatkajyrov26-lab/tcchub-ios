import SwiftUI

struct LoginView: View {
    @EnvironmentObject var auth: AuthService
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        ZStack {
            Theme.Color.background.ignoresSafeArea()
            ScrollView {
                VStack(spacing: Theme.Spacing.l) {
                    Spacer(minLength: 40)
                    VStack(spacing: 12) {
                        Image("LogoFull")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 64)
                        Text(L10n.Auth.loginTitle)
                            .font(.system(size: 26, weight: .bold))
                            .foregroundStyle(Theme.Color.navy)
                        Text(L10n.Auth.loginSubtitle)
                            .font(.system(size: 15))
                            .foregroundStyle(Theme.Color.textMid)
                    }
                    .padding(.bottom, 16)

                    VStack(spacing: 14) {
                        TextField(String(localized: "auth.email"), text: $email)
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .roundedField()

                        SecureField(String(localized: "auth.password"), text: $password)
                            .textContentType(.password)
                            .roundedField()
                    }

                    if let err = auth.errorMessage {
                        Text(err)
                            .font(.footnote)
                            .foregroundStyle(Theme.Color.error)
                    }

                    PrimaryButton(title: String(localized: "auth.signIn"),
                                  isLoading: auth.isLoading) {
                        Task { await auth.login(email: email, password: password) }
                    }

                    NavigationLink(L10n.Auth.forgot) { PasswordResetView() }
                        .font(.footnote)
                        .foregroundStyle(Theme.Color.navyLight)

                    HStack(spacing: 4) {
                        Text(L10n.Auth.noAccount).foregroundStyle(Theme.Color.textMid)
                        NavigationLink(L10n.Auth.signUp) { SignUpView() }
                            .foregroundStyle(Theme.Color.primary)
                    }
                    .font(.footnote)
                    .padding(.top, 8)
                }
                .padding(Theme.Spacing.l)
            }
        }
    }
}

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var auth: AuthService
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        ZStack {
            Theme.Color.surface.ignoresSafeArea()
            ScrollView {
                VStack(spacing: Theme.Spacing.l) {
                    Spacer(minLength: 40)
                    VStack(spacing: 12) {
                        Image("LogoFull")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 64)
                        Text("Welcome back")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundStyle(Theme.Color.navy)
                        Text("Sign in to continue learning")
                            .font(.system(size: 15))
                            .foregroundStyle(Theme.Color.textMid)
                    }
                    .padding(.bottom, 16)

                    VStack(spacing: 14) {
                        TextField("Email", text: $email)
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .roundedField()

                        SecureField("Password", text: $password)
                            .textContentType(.password)
                            .roundedField()
                    }

                    if let err = auth.errorMessage {
                        Text(err)
                            .font(.footnote)
                            .foregroundStyle(.red)
                    }

                    PrimaryButton(title: "Sign In", isLoading: auth.isLoading) {
                        Task { await auth.login(email: email, password: password) }
                    }

                    NavigationLink("Forgot password?") { PasswordResetView() }
                        .font(.footnote)
                        .foregroundStyle(Theme.Color.navyLight)

                    HStack(spacing: 4) {
                        Text("New here?").foregroundStyle(Theme.Color.textMid)
                        NavigationLink("Create account") { SignUpView() }
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

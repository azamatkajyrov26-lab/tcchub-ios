import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var auth: AuthService
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        ScrollView {
            VStack(spacing: Theme.Spacing.l) {
                Text("Create account")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(Theme.Color.navy)
                    .frame(maxWidth: .infinity, alignment: .leading)

                VStack(spacing: 14) {
                    TextField("First name", text: $firstName).roundedField()
                    TextField("Last name", text: $lastName).roundedField()
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .roundedField()
                    SecureField("Password", text: $password).roundedField()
                }

                if let err = auth.errorMessage {
                    Text(err).font(.footnote).foregroundStyle(.red)
                }

                PrimaryButton(title: "Sign Up", isLoading: auth.isLoading) {
                    Task {
                        await auth.register(
                            email: email, password: password,
                            firstName: firstName, lastName: lastName
                        )
                    }
                }
            }
            .padding(Theme.Spacing.l)
        }
        .background(Theme.Color.surface)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct PasswordResetView: View {
    @State private var email = ""
    var body: some View {
        VStack(spacing: Theme.Spacing.l) {
            Text("Reset password")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(Theme.Color.navy)
            TextField("Email", text: $email)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .roundedField()
            PrimaryButton(title: "Send reset link") { /* TODO */ }
            Spacer()
        }
        .padding(Theme.Spacing.l)
        .background(Theme.Color.surface)
    }
}

import Foundation

@MainActor
final class AuthService: ObservableObject, TokenProviding {
    @Published private(set) var currentUser: User?
    @Published private(set) var isAuthenticated: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    init() {
        Task { await APIClient.shared.setTokenProvider(self) }
    }

    func restoreSession() async {
        guard KeychainStore.get(.accessToken) != nil else { return }
        do {
            let user = try await APIClient.shared.send(.me, as: User.self)
            self.currentUser = user
            self.isAuthenticated = true
        } catch {
            KeychainStore.clearAll()
            self.isAuthenticated = false
        }
    }

    func login(email: String, password: String) async {
        isLoading = true; errorMessage = nil
        defer { isLoading = false }
        do {
            let resp = try await APIClient.shared.send(
                .login(email: email, password: password),
                as: AuthResponse.self
            )
            persist(resp)
        } catch {
            errorMessage = Self.describe(error)
        }
    }

    func register(email: String, password: String, firstName: String, lastName: String) async {
        isLoading = true; errorMessage = nil
        defer { isLoading = false }
        do {
            let resp = try await APIClient.shared.send(
                .register(email: email, password: password, firstName: firstName, lastName: lastName),
                as: AuthResponse.self
            )
            persist(resp)
        } catch {
            errorMessage = Self.describe(error)
        }
    }

    func logout() {
        KeychainStore.clearAll()
        currentUser = nil
        isAuthenticated = false
    }

    private func persist(_ resp: AuthResponse) {
        KeychainStore.set(resp.tokens.access, for: .accessToken)
        KeychainStore.set(resp.tokens.refresh, for: .refreshToken)
        currentUser = resp.user
        isAuthenticated = true
    }

    // MARK: - TokenProviding
    nonisolated func accessToken() async -> String? {
        KeychainStore.get(.accessToken)
    }

    nonisolated func refreshAccessToken() async throws -> Bool {
        guard let refresh = KeychainStore.get(.refreshToken) else { return false }
        do {
            let data = try await APIClient.shared.sendRaw(.refresh(token: refresh), retryOn401: false)
            let decoded = try JSONDecoder().decode(RefreshResponse.self, from: data)
            KeychainStore.set(decoded.access, for: .accessToken)
            if let newRefresh = decoded.refresh {
                KeychainStore.set(newRefresh, for: .refreshToken)
            }
            return true
        } catch {
            await MainActor.run { self.logout() }
            return false
        }
    }

    private static func describe(_ error: Error) -> String {
        switch error {
        case APIError.unauthorized: return "Invalid credentials"
        case APIError.http(let code, _): return "Request failed (\(code))"
        case APIError.transport: return "Network error. Check your connection."
        default: return "Something went wrong"
        }
    }
}

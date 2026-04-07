import Foundation

struct User: Codable, Identifiable, Equatable {
    let id: Int
    let email: String
    let firstName: String?
    let lastName: String?
    let role: String?
    let avatarUrl: String?
    let languageCode: String?

    var fullName: String {
        [firstName, lastName].compactMap { $0 }.joined(separator: " ")
    }
}

struct AuthTokens: Codable {
    let access: String
    let refresh: String
}

struct AuthResponse: Codable {
    let tokens: AuthTokens
    let user: User
}

struct RefreshResponse: Codable {
    let access: String
    let refresh: String?
}

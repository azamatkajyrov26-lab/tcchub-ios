import Foundation

enum HTTPMethod: String {
    case get = "GET", post = "POST", patch = "PATCH", put = "PUT", delete = "DELETE"
}

struct Endpoint {
    var path: String
    var method: HTTPMethod = .get
    var query: [URLQueryItem] = []
    var body: Data? = nil
    var requiresAuth: Bool = true
    var contentType: String = "application/json"
}

extension Endpoint {
    static func login(email: String, password: String) -> Endpoint {
        let body = try? JSONEncoder().encode(["email": email, "password": password])
        return Endpoint(path: "/auth/login/", method: .post, body: body, requiresAuth: false)
    }

    static func register(email: String, password: String, firstName: String, lastName: String) -> Endpoint {
        let payload = [
            "email": email, "password": password,
            "first_name": firstName, "last_name": lastName
        ]
        let body = try? JSONEncoder().encode(payload)
        return Endpoint(path: "/auth/register/", method: .post, body: body, requiresAuth: false)
    }

    static func refresh(token: String) -> Endpoint {
        let body = try? JSONEncoder().encode(["refresh": token])
        return Endpoint(path: "/auth/token/refresh/", method: .post, body: body, requiresAuth: false)
    }

    static let me = Endpoint(path: "/accounts/users/me/")
    static let courses = Endpoint(path: "/courses/")
    static func courseDetail(slug: String) -> Endpoint {
        Endpoint(path: "/courses/\(slug)/")
    }
    static func enroll(slug: String) -> Endpoint {
        Endpoint(path: "/courses/\(slug)/enroll", method: .post)
    }
    static func activity(id: Int) -> Endpoint {
        Endpoint(path: "/content/activities/\(id)/")
    }
    static func completeActivity(id: Int) -> Endpoint {
        Endpoint(path: "/content/activities/\(id)/complete/", method: .post)
    }
}

import Foundation

enum APIError: Error {
    case invalidURL
    case unauthorized
    case http(Int, Data)
    case decoding(Error)
    case transport(Error)
}

actor APIClient {
    static let shared = APIClient()

    #if targetEnvironment(simulator)
    private let baseURL = URL(string: "http://localhost:8000/api/v1")!
    #else
    private let baseURL = URL(string: "https://tcchub.kz/api/v1")!
    #endif
    private let session: URLSession
    private let decoder: JSONDecoder

    weak var tokenProvider: TokenProviding?

    init(session: URLSession = .shared) {
        self.session = session
        let d = JSONDecoder()
        d.keyDecodingStrategy = .convertFromSnakeCase
        d.dateDecodingStrategy = .iso8601
        self.decoder = d
    }

    func setTokenProvider(_ provider: TokenProviding) {
        self.tokenProvider = provider
    }

    func send<T: Decodable>(_ endpoint: Endpoint, as type: T.Type) async throws -> T {
        let data = try await sendRaw(endpoint)
        do { return try decoder.decode(T.self, from: data) }
        catch { throw APIError.decoding(error) }
    }

    func sendRaw(_ endpoint: Endpoint, retryOn401: Bool = true) async throws -> Data {
        var comps = URLComponents(url: baseURL.appendingPathComponent(endpoint.path), resolvingAgainstBaseURL: false)
        if !endpoint.query.isEmpty { comps?.queryItems = endpoint.query }
        guard let url = comps?.url else { throw APIError.invalidURL }

        var req = URLRequest(url: url)
        req.httpMethod = endpoint.method.rawValue
        req.setValue(endpoint.contentType, forHTTPHeaderField: "Content-Type")
        req.setValue("application/json", forHTTPHeaderField: "Accept")
        req.httpBody = endpoint.body

        if endpoint.requiresAuth, let token = await tokenProvider?.accessToken() {
            req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        let (data, response): (Data, URLResponse)
        do { (data, response) = try await session.data(for: req) }
        catch { throw APIError.transport(error) }

        guard let http = response as? HTTPURLResponse else { throw APIError.http(-1, data) }

        if http.statusCode == 401, retryOn401, endpoint.requiresAuth {
            if let refreshed = try? await tokenProvider?.refreshAccessToken(), refreshed {
                return try await sendRaw(endpoint, retryOn401: false)
            }
            throw APIError.unauthorized
        }

        guard (200..<300).contains(http.statusCode) else {
            throw APIError.http(http.statusCode, data)
        }
        return data
    }
}

protocol TokenProviding: AnyObject {
    func accessToken() async -> String?
    func refreshAccessToken() async throws -> Bool
}

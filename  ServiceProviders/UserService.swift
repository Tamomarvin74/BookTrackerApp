import Foundation

struct UserService {
    private var session: URLSession {
        URLSession(configuration: .default)
    }

    func fetchAllUsers() async throws -> [AppUser] {
        let url = URL(string: "https://dummyjson.com/users")!
        let (data, _) = try await session.data(from: url)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let decoded = try decoder.decode(UserList.self, from: data)
        return decoded.users
    }

    func fetchUser(by id: Int) async throws -> AppUser {
        let url = URL(string: "https://dummyjson.com/users/\(id)")!
        let (data, _) = try await session.data(from: url)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(AppUser.self, from: data)
    }

    func fetchCurrentUser() async throws -> AppUser {
        let url = URL(string: "https://dummyjson.com/users/me")!
        let (data, _) = try await session.data(from: url)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(AppUser.self, from: data)
    }

    func login(username: String, password: String) async throws -> LoginResponse {
        guard let url = URL(string: "https://dummyjson.com/auth/login") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = LoginCredentials(username: username, password: password, expiresInMins: nil)
        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(LoginResponse.self, from: data)
    }
}


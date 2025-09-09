import Foundation

 
struct SimpleUser: Codable {
    let id: Int
    let username: String
    let password: String?
}

private struct SimpleUserListResponse: Codable {
    let users: [SimpleUser]
}

struct LoginRequest: Codable {
    let username: String
    let password: String
}

struct AuthenticatedUser: Codable {
    let id: Int
    let username: String
    let email: String?
    let firstName: String?
    let lastName: String?
    let gender: String?
    let image: String?
    let token: String?
}

 

 
struct UserService {
    
     private var session: URLSession {
        URLSession(configuration: .default)
    }
    
    func fetchAllSimpleUsers() async throws -> [SimpleUser] {
        let url = URL(string: "https://dummyjson.com/users")!
        let (data, _) = try await session.data(from: url)
        let decoded = try JSONDecoder().decode(SimpleUserListResponse.self, from: data)
        return decoded.users
    }

    func fetchUser(by id: Int) async throws -> User {
        let url = URL(string: "https://dummyjson.com/users/\(id)")!
        let (data, _) = try await session.data(from: url)
        return try JSONDecoder().decode(User.self, from: data)
    }

    func login(username: String, password: String) async throws -> AuthenticatedUser {
        guard let url = URL(string: "https://dummyjson.com/user/login") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = LoginRequest(username: username, password: password)
        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        let authenticatedUser = try JSONDecoder().decode(AuthenticatedUser.self, from: data)
        return authenticatedUser
    }
}


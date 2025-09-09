 import Foundation

 struct SimpleUser: Codable {
    let id: Int
    let username: String
    let password: String
}

private struct SimpleUserListResponse: Codable {
    let users: [SimpleUser]
}

struct UserService {
     func fetchAllSimpleUsers() async throws -> [SimpleUser] {
        let url = URL(string: "https://dummyjson.com/users")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoded = try JSONDecoder().decode(SimpleUserListResponse.self, from: data)
        return decoded.users
    }

     func fetchUser(by id: Int) async throws -> User {
        let url = URL(string: "https://dummyjson.com/users/\(id)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(User.self, from: data)
    }
}


import Foundation

final class AuthService {
     func fetchUser(by id: Int) async throws -> User {
        guard let url = URL(string: "https://dummyjson.com/users/\(id)") else {
            throw URLError(.badURL)
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let decodedUser = try JSONDecoder().decode(User.self, from: data)
        return decodedUser
    }
}


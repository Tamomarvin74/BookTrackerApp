import Foundation

@MainActor
final class AuthManager: ObservableObject {
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var currentUser: AuthenticatedUser?

    private let userService = UserService()
    
     private var localUsers: [LocalUser] = []

    func login(username: String, password: String) async {
        isLoading = true
        errorMessage = nil

         if let localUser = localUsers.first(where: { $0.username == username && $0.password == password }) {
            self.currentUser = localUser.toAuthenticatedUser()
            self.isAuthenticated = true
            isLoading = false
            return
        }

         do {
            let user = try await userService.login(username: username, password: password)
            self.currentUser = user
            self.isAuthenticated = true
        } catch {
            self.errorMessage = "Login failed: \(error.localizedDescription)"
            self.isAuthenticated = false
        }

        isLoading = false
    }

    func register(username: String, email: String, password: String) {
        let newUser = LocalUser(
            id: Int.random(in: 1000...9999),
            username: username,
            email: email,
            password: password
        )
        localUsers.append(newUser)
        self.currentUser = newUser.toAuthenticatedUser()
        self.isAuthenticated = true
    }

    func signOut() {
        currentUser = nil
        isAuthenticated = false
    }
}

 struct LocalUser {
    let id: Int
    let username: String
    let email: String
    let password: String
    
    func toAuthenticatedUser() -> AuthenticatedUser {
        AuthenticatedUser(
            id: id,
            username: username,
            email: email,
            firstName: nil,
            lastName: nil,
            gender: nil,
            image: nil,
            token: nil
        )
    }
}


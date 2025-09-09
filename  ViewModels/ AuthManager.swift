import Foundation

@MainActor
final class AuthManager: ObservableObject {
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var currentUser: AuthenticatedUser?

    private let userService = UserService()

    func login(username: String, password: String) async {
        isLoading = true
        errorMessage = nil

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

    func signOut() {
        currentUser = nil
        isAuthenticated = false
    }
}


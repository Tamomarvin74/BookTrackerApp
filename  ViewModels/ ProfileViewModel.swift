import Foundation

@MainActor
class ProfileViewModel: ObservableObject {
    @Published var user: User?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let userService = UserService()

    func fetchUser(by id: Int) async {
        self.isLoading = true
        self.errorMessage = nil
        do {
            self.user = try await userService.fetchUser(by: id)
        } catch {
            self.errorMessage = "Failed to load user: \(error.localizedDescription)"
        }
        self.isLoading = false
    }
}


import Foundation

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var user: AppUser?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let userId: Int
    private let service = UserService()
    
    init(userId: Int) {
        self.userId = userId
    }
    
    func fetchUserProfile() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedUser = try await service.fetchUser(by: userId)
            self.user = fetchedUser
        } catch {
            self.errorMessage = "Failed to fetch current user. \(error.localizedDescription)"
            print(error)
        }
        
        isLoading = false
    }
}


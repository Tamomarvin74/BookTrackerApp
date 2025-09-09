//
//   ProfileViewModel.swift
//  BookTrackerApp
//
//  Created by Tamo Marvin Achiri   on 9/8/25.
//

  import Foundation

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var user: User?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let userService = UserService()
    private let userId: Int

    init(userId: Int) {
        self.userId = userId
    }

    func fetchUserProfile() async {
        isLoading = true
        errorMessage = nil
        do {
            self.user = try await userService.fetchUser(by: userId)
        } catch {
            errorMessage = "Failed to fetch user: \(error.localizedDescription)"
            print("❌ ProfileViewModel.fetchUserProfile error:", error)
        }
        isLoading = false
    }
}

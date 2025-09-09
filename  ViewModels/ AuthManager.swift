// ViewModels/AuthManager.swift
import Foundation

@MainActor
final class AuthManager: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var currentUser: User?

    private let userService = UserService()
    private let userDefaultsKey = "loggedInUserId"

    init() {
        Task {
            await restoreSession()
        }
    }

     func login(username: String, password: String) async {
        isLoading = true
        errorMessage = nil

        do {
            let simpleUsers = try await userService.fetchAllSimpleUsers()
            if let matched = simpleUsers.first(where: { $0.username == username && $0.password == password }) {
 
                let fullUser = try await userService.fetchUser(by: matched.id)
                self.currentUser = fullUser
                self.isAuthenticated = true

                 UserDefaults.standard.set(matched.id, forKey: userDefaultsKey)
            } else {
                self.errorMessage = "Invalid username or password."
                self.isAuthenticated = false
            }
        } catch {
            self.errorMessage = "Failed to log in: \(error.localizedDescription)"
            self.isAuthenticated = false
        }

        isLoading = false
    }

     func restoreSession() async {
        let savedId = UserDefaults.standard.integer(forKey: userDefaultsKey)
        if savedId > 0 {
            do {
                let fullUser = try await userService.fetchUser(by: savedId)
                self.currentUser = fullUser
                self.isAuthenticated = true
            } catch {
                print("⚠️ Failed to restore session: \(error)")
                self.isAuthenticated = false
            }
        }
    }

     func signOut() {
        currentUser = nil
        isAuthenticated = false
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
    }
}


    import SwiftUI

    struct ContentView: View {
        @StateObject private var authManager = AuthManager()

        var body: some View {
            if authManager.isAuthenticated {
                PostListView(postViewModel: PostViewModel(authManager: authManager))
                    .environmentObject(authManager)
            } else {
                LoginView()
                    .environmentObject(authManager)
            }
        }
    }


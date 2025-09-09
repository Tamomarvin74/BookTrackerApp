import Foundation

@MainActor
class PostViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var currentUser: User?

    private let postService = PostService()
    private let authManager: AuthManager

    init(authManager: AuthManager) {
        self.authManager = authManager
    }

    func fetchPosts() async {
        self.isLoading = true
        self.errorMessage = nil
        do {
            self.posts = try await postService.fetchPosts()
        } catch {
            self.errorMessage = "Failed to fetch posts: \(error.localizedDescription)"
        }
        self.isLoading = false
    }

    func createPost(title: String, body: String) async {
        guard let userId = authManager.currentUser?.id else {
            self.errorMessage = "User not authenticated."
            return
        }

        do {
            let newPost = try await postService.createPost(title: title, body: body, userId: userId)
            self.posts.insert(newPost, at: 0) // Insert new post at the top
        } catch {
            self.errorMessage = "Failed to create post: \(error.localizedDescription)"
        }
    }

    func fetchCurrentUser() {
        self.currentUser = authManager.currentUser // ✅ No parentheses
    }
}

 
 

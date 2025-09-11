import Foundation
import FirebaseAuth

@MainActor
class PostViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var currentUser: AppUser?
    
    private let postService = PostService()
    private let userService = UserService()
    private let authManager: AuthManager
    
    init(authManager: AuthManager) {
        self.authManager = authManager
        Task { await self.fetchCurrentUser() }
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
        guard let firebaseUid = authManager.user?.uid else {
            self.errorMessage = "User not authenticated."
            return
        }
        
        let userIdInt: Int
        if let numeric = Int(firebaseUid) {
            userIdInt = numeric
        } else {
            let hashed = abs(firebaseUid.hashValue)
            userIdInt = hashed % 1_000_000_000
        }
        
        do {
            let newPost = try await postService.createPost(title: title, body: body, userId: userIdInt)
            self.posts.insert(newPost, at: 0)
        } catch {
            self.errorMessage = "Failed to create post: \(error.localizedDescription)"
        }
    }
    
    func fetchCurrentUser() async {
        guard let firebaseUser = authManager.user else {
            self.errorMessage = "No Firebase user logged in."
            return
        }
        
   
        
        
        
    }
}

import Foundation

@MainActor
class CommentsViewModel: ObservableObject {
    @Published var comments: [Comment] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let postService = PostService()

    func fetchComments(for postId: Int) async {
        self.isLoading = true
        self.errorMessage = nil
        do {
            self.comments = try await postService.fetchComments(forPostId: postId)
        } catch {
            self.errorMessage = "Failed to fetch comments: \(error.localizedDescription)"
        }
        self.isLoading = false
    }
}

 

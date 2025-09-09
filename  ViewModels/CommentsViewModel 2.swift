//
//  CommentsViewModel 2.swift
//  BookTrackerApp
//
//  Created by Tamo Marvin Achiri   on 9/7/25.
//


import Foundation

@MainActor
class CommentsViewModel: ObservableObject {
    @Published var comments: [Comment] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    func fetchComments(for postId: Int) async {
        isLoading = true
        errorMessage = nil
        
        // The API returns all comments, we need to filter them by postId.
        guard let url = URL(string: "https://dummyjson.com/comments") else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedResponse = try JSONDecoder().decode(CommentList.self, from: data)
            
            // Filter the comments to only those for the current post.
            self.comments = decodedResponse.comments.filter { $0.postId == postId }
        } catch {
            errorMessage = "Failed to fetch comments: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
}
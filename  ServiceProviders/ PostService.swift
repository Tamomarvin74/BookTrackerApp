import Foundation

final class PostService {
    func fetchPosts() async throws -> [Post] {
        guard let url = URL(string: "https://dummyjson.com/posts") else {
            throw URLError(.badURL)
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let postList = try JSONDecoder().decode(PostList.self, from: data)

        var postsWithImages = postList.posts
        for i in postsWithImages.indices {
            let dummyImageUrl = "https://picsum.photos/600/400?random=\(postsWithImages[i].id)"
            postsWithImages[i].image = dummyImageUrl
        }
        return postsWithImages
    }

    func fetchComments(forPostId postId: Int) async throws -> [Comment] {
        guard let url = URL(string: "https://dummyjson.com/posts/\(postId)/comments") else {
            throw URLError(.badURL)
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let commentList = try JSONDecoder().decode(CommentList.self, from: data)
        return commentList.comments
    }

    func createPost(title: String, body: String, userId: Int) async throws -> Post {
        guard let url = URL(string: "https://dummyjson.com/posts/add") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let newPost = NewPost(title: title, body: body, userId: userId)
        request.httpBody = try JSONEncoder().encode(newPost)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

         if let createdPost = try? JSONDecoder().decode(Post.self, from: data) {
            var postWithImage = createdPost
            if postWithImage.image == nil {
                postWithImage.image = "https://picsum.photos/600/400?random=\(postWithImage.id)"
            }
            return postWithImage
        } else {
             let fallbackId = Int(Date().timeIntervalSince1970)
            let fallbackPost = Post(
                id: fallbackId,
                title: title,
                body: body,
                userId: userId,
                tags: [],
                reactions: Reactions(likes: 0, dislikes: 0),
                image: "https://picsum.photos/600/400?random=\(fallbackId)"
            )
            return fallbackPost
        }
    }
}


    import Foundation

     struct User: Identifiable, Codable {
        let id: Int
        let username: String
        let email: String
        let firstName: String
        let lastName: String
        let gender: String
        let image: String
        var accessToken: String?
        var refreshToken: String?
        
        enum CodingKeys: String, CodingKey {
            case id, username, email, firstName, lastName, gender, image, refreshToken
            case accessToken = "token"
        }
    }

    struct UserList: Codable {
        let users: [User]
    }

    struct Reactions: Codable {
        let likes: Int
        let dislikes: Int
    }

    struct Post: Identifiable, Codable {
        let id: Int
        let title: String
        let body: String
        let userId: Int
        let tags: [String]
        let reactions: Reactions
        var image: String?
    }

    struct PostList: Codable {
        let posts: [Post]
        let total: Int
        let skip: Int
        let limit: Int
    }

     
      struct CommentUser: Codable {
        let id: Int
        let username: String
        let fullName: String
        
         var avatarUrl: String {
            "https://i.pravatar.cc/150?u=\(id)"
        }
    }

     struct Comment: Identifiable, Codable {
        let id: Int
        let body: String
        let postId: Int
        let likes: Int
        let user: CommentUser
    }

     struct CommentList: Codable {
        let comments: [Comment]
        let total: Int
        let skip: Int
        let limit: Int
    }

     struct NewPost: Encodable {
        let title: String
        let body: String
        let userId: Int
    }

    enum AuthError: LocalizedError {
        case invalidRequest
        case noData
        case loginFailed
        case invalidCredentials
        case unknownError
        
        var errorDescription: String? {
            switch self {
            case .invalidRequest:
                return "Failed to create login request."
            case .noData:
                return "No data received from the server."
            case .loginFailed:
                return "Login failed. Please try again."
            case .invalidCredentials:
                return "Invalid username or password. Please try again."
            case .unknownError:
                return "An unknown error occurred."
            }
        }
    }

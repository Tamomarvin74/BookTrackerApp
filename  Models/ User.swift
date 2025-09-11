import Foundation

struct LoginCredentials: Codable {
    let username: String
    let password: String
    let expiresInMins: Int?
}

struct LoginResponse: Codable {
    let id: Int
    let username: String
    let email: String
    let firstName: String
    let lastName: String
    let gender: String
    let image: String
    let accessToken: String
    let refreshToken: String

    enum CodingKeys: String, CodingKey {
        case id, username, email, firstName, lastName, gender, image
        case accessToken = "token"
        case refreshToken
    }
}

struct AppUser: Identifiable, Codable {
    let id: Int
    let firstName: String?
    let lastName: String?
    let maidenName: String?
    let age: Int?
    let gender: String?
    let email: String?
    let phone: String?
    let username: String?
    let birthDate: String?
    let image: String?
    let bloodGroup: String?
    let height: Double?
    let weight: Double?
    let eyeColor: String?
    let hair: Hair?
    let ip: String?
    let macAddress: String?
    let university: String?
    let address: Address?
    let bank: Bank?
    let company: Company?
    let ein: String?
    let ssn: String?
    let userAgent: String?
    let crypto: Crypto?
    let role: String?

    var accessToken: String?
    var refreshToken: String?

    enum CodingKeys: String, CodingKey {
        case id, firstName, lastName, maidenName, age, gender, email, phone, username, birthDate, image, bloodGroup, height, weight, eyeColor, hair, ip, macAddress, university, address, bank, company, ein, ssn, userAgent, crypto, role, refreshToken
        case accessToken = "token"
    }
}


 struct UserList: Codable {
    let users: [AppUser]
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
    let views: Int
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

struct Address: Codable {
    let address, city, state, stateCode: String
    let postalCode: String
    let coordinates: Coordinates
    let country: String
}

struct Coordinates: Codable {
    let lat, lng: Double
}

struct Bank: Codable {
    let cardExpire, cardNumber, cardType, currency, iban: String
}

struct Company: Codable {
    let department, name, title: String
    let address: Address
}

struct Crypto: Codable {
    let coin, wallet, network: String
}

struct Hair: Codable {
    let color, type: String
}




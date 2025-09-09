import Foundation
import SwiftData

@Model
class User {
    var email: String
    var passwordHash: String
    
    @Relationship(inverse: \Book.owner)
    var books: [Book] = []
    
    init(email: String, passwordHash: String) {
        self.email = email
        self.passwordHash = passwordHash
    }
}

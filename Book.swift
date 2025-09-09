import Foundation
import SwiftData

@Model
final class Book {
    var title: String
    var author: String
    var details: String?
    var isRead: Bool
    
     var owner: User?

    init(title: String, author: String, details: String? = nil, isRead: Bool = false, owner: User? = nil) {
        self.title = title
        self.author = author
        self.details = details
        self.isRead = isRead
        self.owner = owner
    }
}

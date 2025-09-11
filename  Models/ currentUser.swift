//
//   currentUser.swift
//  BookTrackerApp
//
//  Created by Tamo Marvin Achiri   on 9/11/25.
//

import Foundation

struct SimpleUser: Codable {
    let id: Int
    let username: String?
    let email: String?
    let firstName: String?
    let lastName: String?
    let image: String?
    let token: String?
}

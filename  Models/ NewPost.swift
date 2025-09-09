//
//   NewPost.swift
//  BookTrackerApp
//
//  Created by Tamo Marvin Achiri   on 9/5/25.
//

import Foundation


struct NewPost: Encodable {
    let title: String
    let body: String
    let userId: Int
}

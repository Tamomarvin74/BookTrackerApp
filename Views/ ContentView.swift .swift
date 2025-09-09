//
//   ContentView.swift .swift
//  BookTrackerApp
//
//  Created by Tamo Marvin Achiri   on 9/8/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var authManager = AuthManager()

    var body: some View {
        if authManager.isAuthenticated {
            PostListView(postViewModel: PostViewModel(authManager: authManager))
                .environmentObject(authManager)
        } else {
            LoginView()
                .environmentObject(authManager)
        }
    }
}


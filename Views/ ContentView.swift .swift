//  ContentView.swift
//  BookTrackerApp
//
//  Created by Tamo Marvin Achiri on 9/8/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var authManager = AuthManager()
    
    var body: some View {
        NavigationView {
            if let _ = authManager.user {
                PostListView(
                    postViewModel: PostViewModel(authManager: authManager)
                )
                .environmentObject(authManager)
            } else {
                LoginView()
                    .environmentObject(authManager)
            }
        }
    }
}

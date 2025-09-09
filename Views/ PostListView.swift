import SwiftUI

struct PostListView: View {
    @EnvironmentObject var authManager: AuthManager
    @StateObject private var postViewModel: PostViewModel

    init(postViewModel: PostViewModel) {
        _postViewModel = StateObject(wrappedValue: postViewModel)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                contentView
            }
            .navigationTitle("Posts")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Sign Out") {
                        authManager.signOut()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: CreatePostView(postViewModel: postViewModel)) {
                        Image(systemName: "square.and.pencil")
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: ProfileView(userId: authManager.currentUser?.id ?? 1)) {
                        Image(systemName: "person.crop.circle.fill")
                    }
                }
            }
        }
        .task {
            await postViewModel.fetchPosts()
            postViewModel.fetchCurrentUser()
        }
    }

    @ViewBuilder
    private var contentView: some View {
        if postViewModel.isLoading {
            ProgressView("Loading posts...")
        } else if let errorMessage = postViewModel.errorMessage {
            Text(errorMessage)
                .foregroundColor(.red)
        } else {
            ScrollView {
                LazyVStack(spacing: 15) {
                    ForEach(postViewModel.posts) { post in
                        NavigationLink(destination: PostDetailView(post: post)) {
                            PostRowView(post: post)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.vertical, 10)
            }
            .scrollContentBackground(.hidden)
        }
    }

    private struct PostRowView: View {
        let post: Post

        var body: some View {
            VStack(alignment: .leading, spacing: 10) {
                if let imageUrl = post.image, let url = URL(string: imageUrl) {
                    AsyncImage(url: url) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 150)
                                .clipped()
                                .cornerRadius(8)
                        } else if phase.error != nil {
                            Image(systemName: "photo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 150)
                                .foregroundColor(.gray)
                                .background(Color.secondary.opacity(0.1))
                                .cornerRadius(8)
                        } else {
                            ProgressView()
                                .frame(height: 150)
                                .frame(maxWidth: .infinity)
                                .background(Color.secondary.opacity(0.1))
                                .cornerRadius(8)
                        }
                    }
                }

                Text(post.title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                    .padding(.horizontal, 10)

                Text(post.body)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
                    .padding(.horizontal, 10)

                HStack {
                    Image(systemName: "hand.thumbsup.fill")
                    Text("\(post.reactions.likes)")
                    Spacer()
                }
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.horizontal, 10)
                .padding(.bottom, 5)
            }
            .background(Color.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
            .padding(.horizontal, 15)
        }
    }
}


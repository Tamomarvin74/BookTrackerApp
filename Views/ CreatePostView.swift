import SwiftUI

struct CreatePostView: View {
    @Environment(\.dismiss) var dismiss
    @State private var postTitle: String = ""
    @State private var postBody: String = ""

    @ObservedObject var postViewModel: PostViewModel

    var body: some View {
        VStack(spacing: 20) {
            if let user = postViewModel.currentUser {
                HStack {
                    AsyncImage(url: URL(string: user.image ?? "")) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                        } else {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.gray)
                        }
                    }
                    VStack(alignment: .leading) {
                        Text("\((user.firstName ?? "") + " " + (user.lastName ?? ""))")
                            .font(.headline)
                        Text(user.email ?? "No email")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                }
                .padding(.horizontal)
            }

            TextField("Post Title", text: $postTitle)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)

            TextEditor(text: $postBody)
                .frame(height: 200)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)

            Button("Publish Post") {
                 let newId = (postViewModel.posts.first?.id ?? 0) + 1
                let newPost = Post(
                    id: newId,
                    title: postTitle,
                    body: postBody,
                    userId: 1, 
                    tags: [],
                    reactions: Reactions(likes: 0, dislikes: 0),
                    views: 0,
                    image: "https://picsum.photos/600/400?random=\(newId)"
                )

                postViewModel.posts.insert(newPost, at: 0)
                dismiss()
            }
            .font(.headline)
            .padding()
            .frame(maxWidth: .infinity)
            .background(postTitle.isEmpty || postBody.isEmpty ? Color.gray : Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .disabled(postTitle.isEmpty || postBody.isEmpty)

            Spacer()
        }
        .padding()
        .navigationTitle("Create New Post")
        .navigationBarTitleDisplayMode(.inline)
    }
}


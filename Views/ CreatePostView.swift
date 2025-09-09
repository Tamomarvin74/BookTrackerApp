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
                    AsyncImage(url: URL(string: user.image)) { phase in
                        if let image = phase.image {
                            image.resizable()
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
                        Text("\(user.firstName) \(user.lastName)")
                            .font(.headline)
                        Text(user.email)
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
                Task {
                    await postViewModel.createPost(title: postTitle, body: postBody)
                    dismiss()
                }
            }
            .font(.headline)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .disabled(postTitle.isEmpty || postBody.isEmpty)

            Spacer()
        }
        .padding()
        .navigationTitle("Create New Post")
        .navigationBarTitleDisplayMode(.inline)
      
        .task {
            postViewModel.fetchCurrentUser()
        }
    }
}


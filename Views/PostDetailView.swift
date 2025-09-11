import SwiftUI

struct PostDetailView: View {
    let post: Post
    
    @State private var selectedImageURL: String = ""
    @StateObject private var commentsViewModel = CommentsViewModel()
    
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                     let imageUrlString = selectedImageURL.isEmpty ? (post.image ?? "") : selectedImageURL
                    
                    if let url = URL(string: imageUrlString) {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 250)
                                .clipped()
                                .cornerRadius(10)
                                .padding(.horizontal)
                        } placeholder: {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 250)
                                .overlay(ProgressView())
                                .cornerRadius(10)
                                .padding(.horizontal)
                        }
                    }
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            if let mainImageUrl = post.image {
                                ThumbnailView(
                                    imageURL: mainImageUrl,
                                    isSelected: selectedImageURL.isEmpty || selectedImageURL == mainImageUrl
                                ) {
                                    selectedImageURL = mainImageUrl
                                }
                            }
                            
                            ForEach(post.tags, id: \.self) { tag in
                                let randomImageUrl = "https://picsum.photos/100/100?random=\(post.id)\(tag)"
                                ThumbnailView(
                                    imageURL: randomImageUrl,
                                    isSelected: selectedImageURL == randomImageUrl
                                ) {
                                    selectedImageURL = randomImageUrl
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text(post.title)
                            .font(.system(size: 36, weight: .bold, design: .serif))
                            .foregroundColor(.black)
                        Divider()
                            .background(.black)
                        
                        Text(post.body)
                            .font(.body)
                            .foregroundColor(.black.opacity(0.8))
                        
                            .lineSpacing(5)
                        
                        HStack {
                            ForEach(post.tags, id: \.self) { tag in
                                Text("#\(tag)")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .clipShape(Capsule())
                            }
                        }
                        .padding(.top, 10)
                    }
                    .padding(20)
                    
                    .background(Color.white)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            Image(systemName: "hand.thumbsup.fill")
                                .foregroundColor(.black)
                            Text("\(post.reactions.likes) likes")
                                .foregroundColor(.black)
                            
                            Spacer()
                            Image(systemName: "person.fill")
                                .foregroundColor(.black)
                            
                            Text("User ID: \(post.userId)")
                                .foregroundColor(.black)
                        }
                        .font(.subheadline)
                        .fontWeight(.medium)
                    }
                    .padding(20)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(12)
                    .padding(.horizontal, 20)

                    VStack(alignment: .leading) {
                        Text("Comments")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .padding(.bottom, 10)
                        
                        if commentsViewModel.isLoading {
                            ProgressView()
                                .tint(.white)
                            
                        } else if let errorMessage = commentsViewModel.errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                        } else {
                            ForEach(commentsViewModel.comments) { comment in
                                CommentView(comment: comment)
                                    .padding(.bottom, 15)
                            }
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .padding(.top)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Post Details")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
        }
        .toolbarBackground(.white, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .task {
            await commentsViewModel.fetchComments(for: post.id)

            if selectedImageURL.isEmpty, let image = post.image {
                selectedImageURL = image
            }
        }
    }
}

struct ThumbnailView: View {
    let imageURL: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            AsyncImage(url: URL(string: imageURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .clipped()
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(isSelected ? Color.blue : Color.gray.opacity(0.3), lineWidth: isSelected ? 2 : 1)
                    )
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.1))
                    .frame(width: 80, height: 80)
                    .cornerRadius(8)
            }
        }
    }
}

struct PostDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            let mockPost = Post(
                id: 1,
                title: "His mother had always taught him",
                body: "His mother had always taught him not to ever think of himself as better than others. He'd tried to live by this motto. He never looked down on those who were less fortunate or who had less money than him. But the stupidity of the group of people he was talking to made him change his mind.",
                userId: 121,
                tags: ["tech", "future", "art"],
                reactions: Reactions(likes: 192, dislikes: 25), views:  1,
                image: "https://picsum.photos/600/400?random=1"
            )
            PostDetailView(post: mockPost)
        }
    }
}

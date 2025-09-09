import SwiftUI

struct CommentView: View {
    let comment: Comment
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            AsyncImage(url: URL(string: comment.user.avatarUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
            } placeholder: {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.gray)
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text(comment.user.fullName)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                Text(comment.body)
                    .font(.footnote)
                    .foregroundColor(.black.opacity(0.8))
            }
            Spacer()
        }
        .padding(10)
        .background(Color.white)
        .cornerRadius(8)
    }
}

struct CommentView_Previews: PreviewProvider {
    static var previews: some View {
        CommentView(
            comment: Comment(
                id: 1,
                body: "This is a great post!",
                postId: 1,
                likes: 5,
                user: CommentUser(id: 1, username: "john.doe", fullName: "John Doe")
            )
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}

import SwiftUI
import SwiftData

struct BookDetailView: View {
    @Bindable var book: Book
    @State private var isShowingEditSheet = false
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Spacer()
                    Button("Edit") {
                        isShowingEditSheet = true
                    }
                    .font(.headline)
                    .foregroundColor(.blue)
                    .padding(.horizontal)
                }
                .padding(.bottom, 10)
                
                Text(book.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 5)

                Text("by \(book.author)")
                    .font(.title2)
                    .foregroundColor(.secondary)
                    .padding(.bottom, 10)

                Divider()

                if let details = book.details {
                    Text(details)
                        .font(.body)
                        .padding(.bottom, 20)
                }
                
                Button(action: {
                    book.isRead.toggle()
                    try? modelContext.save()
                    print("Toggled read status for: \(book.title). New status: \(book.isRead)")
                }) {
                    HStack {
                        Image(systemName: book.isRead ? "book.closed.fill" : "book.closed")
                        Text(book.isRead ? "Mark as Unread" : "Mark as Read")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(book.isRead ? Color.gray : Color.blue)
                    .cornerRadius(10)
                }
            }
            .padding()
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $isShowingEditSheet) {
            EditBookView(book: book)
        }
    }
}

import SwiftUI
import SwiftData

struct BookListView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var authManager: AuthManager
    
    @Query private var allBooks: [Book]
    
    @State private var isShowingAddBookSheet = false
    
    private var books: [Book] {
        allBooks.filter { $0.owner?.email == authManager.currentUser?.email }
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                if books.isEmpty {
                    VStack(spacing: 20) {
                        ContentUnavailableView("No Books Yet", systemImage: "book.fill", description: Text("Start by adding your first book."))
                        Button("Add Book") {
                            isShowingAddBookSheet = true
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                } else {
                    List {
                        ForEach(books) { book in
                            NavigationLink(destination: BookDetailView(book: book)) {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(book.title)
                                            .font(.headline)
                                        Text(book.author)
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                    if book.isRead {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.green)
                                    }
                                }
                                .padding(.vertical, 5)
                            }
                        }
                        .onDelete(perform: deleteBooks)
                    }
                }
                
                Button(action: {
                    isShowingAddBookSheet = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.blue)
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(radius: 10)
                }
                .padding(.trailing, 20)
                .padding(.bottom, 20)
            }
            .navigationTitle("My Books")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Sign Out") {
                        authManager.signOut()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isShowingAddBookSheet = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                    }
                }
            }
            .sheet(isPresented: $isShowingAddBookSheet) {
                if let currentUser = authManager.currentUser {
                    AddBookView(owner: currentUser)
                }
            }
        }
    }
    
    private func deleteBooks(offsets: IndexSet) {
        for index in offsets {
            let bookToDelete = books[index]
            modelContext.delete(bookToDelete)
        }
    }
}

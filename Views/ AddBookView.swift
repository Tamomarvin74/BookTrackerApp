    import SwiftUI
    import SwiftData

    struct AddBookView: View {
        @Environment(\.modelContext) private var modelContext
        @Environment(\.dismiss) private var dismiss
        
        let owner: User
        
        @State private var title: String = ""
        @State private var author: String = ""
        @State private var details: String = ""
        
        var body: some View {
            NavigationStack {
                Form {
                    Section("Book Details") {
                        TextField("Title", text: $title)
                        TextField("Author", text: $author)
                        TextEditor(text: $details)
                            .frame(minHeight: 100)
                    }
                    
                    Button("Save Book") {
                        let newBook = Book(title: title, author: author, details: details, owner: owner)
                        modelContext.insert(newBook)
                        dismiss()
                    }
                    .frame(maxWidth: .infinity)
                    .buttonStyle(.borderedProminent)
                    .disabled(title.isEmpty || author.isEmpty)
                }
                .navigationTitle("Add New Book")
            }
        }
    }

import SwiftUI
import SwiftData

struct EditBookView: View {
    @Environment(\.dismiss) var dismiss
    @Bindable var book: Book

    var body: some View {
        NavigationStack {
            Form {
                Section("Book Details") {
                    TextField("Title", text: $book.title)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.words)
                    TextField("Author", text: $book.author)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.words)
                    
                    TextEditor(text: Binding(
                        get: { book.details ?? "" },
                        set: { book.details = $0.isEmpty ? nil : $0 }
                    ))
                    .frame(minHeight: 100)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.sentences)
                }
            }
            .navigationTitle("Edit Book")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { dismiss() }
                }
            }
        }
    }
}

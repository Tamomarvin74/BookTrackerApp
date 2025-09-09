    import SwiftUI
    import SwiftData

    struct RegisterView: View {
        @Environment(\.modelContext) private var modelContext
        @Environment(\.dismiss) private var dismiss
        @EnvironmentObject var authManager: AuthManager
        @Query private var users: [User]
        
        @State private var email = ""
        @State private var password = ""
        @State private var confirmPassword = ""
        @State private var errorMessage = ""
        @State private var isPasswordVisible = false
        @State private var isConfirmPasswordVisible = false

        var body: some View {
            NavigationStack {
                VStack {
                    Text("Create an Account")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.bottom, 50)
                    
                    TextField("Email", text: $email)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.emailAddress)
                        .textCase(.none)
                        .padding(.bottom, 10)
                    
                    HStack {
                        if isPasswordVisible {
                            TextField("Password", text: $password)
                        } else {
                            SecureField("Password", text: $password)
                        }
                        Button(action: {
                            isPasswordVisible.toggle()
                        }) {
                            Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(.gray)
                        }
                    }
                    .textFieldStyle(.roundedBorder)

                    HStack {
                        if isConfirmPasswordVisible {
                            TextField("Confirm Password", text: $confirmPassword)
                        } else {
                            SecureField("Confirm Password", text: $confirmPassword)
                        }
                        Button(action: {
                            isConfirmPasswordVisible.toggle()
                        }) {
                            Image(systemName: isConfirmPasswordVisible ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(.gray)
                        }
                    }
                    .textFieldStyle(.roundedBorder)
                    
                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                    }

                    Button("Register") {
                        register()
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.vertical)
                    .disabled(email.isEmpty || password.isEmpty || confirmPassword.isEmpty)
                    
                    Spacer()
                }
                .padding()
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                }
            }
        }
        
        private func register() {
     
            if password != confirmPassword {
                errorMessage = "Passwords do not match."
                return
            }
            if users.first(where: { $0.email == email }) != nil {
                errorMessage = "A user with this email already exists."
                return
            }
            
            let newUser = User(email: email, passwordHash: password)
            modelContext.insert(newUser)
            
             authManager.login(user: newUser)
            
            dismiss()
        }
    }

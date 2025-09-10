import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var username = ""
    @State private var password = ""
    @State private var isPasswordVisible = false

    @State private var regUsername = ""
    @State private var regPassword = ""
    @State private var regEmail = ""
    @State private var isRegPasswordVisible = false
    @State private var registrationMessage: String?

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("BookTracker")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                 TextField("Username", text: $username)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                    .autocapitalization(.none)

                HStack {
                    if isPasswordVisible {
                        TextField("Password", text: $password)
                    } else {
                        SecureField("Password", text: $password)
                    }

                    Button {
                        isPasswordVisible.toggle()
                    } label: {
                        Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal)

                Button {
                    Task {
                        await authManager.login(username: username, password: password)
                    }
                } label: {
                    if authManager.isLoading {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .tint(.white)
                    } else {
                        Text("Log in")
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(authManager.isLoading)

                if let errorMessage = authManager.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(.top, 10)
                }

                Divider()
                    .padding(.vertical, 20)

                 Text("Register")
                    .font(.title2)
                    .fontWeight(.semibold)

                TextField("Username", text: $regUsername)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                    .autocapitalization(.none)

                TextField("Email", text: $regEmail)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)

                HStack {
                    if isRegPasswordVisible {
                        TextField("Password", text: $regPassword)
                    } else {
                        SecureField("Password", text: $regPassword)
                    }

                    Button {
                        isRegPasswordVisible.toggle()
                    } label: {
                        Image(systemName: isRegPasswordVisible ? "eye.slash" : "eye")
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal)

                Button {
                    authManager.register(username: regUsername, email: regEmail, password: regPassword)
                    registrationMessage = "Registration successful! Logged in as \(regUsername)"
                } label: {
                    Text("Register")
                }
                .buttonStyle(.borderedProminent)

                if let registrationMessage = registrationMessage {
                    Text(registrationMessage)
                        .foregroundColor(.green)
                        .multilineTextAlignment(.center)
                        .padding(.top, 10)
                }

                Spacer()
            }
            .padding()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView().environmentObject(AuthManager())
    }
}


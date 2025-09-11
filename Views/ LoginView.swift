import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var email = ""
    @State private var password = ""
    @State private var isPasswordVisible = false
    
    @State private var regEmail = ""
    @State private var regPassword = ""
    @State private var isRegPasswordVisible = false
    @State private var registrationMessage: String?

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("BookTracker")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                 TextField("Email", text: $email)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)

                HStack {
                    if isPasswordVisible {
                        TextField("Password", text: $password)
                            .textFieldStyle(.roundedBorder)
                    } else {
                        SecureField("Password", text: $password)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    Button {
                        isPasswordVisible.toggle()
                    } label: {
                        Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal)

                Button {
                    authManager.login(email: email, password: password)
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

                TextField("Email", text: $regEmail)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)

                HStack {
                    if isRegPasswordVisible {
                        TextField("Password", text: $regPassword)
                            .textFieldStyle(.roundedBorder)
                    } else {
                        SecureField("Password", text: $regPassword)
                            .textFieldStyle(.roundedBorder)
                    }

                    Button {
                        isRegPasswordVisible.toggle()
                    } label: {
                        Image(systemName: isRegPasswordVisible ? "eye.slash" : "eye")
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal)

                Button {
                    authManager.register(email: regEmail, password: regPassword)
                    registrationMessage = "Registration successful! Logged in as \(regEmail)"
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


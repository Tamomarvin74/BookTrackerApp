// DO NOT DEFINE THE AuthError ENUM IN THIS FILE.
// It should be defined in a separate models file (e.g., AuthError.swift).

import Foundation

class AuthService {
    func login(username: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        let loginURL = URL(string: "https://dummyjson.com/auth/login")!
        
        var request = URLRequest(url: loginURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let loginData = ["username": username, "password": password]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: loginData) else {
            completion(.failure(AuthError.invalidRequest))
            return
        }
        
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(AuthError.unknownError))
                return
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                if httpResponse.statusCode == 400 || httpResponse.statusCode == 401 {
                    completion(.failure(AuthError.invalidCredentials))
                } else {
                    completion(.failure(AuthError.loginFailed))
                }
                return
            }
            
            guard let data = data else {
                completion(.failure(AuthError.noData))
                return
            }
            
            do {
                let user = try JSONDecoder().decode(User.self, from: data)
                completion(.success(user))
            } catch {
                completion(.failure(AuthError.loginFailed))
            }
        }.resume()
    }
}


//
//   AuthService.swift
//  BookTrackerApp
//
//  Created by Tamo Marvin Achiri   on 9/8/25.
//

import Foundation
 
final class AuthService {
     func login(username: String, password: String) async throws -> LoginResponse {
        guard let url = URL(string: "https://dummyjson.com/users") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let loginData = [" username": username, "password": password]
        request.httpBody = try JSONEncoder().encode(loginData)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        if (200...299).contains(httpResponse.statusCode) {
            return try JSONDecoder().decode(LoginResponse.self, from: data)
        } else if httpResponse.statusCode == 400 || httpResponse.statusCode == 401 {
            throw AuthError.invalidCredentials
        } else {
            throw AuthError.unknownError
        }
    }
}

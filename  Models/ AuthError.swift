//
//   AuthError.swift
//  BookTrackerApp
//
//  Created by Tamo Marvin Achiri   on 9/5/25.
//

 import Foundation

enum AuthError: LocalizedError {
    case invalidRequest
    case noData
    case loginFailed
    case invalidCredentials  
    var errorDescription: String? {
        switch self {
        case .invalidRequest:
            return "Failed to create login request."
        case .noData:
            return "No data received from the server."
        case .loginFailed:
            return "Login failed. Please check your credentials."
        case .invalidCredentials:
            return "Invalid username or password. Please try again."
        }
    }
}

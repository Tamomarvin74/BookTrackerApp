import Foundation

enum AuthError: LocalizedError {
    case invalidRequest
    case noData
    case loginFailed
    case invalidCredentials
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .invalidRequest:
            return "Failed to create login request."
        case .noData:
            return "No data received from the server."
        case .loginFailed:
            return "Login failed. Please try again."
        case .invalidCredentials:
            return "Invalid username or password. Please try again."
        case .unknownError:
            return "An unknown error occurred."
        }
    }
}

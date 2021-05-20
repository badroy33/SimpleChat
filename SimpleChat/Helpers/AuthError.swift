//
//  AuthError.swift
//  SimpleChat
//
//  Created by Maksym Levytskyi on 15.05.2021.
//

import Foundation

enum AuthError {
    case notFilled
    case invalidEmail
    case passwordNotMatched
    case unknownError
    case serverError
}

extension AuthError: LocalizedError{
    var errorDescription: String?{
        switch self {
        case .notFilled:
            return NSLocalizedString("Textfields are not filled", comment: "")
        case .invalidEmail:
            return NSLocalizedString("Invalid email", comment: "")
        case .passwordNotMatched:
            return NSLocalizedString("Password mismatch", comment: "")
        case .unknownError:
            return NSLocalizedString("Unknown error", comment: "")
        case .serverError:
            return NSLocalizedString("Server error", comment: "")
        }
    }
}

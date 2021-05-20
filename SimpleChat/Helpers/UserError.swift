//
//  UserError.swift
//  SimpleChat
//
//  Created by Maksym Levytskyi on 19.05.2021.
//

import Foundation

enum UserError {
    case notFilled
    case photoNotExist
}


extension UserError: LocalizedError{
    var errorDescription: String?{
        switch self {
        case .notFilled:
            return NSLocalizedString("Textfields are not filled", comment: "")
        case .photoNotExist:
            return NSLocalizedString("User has not selected a photo", comment: "")
        }
    }
}

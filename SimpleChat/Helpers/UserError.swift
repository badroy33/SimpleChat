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
    case unableToGetUser
    case notEnoughData
}


extension UserError: LocalizedError{
    var errorDescription: String?{
        switch self {
        case .notFilled:
            return NSLocalizedString("Textfields are not filled", comment: "")
        case .photoNotExist:
            return NSLocalizedString("User has not selected a photo", comment: "")
        case .unableToGetUser:
            return NSLocalizedString("Unable to get user", comment: "")
        case .notEnoughData:
            return NSLocalizedString("Not enough data", comment: "")
        }
    }
}

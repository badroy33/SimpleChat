//
//  UserModel.swift
//  SimpleChat
//
//  Created by Maksym Levytskyi on 07.05.2021.
//

import UIKit

struct UserModel: Hashable, Decodable {
    let username: String
    let avatarStringURL: String
    var id: Int
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: UserModel, rhs: UserModel) -> Bool{
        return lhs.id == rhs.id
    }
    
    func contains(filter: String?) -> Bool {
        guard let filter = filter else { return true }
        if filter.isEmpty { return true }
        let lowercasedFilter = filter.lowercased()
        
        return username.lowercased().contains(lowercasedFilter)
    }
    
}


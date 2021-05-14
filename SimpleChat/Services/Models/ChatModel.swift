//
//  ChatModel.swift
//  SimpleChat
//
//  Created by Maksym Levytskyi on 07.05.2021.
//

import UIKit

struct ChatModel: Hashable, Decodable {
    let username: String
    let userImageString: String
    let lastMessage: String
    var id: Int
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: ChatModel, rhs: ChatModel) -> Bool{
        return lhs.id == rhs.id
    }
    
}



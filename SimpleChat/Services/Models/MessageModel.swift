//
//  MessageModel.swift
//  SimpleChat
//
//  Created by Maksym Levytskyi on 24.05.2021.
//

import UIKit

struct MessageModel: Hashable {
    let content: String
    let senderID: String
    let senderUsername: String
    var sentDate: Date
    let id: String?
    
    var representation: [String : Any]{
        let rep: [String : Any] = [
            "content" : content,
            "senderID" : senderID,
            "senderUsername" : senderUsername,
            "created": sentDate
        ]
        return rep
    }
    
    init(user: UserModel, content: String) {
        self.content = content
        senderID = user.id
        senderUsername = user.username
        sentDate = Date()
        id = nil
    }
}

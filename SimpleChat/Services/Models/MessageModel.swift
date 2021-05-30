//
//  MessageModel.swift
//  SimpleChat
//
//  Created by Maksym Levytskyi on 24.05.2021.
//

import UIKit
import FirebaseFirestore

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
    
    init?(queryDocumentSnapshot: QueryDocumentSnapshot){
        let data = queryDocumentSnapshot.data()
        guard let content = data["content"] as? String,
              let senderID = data["senderID"] as? String,
              let senderUsername = data["senderUsername"] as? String,
              let sentDate = data["created"] as? Timestamp else { return nil }
        
        self.content = content
        self.senderID = senderID
        self.senderUsername = senderUsername
        self.sentDate = sentDate.dateValue()
        self.id = queryDocumentSnapshot.documentID
    }
    
    
    init(user: UserModel, content: String) {
        self.content = content
        senderID = user.id
        senderUsername = user.username
        sentDate = Date()
        id = nil
    }
}

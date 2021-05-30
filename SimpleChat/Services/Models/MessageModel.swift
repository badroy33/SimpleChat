//
//  MessageModel.swift
//  SimpleChat
//
//  Created by Maksym Levytskyi on 24.05.2021.
//

import UIKit
import FirebaseFirestore
import MessageKit

struct MessageModel: Hashable, MessageType {
    
    let content: String
    var sender: SenderType
    var sentDate: Date
    let id: String?
    
    var kind: MessageKind{
        return .text(content)
    }
    
    var messageId: String{
        return id ?? UUID().uuidString
    }
    
    var representation: [String : Any]{
        let rep: [String : Any] = [
            "content" : content,
            "senderID" : sender.senderId,
            "senderUsername" : sender.displayName,
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
        self.sender = Sender(senderId: senderID, displayName: senderUsername)
        self.sentDate = sentDate.dateValue()
        self.id = queryDocumentSnapshot.documentID
    }
    
    
    init(user: UserModel, content: String) {
        self.content = content
        sender = Sender(senderId: user.id, displayName: user.username)
        sentDate = Date()
        id = nil
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(messageId)
    }
    
    static func == (lhs: MessageModel, rhs: MessageModel) -> Bool {
        return lhs.messageId == rhs.messageId
    }
}

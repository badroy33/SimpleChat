//
//  ChatModel.swift
//  SimpleChat
//
//  Created by Maksym Levytskyi on 07.05.2021.
//

import UIKit
import FirebaseFirestore

struct ChatModel: Hashable, Decodable {
    let friendUsername: String
    let friendImageStringURL: String
    let lastMessageContent: String
    var friendID: String
    
    var representation: [String : Any]{
        var rep = ["friendUsername" : friendUsername]
        rep["friendImageStringURL"] = friendImageStringURL
        rep["lastMessage"] = lastMessageContent
        rep["friendID"] = friendID
        return rep
    }
    
    init(friendUsername: String, friendImageStringURL: String, lastMessageContent: String, friendID: String){
        self.friendUsername = friendUsername
        self.friendImageStringURL = friendImageStringURL
        self.lastMessageContent = lastMessageContent
        self.friendID = friendID
    }
    
    init?(queryDocumentSnapshot: QueryDocumentSnapshot){
        let data = queryDocumentSnapshot.data()
        
        guard let friendUsername = data["friendUsername"] as? String,
              let friendImageStringURL = data["friendImageStringURL"] as? String,
              let lastMessageContent = data["lastMessage"] as? String,
              let friendID = data["friendID"] as? String else { return nil }
        
        self.friendUsername = friendUsername
        self.friendImageStringURL = friendImageStringURL
        self.lastMessageContent = lastMessageContent
        self.friendID = friendID
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(friendID)
    }
    
    static func == (lhs: ChatModel, rhs: ChatModel) -> Bool{
        return lhs.friendID == rhs.friendID
    }
}



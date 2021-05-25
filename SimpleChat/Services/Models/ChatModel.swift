//
//  ChatModel.swift
//  SimpleChat
//
//  Created by Maksym Levytskyi on 07.05.2021.
//

import UIKit

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
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(friendID)
    }
    
    static func == (lhs: ChatModel, rhs: ChatModel) -> Bool{
        return lhs.friendID == rhs.friendID
    }
}



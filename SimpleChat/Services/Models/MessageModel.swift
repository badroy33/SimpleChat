//
//  MessageModel.swift
//  SimpleChat
//
//  Created by Maksym Levytskyi on 24.05.2021.
//

import UIKit
import FirebaseFirestore
import MessageKit

struct ImageItem: MediaItem {
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
}

struct MessageModel: Hashable, MessageType {
    
    let content: String
    var sender: SenderType
    var sentDate: Date
    let id: String?
    
    var kind: MessageKind{
//        return .text(content)
        if let image = image{
            return .photo(ImageItem(url: nil, image: nil, placeholderImage: image, size: image.size))
        }else{
            return .text(content)
        }
    }
    
    var messageId: String {
        return id ?? UUID().uuidString
    }
    
    var image: UIImage? = nil
    var downloadURL: URL? = nil
    
    var representation: [String : Any] {
        var rep: [String : Any] = [
            "senderID" : sender.senderId,
            "senderUsername" : sender.displayName,
            "created": sentDate
        ]
        
        if let url = downloadURL {
            rep["url"] = url.absoluteString
        }else {
            rep["content"] = content
        }
        return rep
    }
    
    init?(queryDocumentSnapshot: QueryDocumentSnapshot) {
        let data = queryDocumentSnapshot.data()
        guard let senderID = data["senderID"] as? String,
//              let content = data["content"] as? String,
              let senderUsername = data["senderUsername"] as? String,
              let sentDate = data["created"] as? Timestamp else { return nil }
        
        self.sender = Sender(senderId: senderID, displayName: senderUsername)
        self.sentDate = sentDate.dateValue()
        self.id = queryDocumentSnapshot.documentID
        
        if let content = data["content"] as? String{
            self.content = content
            downloadURL = nil
        } else if let urlString = data["url"] as? String, let url = URL(string: urlString) {
            downloadURL = url
            self.content = ""
        } else {
            return nil
        }
    }
    
    
    init(user: UserModel, content: String) {
        self.content = content
        sender = Sender(senderId: user.id, displayName: user.username)
        sentDate = Date()
        id = nil
    }
    
    init(user: UserModel, image: UIImage) {
        sender = Sender(senderId: user.id, displayName: user.username)
        content = ""
        self.image = image
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


extension MessageModel: Comparable {
    static func < (lhs: MessageModel, rhs: MessageModel) -> Bool {
        return lhs.sentDate < rhs.sentDate 
    }
    
    
}

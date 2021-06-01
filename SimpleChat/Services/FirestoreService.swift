//
//  FirestoreService.swift
//  SimpleChat
//
//  Created by Maksym Levytskyi on 19.05.2021.
//
import Firebase
import FirebaseFirestore

class FirestoreService{
    static let shared = FirestoreService()
    let db = Firestore.firestore()
    
    private var userRef: CollectionReference{
        return db.collection("users")
    }
    
    private var waitingChatsRef: CollectionReference{
        return db.collection(["users", currentUser.id, "waitingChats"].joined(separator: "/"))
    }
    
    private var currentChatsRef: CollectionReference{
        return db.collection(["users", currentUser.id, "currentChats"].joined(separator: "/"))
    }
    
    private var currentUser: UserModel!
    
    
    
    func getUserData(from user: User, completion: @escaping (Result<UserModel, Error>) -> Void ){
        let docRef = userRef.document(user.uid)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists{
                guard let muser = UserModel(documentSnapchot: document) else {
                    completion(.failure(UserError.notEnoughData))
                    return
                }
                self.currentUser = muser
                completion(.success(muser))
            }else{
                completion(.failure(UserError.unableToGetUser))
            }
        }
    }
    

    func saveProfileWith(id: String, email: String, username: String?, avatarImage: UIImage?, description: String?, sex: String?, completion: @escaping (Result<UserModel, Error>) -> Void) {
        print(#function)
        guard Validators.isFilled(username: username, description: description, sex: sex) else {
            completion(.failure(UserError.notFilled))
            return
        }
        
        guard avatarImage != #imageLiteral(resourceName: "avatar") else {
            completion(.failure(UserError.photoNotExist))
            return
        }
        
        var muser = UserModel(username: username!,
                              email: email,
                              avatarStringURL: "not exist",
                              description: description!,
                              sex: sex!,
                              id: id)
        
        StorageService.shared.upload(image: avatarImage!) { (result) in
            switch result{
            case .success(let url):
                print("StorageService suc")
                muser.avatarStringURL = url.absoluteString
                self.userRef.document(muser.id).setData(muser.representation){ (error) in
                    if let error = error{
                        completion(.failure(error))
                        print("userRef.document fail")
                        return
                    }else{
                        completion(.success(muser))
                        print("userRef.document suc")
                    }
                }
            case .failure(let error):
                print("StorageService fail")
                completion(.failure(error))
            }
        }//StorageService
    }//saveProfileWith
    
    func createWaitingChat(message: String, reciver: UserModel, completion: @escaping (Result<Void, Error>) -> Void){
        let reference = db.collection(["users", reciver.id, "waitingChats"].joined(separator: "/"))
        let messageRef = reference.document(self.currentUser.id).collection("messages")
        
        let message = MessageModel(user: self.currentUser, content: message)
        
        let chat = ChatModel(friendUsername: currentUser.username,
                             friendImageStringURL: currentUser.avatarStringURL,
                             lastMessageContent: message.content,
                             friendID: currentUser.id)
    
        reference.document(currentUser.id).setData(chat.representation) { (error) in
            if let error = error{
                completion(.failure(error))
                return
            }
            messageRef.addDocument(data: message.representation) { (error) in
                if let error = error{
                    completion(.failure(error))
                    return
                }
            }
            completion(.success(Void()))
        }
    }
    
    func deleteWaitingChat(chat: ChatModel, completion: @escaping (Result<Void, Error>) -> Void){
        waitingChatsRef.document(chat.friendID).delete { (error) in
            if let error = error{
                completion(.failure(error))
                return
            }
            self.deleteMessages(chat: chat, completion: completion)
        }
    }
    
    func deleteMessages(chat: ChatModel, completion: @escaping (Result<Void, Error>) -> Void){
        let referance = waitingChatsRef.document(chat.friendID).collection("messages")
        
        self.getWaitingChatMessages(chat: chat) { (result) in
            switch result{
            case .success(let messages):
                for message in messages {
                    guard let documentID = message.id else{ return }
                    let messageRef = referance.document(documentID)
                    messageRef.delete { (error) in
                        if let error = error{
                            completion(.failure(error))
                            return
                        }
                        completion(.success(Void()))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
                
            }
        }
    }
    
    func getWaitingChatMessages(chat: ChatModel, completion: @escaping (Result<[MessageModel], Error>) -> Void){
        let referance = waitingChatsRef.document(chat.friendID).collection("messages")
        var messages = [MessageModel]()
        referance.getDocuments { (querySnapshot, error) in
            if let error = error{
                completion(.failure(error))
                return
            }
            
            for document in querySnapshot!.documents{
                guard let message = MessageModel(queryDocumentSnapshot: document) else { return }
                messages.append(message)
            }
            completion(.success(messages))
        }
    }
    
    
    func changeToCurrentChat(chat: ChatModel, completion: @escaping (Result<Void, Error>) -> Void){
        self.getWaitingChatMessages(chat: chat) { (result) in
            switch result{
            case .success(let messages):
                self.deleteWaitingChat(chat: chat) { (result) in
                    switch result{
                    case .success():
                        self.createCurrentChat(chat: chat, messages: messages) { (result) in
                            switch result{
                            case .success():
                                completion(.success(Void()))
                            case .failure(let error):
                                completion(.failure(error))
                            }
                        }
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    func createCurrentChat(chat: ChatModel, messages: [MessageModel],  completion: @escaping (Result<Void, Error>) -> Void){
        let messagesRef = currentChatsRef.document(chat.friendID).collection("messages")
        currentChatsRef.document(chat.friendID).setData(chat.representation) { (error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            for message in messages{
                messagesRef.addDocument(data: message.representation) { (error) in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    completion(.success(Void()))
                }
            }
        }
    }
    
    
    func sendMessage(chat: ChatModel, message: MessageModel,  completion: @escaping (Result<Void, Error>) -> Void){
        let friendRef = userRef.document(chat.friendID).collection("currentChats").document(currentUser.id)
        let friendMessagesRef = friendRef.collection("messages")
        let myMessagesRef = userRef.document(currentUser.id).collection("currentChats").document(chat.friendID).collection("messages")
        
        let chatForFriend = ChatModel(friendUsername: currentUser.username,
                                      friendImageStringURL: currentUser.avatarStringURL,
                                      lastMessageContent: message.content,
                                      friendID: currentUser.id)
        
        friendRef.setData(chatForFriend.representation) { (error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            friendMessagesRef.addDocument(data: message.representation) { (error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                myMessagesRef.addDocument(data: message.representation) { (error) in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    completion(.success(Void()))
                }
            }
        }
    }
    
}

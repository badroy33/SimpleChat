//
//  ListenerService.swift
//  SimpleChat
//
//  Created by Maksym Levytskyi on 23.05.2021.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class ListenerService {
    
    static let shared = ListenerService()
    
    private let db = Firestore.firestore()
    
    private var usersRef: CollectionReference{
        return db.collection("users")
    }
    
    private var currentUserUID: String{
        return Auth.auth().currentUser!.uid
    }
    
    func usersObserve(users: [UserModel],  completion: @escaping (Result<[UserModel], Error>) -> Void) -> ListenerRegistration?{
        var users = users
        
        let usersListener = usersRef.addSnapshotListener { (querySnapshot, error) in
            guard let snapshot = querySnapshot else {
                completion(.failure(error!))
                return
            }
            
            snapshot.documentChanges.forEach { (difference) in
                guard let muser = UserModel(queryDocumentSnapchot: difference.document) else { return }
                
                switch difference.type{
                case .added:
                    guard !users.contains(muser) else { return }
                    guard muser.id != self.currentUserUID else { return }
                    users.append(muser)
                case .modified:
                    guard let index = users.firstIndex(of: muser) else { return }
                    users[index] = muser
                case .removed:
                    guard let index = users.firstIndex(of: muser) else { return }
                    users.remove(at: index)
                }
                
            }
            completion(.success(users))
        }
        return usersListener
    }//usersObserve
    
    
    
    func waitingChatsObserve(chats: [ChatModel],  completion: @escaping (Result<[ChatModel], Error>) -> Void) -> ListenerRegistration?{
        var chats = chats
        let chatsRef = db.collection(["users", currentUserUID, "waitingChats"].joined(separator: "/"))
        
        let chatsListener = chatsRef.addSnapshotListener { (querySnapshot, error) in
            guard let snapshot = querySnapshot else {
                completion(.failure(error!))
                return
            }
            
            snapshot.documentChanges.forEach { (difference) in
                guard let waitingChat = ChatModel(queryDocumentSnapshot: difference.document) else { return }
                
                switch difference.type{
                case .added:
                    guard !chats.contains(waitingChat) else { return }
                    chats.append(waitingChat)
                case .modified:
                    guard let index = chats.firstIndex(of: waitingChat) else { return }
                    chats[index] = waitingChat
                case .removed:
                    guard let index = chats.firstIndex(of: waitingChat) else { return }
                    chats.remove(at: index)
                }
            }
            completion(.success(chats))
        }
        return chatsListener
    }//waitingChatsObserve
    
    
    func currentChatsObserve(chats: [ChatModel],  completion: @escaping (Result<[ChatModel], Error>) -> Void) -> ListenerRegistration?{
        var chats = chats
        let chatsRef = db.collection(["users", currentUserUID, "currentChats"].joined(separator: "/"))
        
        let chatsListener = chatsRef.addSnapshotListener { (querySnapshot, error) in
            guard let snapshot = querySnapshot else {
                completion(.failure(error!))
                return
            }
            
            snapshot.documentChanges.forEach { (difference) in
                guard let currentChat = ChatModel(queryDocumentSnapshot: difference.document) else { return }
                
                switch difference.type{
                case .added:
                    guard !chats.contains(currentChat) else { return }
                    chats.append(currentChat)
                case .modified:
                    guard let index = chats.firstIndex(of: currentChat) else { return }
                    chats[index] = currentChat
                case .removed:
                    guard let index = chats.firstIndex(of: currentChat) else { return }
                    chats.remove(at: index)
                }
            }
            completion(.success(chats))
        }
        return chatsListener
    }//currentChatsObserve
    
}



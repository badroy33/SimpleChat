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
    }
    
}


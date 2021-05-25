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
    
}

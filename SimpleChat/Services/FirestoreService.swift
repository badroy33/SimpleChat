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
    
    
    func getUserData(from user: User, completion: @escaping (Result<UserModel, Error>) -> Void ){
        let docRef = userRef.document(user.uid)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists{
                guard let muser = UserModel(documentSnapchot: document) else {
                    completion(.failure(UserError.notEnoughData))
                    return
                }
                completion(.success(muser))
            }else{
                completion(.failure(UserError.unableToGetUser))
            }
        }
    }
    

    func saveProfileWith(id: String, email: String, username: String?, avatarImageString: String?, description: String?, sex: String?, completion: @escaping (Result<UserModel, Error>) -> Void) {
        
        guard Validators.isFilled(username: username, description: description, sex: sex) else {
            completion(.failure(UserError.notFilled))
            return
        }
        let muser = UserModel(username: username!,
                              email: email,
                              avatarStringURL: "avatarImageString!",
                              description: description!,
                              sex: sex!,
                              id: id)
        
        self.userRef.document(muser.id).setData(muser.representation){ (error) in
            if let error = error{
                completion(.failure(error))
                return
            }else{
                completion(.success(muser))
            }
        }
    }
    
}

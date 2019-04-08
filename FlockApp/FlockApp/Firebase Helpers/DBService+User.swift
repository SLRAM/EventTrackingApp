//
//  DBService+User.swift
//  FlockApp
//
//  Created by Stephanie Ramirez on 4/8/19.
//

import Foundation
import FirebaseFirestore
import Firebase

struct UsersCollectionKeys {
    static let CollectionKey = "users"
    static let UserIdKey = "userId"
    static let DisplayNameKey = "displayName"
    static let FirstNameKey = "firstName"
    static let LastNameKey = "lastName"
    static let EmailKey = "email"
    static let PhotoURLKey = "photoURL"
    static let JoinedDateKey = "joinedDate"
    static let BioKey = "bio"
    static let CoverImageURLKey = "coverImageURL"
}
extension DBService {
    static public func createUser(user: UserModel, completion: @escaping (Error?) -> Void) {
        firestoreDB.collection(UsersCollectionKeys.CollectionKey)
            .document(user.userId)
            .setData([ UsersCollectionKeys.UserIdKey : user.userId,
                       UsersCollectionKeys.DisplayNameKey : user.displayName,
                       UsersCollectionKeys.EmailKey       : user.email,
                       UsersCollectionKeys.PhotoURLKey    : user.photoURL ?? "",
                       UsersCollectionKeys.JoinedDateKey  : user.joinedDate,
                       UsersCollectionKeys.BioKey         : user.bio ?? "",
                       UsersCollectionKeys.FirstNameKey   : user.firstName,
                       UsersCollectionKeys.LastNameKey    : user.lastName,
                       UsersCollectionKeys.CoverImageURLKey: user.coverImageURL ?? "",
            ]) { (error) in
                if let error = error {
                    completion(error)
                } else {
                    completion(nil)
                }
        }
    }
    
    
    static public func fetchUser(userId: String, completion: @escaping (Error?, UserModel?) -> Void) {
        DBService.firestoreDB
            .collection(UsersCollectionKeys.CollectionKey)
            .whereField(UsersCollectionKeys.UserIdKey, isEqualTo: userId)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    completion(error, nil)
                } else if let snapshot = snapshot?.documents.first {
                    let postCreator = UserModel(dict: snapshot.data())
                    completion(nil, postCreator)
                }
        }
    }
}

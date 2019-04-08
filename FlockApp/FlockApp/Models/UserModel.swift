//
//  UserModel.swift
//  FlockApp
//
//  Created by Stephanie Ramirez on 4/8/19.
//

import Foundation

struct UserModel {
    let userId: String
    let displayName: String
    let email: String
    let photoURL: String?
    let coverImageURL: String?
    let joinedDate: String
    let firstName: String?
    let lastName: String?
    let bio: String?
    // add array event id?
    // add array friend/users id?
    // add location
    public var fullName: String {
        return ((firstName ?? "") + " " + (lastName ?? "")).trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    init(userId: String,
         displayName: String,
         email: String,
         photoURL: String?,
         coverImageURL: String?,
         joinedDate: String,
         firstName: String?,
         lastName: String?,
         bio: String?) {
        self.userId = userId
        self.displayName = displayName
        self.email = email
        self.photoURL = photoURL
        self.coverImageURL = coverImageURL
        self.joinedDate = joinedDate
        self.firstName = firstName
        self.lastName = lastName
        self.bio = bio
    }
    
    init(dict: [String: Any]) {
        self.userId = dict[UsersCollectionKeys.UserIdKey] as? String ?? ""
        self.displayName = dict[UsersCollectionKeys.DisplayNameKey] as? String ?? ""
        self.email = dict[UsersCollectionKeys.EmailKey] as? String ?? ""
        self.photoURL = dict[UsersCollectionKeys.PhotoURLKey] as? String ?? ""
        self.coverImageURL = dict[UsersCollectionKeys.CoverImageURLKey] as? String ?? ""
        self.joinedDate = dict[UsersCollectionKeys.JoinedDateKey] as? String ?? ""
        self.firstName = dict[UsersCollectionKeys.FirstNameKey] as? String ?? "FirstName"
        self.lastName = dict[UsersCollectionKeys.LastNameKey] as? String ?? "LastName"
        self.bio = dict[UsersCollectionKeys.BioKey] as? String ?? "Bio"
    }
}

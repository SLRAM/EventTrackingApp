//
//  AuthService.swift
//  FlockApp
//
//  Created by Stephanie Ramirez on 4/8/19.
//

import Foundation
import FirebaseAuth

protocol AuthServiceCreateNewAccountDelegate: AnyObject {
    func didRecieveErrorCreatingAccount(_ authservice: AuthService, error: Error)
    func didCreateNewAccount(_ authservice: AuthService, user: UserModel)
}

protocol AuthServiceExistingAccountDelegate: AnyObject {
    func didRecieveErrorSigningToExistingAccount(_ authservice: AuthService, error: Error)
    func didSignInToExistingAccount(_ authservice: AuthService, user: User)
}

protocol AuthServiceSignOutDelegate: AnyObject {
    func didSignOutWithError(_ authservice: AuthService, error: Error)
    func didSignOut(_ authservice: AuthService)
}

final class AuthService {
    weak var authserviceCreateNewAccountDelegate: AuthServiceCreateNewAccountDelegate?
    weak var authserviceExistingAccountDelegate: AuthServiceExistingAccountDelegate?
    weak var authserviceSignOutDelegate: AuthServiceSignOutDelegate?
    
    
    public func createNewAccount(username: String, email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
            if let error = error {
                self.authserviceCreateNewAccountDelegate?.didRecieveErrorCreatingAccount(self, error: error)
                return
            } else if let authDataResult = authDataResult {
                
                // update displayName for auth user
                let request = authDataResult.user.createProfileChangeRequest()
                request.displayName = username
                request.commitChanges(completion: { (error) in
                    if let error = error {
                        self.authserviceCreateNewAccountDelegate?.didRecieveErrorCreatingAccount(self, error: error)
                        return
                    }
                })
                let defaultPhoto = "https://firebasestorage.googleapis.com/v0/b/flock-ca5ff.appspot.com/o/images%2FprofileImages%2FHlO5MPnNLoZjK5UIwarSNA9qYK03?alt=media&token=812f76ed-9433-4daa-a6c6-298dc24f3655"
                // create user (user) on firestore database
                let user = UserModel.init(userId: authDataResult.user.uid, displayName: username, email: authDataResult.user.email!, photoURL: defaultPhoto, coverImageURL: nil, joinedDate: Date.getISOTimestamp(), firstName: nil, lastName: nil, bio: nil, phoneNumber: nil, fullnameIsVisible: false, emailIsVisible: false, phoneIsVisible: false)
                print(user)
                DBService.createUser(user: user, completion: { (error) in
                    if let error = error {
                        self.authserviceCreateNewAccountDelegate?.didRecieveErrorCreatingAccount(self, error: error)
                    } else {
                        self.authserviceCreateNewAccountDelegate?.didCreateNewAccount(self, user: user)
                    }
                })
            }
        }
    }
    
    public func signInExistingAccount(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
            if let error = error {
                self.authserviceExistingAccountDelegate?.didRecieveErrorSigningToExistingAccount(self, error: error)
            } else if let authDataResult = authDataResult {
                self.authserviceExistingAccountDelegate?.didSignInToExistingAccount(self, user: authDataResult.user)
            }
        }
    }
    
    public func getCurrentUser() -> User? {
        return Auth.auth().currentUser
    }
    
    public func signOutAccount() {
        do {
            try Auth.auth().signOut()
            authserviceSignOutDelegate?.didSignOut(self)
        } catch {
            authserviceSignOutDelegate?.didSignOutWithError(self, error: error)
        }
    }
}

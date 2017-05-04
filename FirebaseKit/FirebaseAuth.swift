//
//  FirebaseAuth.swift
//  FirebaseKit
//
//  Created by Carlos Grossi on 24/01/17.
//  Copyright © 2017 Carlos Grossi. All rights reserved.
//

import Foundation
import FirebaseAuth

public struct FirebaseAuth {
    public static var defaultAuth = FirebaseAuth()
    var stateDidChangeListenerHandle:FIRAuthStateDidChangeListenerHandle?
}

// MARK: - Create User
extension FirebaseAuth {
    
    public func createUser(withEmail email:String, andPassword password:String, completition:((_ user:FirebaseAuthUser?, _ error:Error?)->())?) -> Void {
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            completition?(FirebaseAuthUser.authUser(with: user), error)
        })
    }
    
}

// MARK: - User Profile
extension FirebaseAuth {
    
    public func update(email:String, completition:((_ error:Error?)->())?) -> Void {
        FIRAuth.auth()?.currentUser?.updateEmail(email, completion: completition)
    }
    
    public func update(password:String, completition:((_ error:Error?)->())?) -> Void {
        FIRAuth.auth()?.currentUser?.updatePassword(password, completion: completition)
    }
    
    public func update(displayName:String) -> Void {
        FIRAuth.auth()?.currentUser?.profileChangeRequest().displayName = displayName
    }
    
    public func update(photoURL:URL) -> Void {
        FIRAuth.auth()?.currentUser?.profileChangeRequest().photoURL = photoURL
    }
    
    public func commitChanges(completition:((_ error:Error?)->())?) -> Void {
        FIRAuth.auth()?.currentUser?.profileChangeRequest().commitChanges(completion: completition)
    }
    
}

// MARK: - Communications
extension FirebaseAuth {
    
    public func sendEmailVerification(completition:((_ error:Error?)->())?) -> Void {
        FIRAuth.auth()?.currentUser?.sendEmailVerification(completion: completition)
    }
    
    public func sendPasswordReset(toEmail email:String, completition:((_ error:Error?)->())?) -> Void {
        FIRAuth.auth()?.sendPasswordReset(withEmail: email, completion: completition)
    }
    
}

// MARK: - Sign In
extension FirebaseAuth {
    
    public func signIn(withEmail email:String, andPassword password:String, completition:((_ user:FirebaseAuthUser?, _ error:Error?)->())?) -> Void {
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            completition?(FirebaseAuthUser.authUser(with: user), error)
        })
    }
    
    public func signIn(withFacebookAccessToken accessToken:String, completition:((_ user:FirebaseAuthUser?, _ error:Error?)->())?) -> Void {
        signIn(withCredential: credential(withFacebookAccessToken: accessToken), completition: completition)
    }
    
    public func signIn(withGoogleSignIdToken idToken:String, andAccessToken accessToken:String, completition:((_ user:FirebaseAuthUser?, _ error:Error?)->())?) -> Void {
        signIn(withCredential: credential(withGoogleSignInIdToken: idToken, andAccessToken: accessToken), completition: completition)
    }
    
    public func signIn(withCustomToken token:String, completition:((_ user:FirebaseAuthUser?, _ error:Error?)->())?) -> Void {
        FIRAuth.auth()?.signIn(withCustomToken: token, completion: { (user, error) in
            completition?(FirebaseAuthUser.authUser(with: user), error)
        })
    }
    
    fileprivate func signIn(withCredential credential:FIRAuthCredential, completition:((_ user:FirebaseAuthUser?, _ error:Error?)->())?) -> Void {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            completition?(FirebaseAuthUser.authUser(with: user), error)
        })
    }
    
    public func signInAnonymously(completition:((_ user:FirebaseAuthUser?, _ error:Error?)->())?) -> Void {
        FIRAuth.auth()?.signInAnonymously(completion: { (user, error) in
            completition?(FirebaseAuthUser.authUser(with: user), error)
        })
    }
    
    mutating public func addStateDidChangeListener(completition:@escaping ((_ user:FirebaseAuthUser?)->())) -> Void {
        stateDidChangeListenerHandle = FIRAuth.auth()?.addStateDidChangeListener({ (auth, user) in
            completition(FirebaseAuthUser.authUser(with: user))
        })
    }
    
    mutating public func removeAuthStateDidChangeListener() -> Void {
        guard let handle = stateDidChangeListenerHandle else { return }
        FIRAuth.auth()?.removeStateDidChangeListener(handle)
        stateDidChangeListenerHandle = nil
    }
    
    public func signedInUser() -> FirebaseAuthUser? {
        return FirebaseAuthUser.authUser(with: FIRAuth.auth()?.currentUser)
    }
    
    public func isSignedIn() -> Bool {
        return FIRAuth.auth()?.currentUser == nil ? false : true
    }
    
    public func isVerified() -> Bool {
        guard let currentUser = FIRAuth.auth()?.currentUser else { return false }
        return currentUser.isEmailVerified
    }
    
}

// MARK: - Sign Out
extension FirebaseAuth {
    
    public func signOut() -> Bool {
        do {
            try FIRAuth.auth()?.signOut()
            return true
        } catch  {
            return false
        }
    }
    
}

// MARK: - Reauthentication
extension FirebaseAuth {
    
    public func reauthenticate(withFacebookAccessToken accessToken:String, completition:((_ error:Error?)->())?) -> Void {
        reauthenticate(withCredential: credential(withFacebookAccessToken: accessToken), completition: completition)
    }
    
    public func reauthenticate(withGoogleSignIdToken idToken:String, andAccessToken accessToken:String, completition:((_ error:Error?)->())?) -> Void {
        reauthenticate(withCredential: credential(withGoogleSignInIdToken: idToken, andAccessToken: accessToken), completition: completition)
    }
    
    fileprivate func reauthenticate(withCredential credential:FIRAuthCredential, completition:((_ error:Error?)->())?) -> Void {
        FIRAuth.auth()?.currentUser?.reauthenticate(with: credential, completion: completition)
    }
    
}

// MARK: - Credential
extension FirebaseAuth {
    
    fileprivate func credential(withFacebookAccessToken accessToken:String) -> FIRAuthCredential {
        return FIRFacebookAuthProvider.credential(withAccessToken: accessToken)
    }
    
    fileprivate func credential(withGoogleSignInIdToken idToken:String, andAccessToken accessToken:String) -> FIRAuthCredential {
        return FIRGoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
    }
    
}

// MARK: - Providers
extension FirebaseAuth {
    
    public func fetchProvidersForCurrentUser(completition:@escaping (([String]?, Error?)->())) -> Void {
        fetchProviders(forEmail: FIRAuth.auth()?.currentUser?.email, completition: completition)
    }
    
    public func fetchProviders(forEmail email:String?, completition:@escaping (([String]?, Error?)->())) -> Void {
        guard let email = email else { completition(nil, nil); return }
        FIRAuth.auth()?.fetchProviders(forEmail: email, completion: completition)
    }
    
}

// MARK: - Delete User
extension FirebaseAuth {
    
    public func deleteCurrentUser(completition:((_ error:Error?)->())?) -> Void {
        FIRAuth.auth()?.currentUser?.delete(completion: completition)
    }
    
}

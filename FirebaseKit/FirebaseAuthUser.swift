//
//  FirebaseAuthUser.swift
//  FirebaseKit
//
//  Created by Carlos Grossi on 24/01/17.
//  Copyright © 2017 Carlos Grossi. All rights reserved.
//

import Foundation
import FirebaseAuth

public class FirebaseAuthUser {
    fileprivate var user:FIRUser
    
    fileprivate init(user:FIRUser) {
        self.user = user
    }
    
    static func authUser(with user:FIRUser?) -> FirebaseAuthUser? {
        guard let user = user else { return nil }
        return FirebaseAuthUser(user: user)
    }
    
}


// MARK: -
extension FirebaseAuthUser {
    
    public func isAnonymous() -> Bool {
        return user.isAnonymous
    }
    
    public func isEmailVerified() -> Bool {
        return user.isEmailVerified
    }
    
    public func userId() -> String? {
        return user.uid
    }
    
    public func displayName() -> String? {
        return user.displayName
    }
    
    public func email() -> String? {
        return user.email
    }
    
    public func photoURL() -> URL? {
        return user.photoURL
    }
    
    public func getToken(withCompletition completition:@escaping ((String?, Error?)->())) -> Void {
        user.getTokenWithCompletion(completition)
    }
    
    public func getToken(forcingRefresh: Bool, completition:@escaping ((String?, Error?)->())) -> Void {
        user.getTokenForcingRefresh(forcingRefresh, completion: completition)
    }
    
    public func getProviders() -> Array<String> {
        var providerIds:Array<String> = Array()
        for provider in user.providerData {
            providerIds.append(provider.providerID)
        }
        return providerIds
    }
    
    public func linkGoogleCredential(withIdToken idToken:String, andAccessToken accessToken:String, completion:((FirebaseAuthUser?, Error?)->())?) -> Void {
        let credential = FIRGoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        link(credential: credential, completion: completion)
    }
    
    public func linkFacebookCredential(withAccessToken accessToken:String, completion:((FirebaseAuthUser?, Error?)->())?) -> Void {
        let credential = FIRFacebookAuthProvider.credential(withAccessToken: accessToken)
        link(credential: credential, completion: completion)
    }
    
    func link(credential:FIRAuthCredential, completion:((FirebaseAuthUser?, Error?)->())?) -> Void {
        user.link(with: credential) { (user, error) in
            completion?(FirebaseAuthUser.authUser(with: user), error)
        }
    }
    
    public func unlink(fromProvider providerId:String, completition:((FirebaseAuthUser?, Error?)->())?) -> Void {
        user.unlink(fromProvider: providerId) { (user, error) in
            completition?(FirebaseAuthUser.authUser(with: user), error)
        }
    }
    
    public func update(displayName:String?) {
        let profileChangeRequest = user.profileChangeRequest()
        profileChangeRequest.displayName = displayName
        profileChangeRequest.commitChanges(completion: nil)
//        user.profileChangeRequest().displayName = displayName
//        print(user.profileChangeRequest().displayName)
    }
    
    public func update(photoURL:URL?) {
        user.profileChangeRequest().photoURL = photoURL
    }
    
    public func commitChanges(completion:((Error?)->Void)?) {
        print(user.profileChangeRequest().displayName)
        user.profileChangeRequest().commitChanges { (error) in
            print(error)
            completion?(error)
        }
        //user.profileChangeRequest().commitChanges(completion: completion)
    }
    
    public func reload(completion:((Error?)->Void)?) {
        user.reload(completion: completion)
    }
    
}

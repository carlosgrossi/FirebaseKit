//
//  FirebaseRemoteConfig.swift
//  FirebaseKit
//
//  Created by Carlos Grossi on 25/01/17.
//  Copyright © 2017 Carlos Grossi. All rights reserved.
//

import Foundation
import FirebaseRemoteConfig
import FirebaseCore

public struct FirebaseRemoteConfig {
    public static var defaultConfig = FirebaseRemoteConfig()
    fileprivate let remoteConfig = FIRRemoteConfig.remoteConfig()
}

// MARK: - Set Defaults
extension FirebaseRemoteConfig {
    
    public func setDefaults(_ defaults: [String : NSObject]?, namespace: String? = nil) -> Void {
        remoteConfig.configSettings = FIRRemoteConfigSettings(developerModeEnabled: true)!
        remoteConfig.setDefaults(defaults)
    }
    
    public func setDefaults(withPlist fileName:String?, namespace:String? = nil) -> Void {
        remoteConfig.configSettings = FIRRemoteConfigSettings(developerModeEnabled: true)!
        remoteConfig.setDefaultsFromPlistFileName(fileName, namespace: namespace)
    }
    
}

// MARK: - Fetch
extension FirebaseRemoteConfig {
    
    public func fetchConfig(withExpirationDuration expirationDuration:TimeInterval, completion:((Error?)->Void)?) -> Void {
        remoteConfig.fetch(withExpirationDuration: expirationDuration) { (fetchStatus, error) in
            completion?(error)
        }
    }
    
    public func activateFetched() -> Bool {
        return remoteConfig.activateFetched()
    }
    
}


// MARK: - Acessing Values
extension FirebaseRemoteConfig {
    
    public func configValue(forKey key:String, namespace:String? = nil) -> String? {
        return remoteConfig.configValue(forKey: key, namespace: namespace).stringValue
    }
    
    public func configValue(forKey key:String, namespace:String? = nil) -> NSNumber? {
        return remoteConfig.configValue(forKey: key, namespace: namespace).numberValue
    }
    
    public func configValue(forKey key:String, namespace:String? = nil) -> Data? {
        return remoteConfig.configValue(forKey: key, namespace: namespace).dataValue
    }
    
    public func configValue(forKey key:String, namespace:String? = nil) -> Bool? {
        return remoteConfig.configValue(forKey: key, namespace: namespace).boolValue
    }
    
}

//
//  FirebaseCore.swift
//  FirebaseKit
//
//  Created by Carlos Grossi on 25/01/17.
//  Copyright © 2017 Carlos Grossi. All rights reserved.
//

import Foundation
import FirebaseCore

public struct FirebaseCore {
    public static var defaultCore = FirebaseCore()
}

// MARK: - Configure App
extension FirebaseCore {
    
    public func configure() -> Void {
        FIRApp.configure()
    }
    
    func configure(with options:FIROptions) {
        FIRApp.configure(with: options)
    }
    
    func configure(withName name:String, options:FIROptions) -> Void {
        FIRApp.configure(withName: name, options: options)
    }
    
    public func defaultApp() -> FIRApp? {
        return FIRApp.defaultApp()
    }
    
    func app(named:String) -> FIRApp? {
        return FIRApp(named: named)
    }
    
    func allApps() -> [AnyHashable : Any]? {
        return FIRApp.allApps()
    }
    
    func delete(app:FIRApp, completition:@escaping ((Bool)->())) {
        app.delete(completition)
    }
    
}

// MARK: - Property Access
extension FirebaseCore {
    
    func appName(app:FIRApp) -> String {
        return app.name
    }
    
    func appOptions(app:FIRApp) -> FIROptions {
        return app.options
    }
    
    public func appClientID(app:FIRApp) -> String {
        return app.options.clientID
    }
    
}

//
//  FirebaseSnapshot.swift
//  FirebaseKit
//
//  Created by Carlos Grossi on 25/01/17.
//  Copyright © 2017 Carlos Grossi. All rights reserved.
//

import Foundation
import FirebaseDatabase

public struct FirebaseDataSnapshot {
    fileprivate var snapshot:FIRDataSnapshot
    
    fileprivate init(snapshot:FIRDataSnapshot) {
        self.snapshot = snapshot
    }
    
    static func dataSnapshot(withSnapshot snapshot:FIRDataSnapshot?) -> FirebaseDataSnapshot? {
        guard let snapshot = snapshot else { return nil }
        return FirebaseDataSnapshot(snapshot: snapshot)
    }
}


// MARK: -
extension FirebaseDataSnapshot {
    
    public func value() -> Any? {
        return snapshot.value
    }
    
    public func keys() -> [AnyHashable]? {
        return snapshot.children.allObjects as? [AnyHashable]
    }
    
    public func key() -> String {
        return snapshot.key
    }
    
}

//
//  FirebaseDatabase.swift
//  FirebaseKit
//
//  Created by Carlos Grossi on 25/01/17.
//  Copyright © 2017 Carlos Grossi. All rights reserved.
//

import Foundation
import FirebaseCore
import FirebaseDatabase

public struct FirebaseDatabase {
    public static var defaultDatabase = FirebaseDatabase()
    var dbReference = FIRDatabase.database().reference()
}

// MARK: - Observe Data
extension FirebaseDatabase {
    
    public func observe(childPath:String, eventType:FIRDataEventType, completition:@escaping ((FirebaseDataSnapshot?)->()), cancel:((Error)->())?) -> Void {
        dbReference.child(childPath).observe(eventType, with: { (dataSnapshot) in
            completition(FirebaseDataSnapshot.dataSnapshot(withSnapshot: dataSnapshot))
        }, withCancel: cancel)
    }
    
    public func observeSingleEvent(of eventType:FIRDataEventType, onChildPath childPath:String, completition:@escaping ((FirebaseDataSnapshot?)->()), cancel:((Error)->())?) -> Void {
        dbReference.child(childPath).observeSingleEvent(of: eventType, with: { (dataSnapshot) in
            completition(FirebaseDataSnapshot.dataSnapshot(withSnapshot: dataSnapshot))
        }, withCancel: cancel)
    }
    
    public func observe (childPath:String, eventType:FIRDataEventType, orderedBy:String, startingAt:Any?, limitedToFirst:UInt, completition:@escaping ((FirebaseDataSnapshot?)->()), cancel:((Error)->())?) -> Void {
        dbReference.child(childPath).queryOrdered(byChild: orderedBy).queryStarting(atValue: startingAt).queryLimited(toFirst: limitedToFirst).observe(eventType, with:
            { (dataSnapshot) in
                completition(FirebaseDataSnapshot.dataSnapshot(withSnapshot: dataSnapshot))
        }, withCancel: cancel)
    }
    
}

// MARK: - Query Data
extension FirebaseDatabase {
    
    public func queryOrderedByKey(childPath:String) -> FirebaseQuery? {
        return FirebaseQuery.databaseQuery(withQuery: dbReference.child(childPath).queryOrderedByKey())
    }
    
    public func queryOrderedByPriority(childPath:String) -> FirebaseQuery? {
        return FirebaseQuery.databaseQuery(withQuery: dbReference.child(childPath).queryOrderedByPriority())
    }
    
    public func queryOrderedByChild(child:String, onChildPath childPath:String) -> FirebaseQuery? {
        return FirebaseQuery.databaseQuery(withQuery: dbReference.child(childPath).queryOrdered(byChild: child))
    }
    
    public func query(equalTo value:Any?, onChildPath childPath:String) -> FirebaseQuery? {
        return FirebaseQuery.databaseQuery(withQuery: dbReference.child(childPath).queryEqual(toValue: value))
    }
    
    public func query(startingAtValue value:Any?, onChildPath childPath:String) -> FirebaseQuery? {
        return FirebaseQuery.databaseQuery(withQuery: dbReference.child(childPath).queryStarting(atValue: value))
    }
    
    public func query(endingAtValue value:Any?, onChildPath childPath:String) -> FirebaseQuery? {
        return FirebaseQuery.databaseQuery(withQuery: dbReference.child(childPath).queryEnding(atValue: value))
    }
    
    public func query(limitedToLast entries:UInt, onChildPath childPath:String) -> FirebaseQuery? {
        return FirebaseQuery.databaseQuery(withQuery: dbReference.child(childPath).queryLimited(toLast: entries))
    }
    
    public func query(limitedToFirst entries:UInt, onChildPath childPath:String) -> FirebaseQuery? {
        return FirebaseQuery.databaseQuery(withQuery: dbReference.child(childPath).queryLimited(toFirst: entries))
    }
    
}


// MARK: - Write Data
extension FirebaseDatabase {
    
    public func setValue(value:Any?, toChildPath childPath:String) -> Void {
        setValue(value: value, toChildPath: childPath, withCompletitionBlock: nil)
    }
    
    public func setValue(value:Any?, toChildPath childPath:String, withCompletitionBlock completitionBlock:((Error?)->())?) -> Void {
        setValue(value: value, andPriority: nil, toChildPath: childPath, withCompletitionBlock: completitionBlock)
    }
    
    public func setValue(value:Any?, andPriority priority:Any?, toChildPath childPath:String, withCompletitionBlock completitionBlock:((Error?)->())?) -> Void {
        dbReference.child(childPath).setValue(value, andPriority: priority) { (error, dbReference) in
            completitionBlock?(error)
        }
    }
    
    public func appendValue(value:Any?, andPriority priority:Any?, toChildPath childPath:String, withCompletitionBlock completitionBlock:((Error?)->())?) -> Void {
        dbReference.child(childPath).childByAutoId().setValue(value, andPriority: priority) { (error, dbReference) in
            completitionBlock?(error)
        }
    }
    
    public func remove(child:String, withCompletionBlock completionBlock:((Error?)->())?) -> Void {
        dbReference.child(child).removeValue { (error, dbReference) in
            completionBlock?(error)
        }
    }
    
}

// MARK: - Transaction Block
extension FirebaseDatabase {
    
    public func runTransactionBlock(block:@escaping (FirebaseMutableData) -> FirebaseTransactionResult) -> Void {
        dbReference.runTransactionBlock { (mutableData) -> FIRTransactionResult in
            return block(FirebaseMutableData.mutableData(withMutableData: mutableData)!).transactionResult
        }
    }
    
    public func runTransactionBlock(block:@escaping (FirebaseMutableData) -> FirebaseTransactionResult, andCompletionBlock completionBlock:@escaping ((Error?, Bool, FirebaseDataSnapshot?) -> Void)) -> Void {
        dbReference.runTransactionBlock({ (mutableData) -> FIRTransactionResult in
            return block(FirebaseMutableData.mutableData(withMutableData: mutableData)!).transactionResult
        }) { (error, commited, dataSnapshot) in
            completionBlock(error, commited, FirebaseDataSnapshot.dataSnapshot(withSnapshot: dataSnapshot))
        }
    }
    
    public func runTransactionBlock(block:@escaping (FirebaseMutableData) -> FirebaseTransactionResult, andCompletionBlock completionBlock:((Error?, Bool, FirebaseDataSnapshot?) -> Void)?, withLocalEvents: Bool) -> Void {
        dbReference.runTransactionBlock({ (mutableData) -> FIRTransactionResult in
            return block(FirebaseMutableData.mutableData(withMutableData: mutableData)!).transactionResult
        }, andCompletionBlock: { (error, commited, dataSnapshot) in
            completionBlock?(error, commited, FirebaseDataSnapshot.dataSnapshot(withSnapshot: dataSnapshot))
        }, withLocalEvents: withLocalEvents)
    }

    
}

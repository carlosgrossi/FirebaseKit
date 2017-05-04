//
//  FirebaseQuery.swift
//  FirebaseKit
//
//  Created by Carlos Grossi on 25/01/17.
//  Copyright © 2017 Carlos Grossi. All rights reserved.
//

import Foundation
import FirebaseDatabase

public struct FirebaseQuery {
    fileprivate var query:FIRDatabaseQuery
    
    fileprivate init(query:FIRDatabaseQuery) {
        self.query = query
    }
    
    static func databaseQuery(withQuery query:FIRDatabaseQuery?) -> FirebaseQuery? {
        guard let query = query else { return nil }
        return FirebaseQuery(query: query)
    }
}

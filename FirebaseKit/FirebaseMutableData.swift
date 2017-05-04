//
//  FirebaseMutableData.swift
//  FirebaseKit
//
//  Created by Carlos Grossi on 25/01/17.
//  Copyright © 2017 Carlos Grossi. All rights reserved.
//

import Foundation
import FirebaseDatabase

public struct FirebaseMutableData {
    fileprivate var mutableData:FIRMutableData
    
    fileprivate init(mutableData:FIRMutableData) {
        self.mutableData = mutableData
    }
    
    static func mutableData(withMutableData mutableData:FIRMutableData?) -> FirebaseMutableData? {
        guard let mutableData = mutableData else { return nil }
        return FirebaseMutableData(mutableData: mutableData)
    }
    
}

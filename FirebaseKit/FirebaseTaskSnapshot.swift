//
//  FirebaseTaskSnapshot.swift
//  FirebaseKit
//
//  Created by Carlos Grossi on 25/01/17.
//  Copyright © 2017 Carlos Grossi. All rights reserved.
//

import Foundation
import FirebaseStorage

public struct FirebaseTaskSnapshot {
    fileprivate var taskSnapshot:FIRStorageTaskSnapshot
    
    fileprivate init(taskSnapshot:FIRStorageTaskSnapshot) {
        self.taskSnapshot = taskSnapshot
    }
    
    static func taskSnapshot(withSnapshot taskSnapshot:FIRStorageTaskSnapshot?) -> FirebaseTaskSnapshot? {
        guard let taskSnapshot = taskSnapshot else { return nil }
        return FirebaseTaskSnapshot(taskSnapshot: taskSnapshot)
    }
}

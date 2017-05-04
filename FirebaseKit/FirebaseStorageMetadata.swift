//
//  FirebaseStorageMetadata.swift
//  FirebaseKit
//
//  Created by Carlos Grossi on 25/01/17.
//  Copyright © 2017 Carlos Grossi. All rights reserved.
//

import Foundation
import FirebaseStorage

public struct FirebaseStorageMetadata {
    var metadata:FIRStorageMetadata
    
    fileprivate init(metadata:FIRStorageMetadata) {
        self.metadata = metadata
    }
    
    static func storageMetadata(withMetadata metadata:FIRStorageMetadata?) -> FirebaseStorageMetadata? {
        guard let metadata = metadata else { return nil }
        return FirebaseStorageMetadata(metadata: metadata)
    }
}

// MARK: - Acessing Metadata
extension FirebaseStorageMetadata {
    
    public func downloadURL() -> URL? {
        return metadata.downloadURL()
    }
    
    public func downloadURLs() -> [URL]? {
        return metadata.downloadURLs
    }
    
    public func customMetadata() -> [String : String]? {
        return metadata.customMetadata
    }
    
    
}

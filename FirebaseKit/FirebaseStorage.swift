//
//  FirebaseStorage.swift
//  FirebaseKit
//
//  Created by Carlos Grossi on 25/01/17.
//  Copyright © 2017 Carlos Grossi. All rights reserved.
//

import Foundation
import FirebaseStorage

enum storageError:Error {
    case metadataError
}

public struct FirebaseStorage {
    public static var defaultStorage = FirebaseStorage()
    var storageReference:FIRStorageReference?
    
    init(url:String? = nil) {
        guard let url = url else { return }
        self.storageReference = FIRStorage.storage().reference(forURL: url)
    }
}

// MARK: - Setup Reference
extension FirebaseStorage {
    
    mutating public func setStorageReference(url:String) -> Void {
        storageReference = FIRStorage.storage().reference(forURL: url)
    }
    
}

// MARK: - Upload Files
extension FirebaseStorage {
    
    public func upload(fileData:Data, withMetadata fileMetadata:[AnyHashable:Any], toChild childPath:String, completion:((FirebaseStorageMetadata?, Error?) -> Void)?, observationBlock:((FirebaseTaskSnapshot?) -> Void)?) -> Void {
        let metadata = FIRStorageMetadata()
        metadata.customMetadata = fileMetadata as? [String:String]
        upload(fileData: fileData, withMetadata: FirebaseStorageMetadata.storageMetadata(withMetadata: metadata)!, toChild: childPath, completion: completion, observationBlock: observationBlock)
    }
    
    public func upload(fileData:Data, withMetadata fileMetadata:FirebaseStorageMetadata, toChild childPath:String, completion:((FirebaseStorageMetadata?, Error?) -> Void)?, observationBlock:((FirebaseTaskSnapshot?) -> Void)?) -> Void {
        storageReference?.child(childPath).put(fileData, metadata: fileMetadata.metadata, completion: { (metadata, error) in
            completion?(FirebaseStorageMetadata.storageMetadata(withMetadata: metadata), error)
        }).observe(.progress, handler: { (taskSnapshot) in
            observationBlock?(FirebaseTaskSnapshot.taskSnapshot(withSnapshot: taskSnapshot))
        })
    }
    
    public func upload(fileURL:URL, withMetadata fileMetadata:FirebaseStorageMetadata, toChild childPath:String, completion:((FirebaseStorageMetadata?, Error?) -> Void)?, observationBlock:((FirebaseTaskSnapshot?) -> Void)?) -> Void {
        storageReference?.child(childPath).putFile(fileURL, metadata: fileMetadata.metadata, completion: { (metadata, error) in
            completion?(FirebaseStorageMetadata.storageMetadata(withMetadata: metadata), error)
        }).observe(.progress, handler: { (taskSnapshot) in
            observationBlock?(FirebaseTaskSnapshot.taskSnapshot(withSnapshot: taskSnapshot))
        })
    }
    
}


// MARK: - Download Files
extension FirebaseStorage {
    
    public func download(fromChild childPath:String, withMaxSize maxSize:Int64, completion:@escaping (Data?, Error?)->Void, observationBlock:((FirebaseTaskSnapshot?) -> Void)?) -> Void {
        storageReference?.child(childPath).data(withMaxSize: maxSize, completion: completion).observe(.progress, handler: { (taskSnapshot) in
            observationBlock?(FirebaseTaskSnapshot.taskSnapshot(withSnapshot: taskSnapshot))
        })
    }
    
    public func download(fromChild childPath:String, toFile fileURL:URL, completion:((URL?, Error?)->Void)?, observationBlock:((FirebaseTaskSnapshot?) -> Void)?) -> Void {
        storageReference?.child(childPath).write(toFile: fileURL, completion: completion).observe(.progress, handler: { (taskSnapshot) in
            observationBlock?(FirebaseTaskSnapshot.taskSnapshot(withSnapshot: taskSnapshot))
        })
    }
    
}

// MARK: - Delete Files
extension FirebaseStorage {
    
    public func delete(child childPath:String, completion:((Error?)->Void)?) -> Void {
        storageReference?.child(childPath).delete(completion: completion)
    }
    
}

// MARK: - Get Metadata
extension FirebaseStorage {
    
    public func metadata(forChild childPath:String, completion:@escaping (FirebaseStorageMetadata?, Error?)->Void) -> Void {
        storageReference?.child(childPath).metadata(completion: { (metadata, error) in
            completion(FirebaseStorageMetadata.storageMetadata(withMetadata: metadata), error)
        })
    }
    
    public func updateMetadata(withNewMetadata fileMetadata:FirebaseStorageMetadata, completion:@escaping (FirebaseStorageMetadata?, Error?)->Void) -> Void {
        storageReference?.update(fileMetadata.metadata, completion: { (metadata, error) in
            completion(FirebaseStorageMetadata.storageMetadata(withMetadata: metadata), error)
        })
    }
    
}

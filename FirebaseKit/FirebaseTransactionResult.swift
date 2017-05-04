//
//  FirebaseTransactionResult.swift
//  FirebaseKit
//
//  Created by Carlos Grossi on 25/01/17.
//  Copyright © 2017 Carlos Grossi. All rights reserved.
//

import Foundation
import FirebaseDatabase

public struct FirebaseTransactionResult {
    var transactionResult:FIRTransactionResult
    
    fileprivate init(transactionResult:FIRTransactionResult) {
        self.transactionResult = transactionResult
    }
    
    static func transactionResult(withTransactionResult transactionResult:FIRTransactionResult?) -> FirebaseTransactionResult? {
        guard let transactionResult = transactionResult else { return nil }
        return FirebaseTransactionResult(transactionResult: transactionResult)
    }
}

// MARK: -
extension FirebaseTransactionResult {
    
    
}

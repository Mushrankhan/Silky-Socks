//
//  BlockObserver.swift
//  Silky Socks
//
//  Created by Saurabh Jain on 8/4/15.
//  Copyright © 2015 Full Stak. All rights reserved.
//

// Adopted from the code from WWDC 2015 - Advance NSOperations

import UIKit

class BlockObserver: OperationObserver {
    
    private let startHandler: (Operation -> Void)?
    private let produceHandler: ((Operation, NSOperation) -> Void)?
    private let finishHandler: ((Operation, [NSError]?) -> Void)?
    
    init(startHandler: (Operation -> Void)? = nil, produceHandler: ((Operation, NSOperation) -> Void)? = nil, finishHandler: ((Operation, [NSError]?) -> Void)? = nil) {
        self.startHandler = startHandler
        self.produceHandler = produceHandler
        self.finishHandler = finishHandler
    }
    
    func operationWillBegin(operation: Operation) {
        startHandler?(operation)
    }
    
    func operation(operation: Operation, didProduceOperation newOperation: NSOperation) {
        produceHandler?(operation, newOperation)
    }
    
    func operationDidFinish(operation: Operation, withErrors errors:[NSError]?) {
        finishHandler?(operation, errors)
    }
    
}

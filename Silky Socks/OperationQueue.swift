//
//  OperationQueue.swift
//  Silky Socks
//
//  Created by Saurabh Jain on 8/3/15.
//  Copyright © 2015 Full Stak. All rights reserved.
//

// Adopted from the code from WWDC 2015 - Advance NSOperations

import UIKit

class OperationQueue: NSOperationQueue {

    override func addOperation(op: NSOperation) {
        super.addOperation(op)
        if let op = op as? Operation {
            let observer = BlockObserver(produceHandler: { (_, operation) -> Void in
                self.addOperation(operation)
            })
            op.addObserver(observer)
            
            op.willEnqueue()
        }
    }
}

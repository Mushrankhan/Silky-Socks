//
//  OperationObserver.swift
//  Silky Socks
//
//  Created by Saurabh Jain on 8/3/15.
//  Copyright © 2015 Full Stak. All rights reserved.
//

import Foundation

protocol OperationObserver {
    func operationWillBegin(operation: Operation)
    func operation(operation: Operation, didProduceOperation newOperation: NSOperation)
    func operationDidFinish(operation: Operation, withErrors errors:[NSError]?)
}


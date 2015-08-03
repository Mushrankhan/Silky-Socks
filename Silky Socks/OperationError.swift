//
//  OperationError.swift
//  Silky Socks
//
//  Created by Saurabh Jain on 8/3/15.
//  Copyright © 2015 Full Stak. All rights reserved.
//

import Foundation

let OperationConditionErrorDomain = "OperationConditionErrorDomain"

extension NSError {
    convenience init(code: OperationErrorCode, userInfo: [NSObject: AnyObject]? = nil){
        self.init(domain: OperationConditionErrorDomain, code: code.rawValue, userInfo: userInfo)
    }
}

enum OperationConditionResult {
    case Satisfied
    case Error(NSError)
}

enum OperationErrorCode: Int {
    case ConditionFailed = 1
}
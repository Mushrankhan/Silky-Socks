//
//  OperationCondition.swift
//  Silky Socks
//
//  Created by Saurabh Jain on 8/3/15.
//  Copyright © 2015 Full Stak. All rights reserved.
//

import Foundation

protocol OperationCondition {
    
    func evaluateCondition(block: OperationConditionResult -> Void)
}
//
//  NetworkCondition.swift
//  Silky Socks
//
//  Created by Saurabh Jain on 8/3/15.
//  Copyright © 2015 Full Stak. All rights reserved.
//

import Foundation
import SystemConfiguration

class NetworkCondition: OperationCondition {
    
    // URL to check for reachibilty
    private let url: NSURL
    
    init(url: NSURL) {
        self.url = url
    }
    
    //MARK: OperationCondition Protocol
    
    func evaluateCondition(block: OperationConditionResult -> Void) {
        
        guard let host = url.host else {
            block(.Error(NSError(code: .ConditionFailed)))
            return
        }
        
        let str = host as NSString
        let reachibilty = SCNetworkReachabilityCreateWithName(kCFAllocatorDefault, str.UTF8String)
        if let reachibilty = reachibilty {
            var flags = SCNetworkReachabilityFlags()
            if SCNetworkReachabilityGetFlags(reachibilty, &flags) != 0 {
                if flags.contains(.Reachable) {
                    block(.Satisfied)
                    return
                }
            }
        }
        
        block(.Error(NSError(code: .ConditionFailed)))
    }
}

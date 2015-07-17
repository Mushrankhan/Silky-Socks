//
//  Order.swift
//  Silky Socks
//
//  Created by Saurabh Jain on 6/29/15.
//  Copyright (c) 2015 Saurabh Jain. All rights reserved.
//

import UIKit

class Order: PFObject, PFSubclassing {
   
    class func parseClassName() -> String {
        return "Orders"
    }
    
    @NSManaged var name: String!
    @NSManaged var email: String!
    @NSManaged var price: NSDecimalNumber!
    @NSManaged var address: String!
    @NSManaged var file: PFFile!
}

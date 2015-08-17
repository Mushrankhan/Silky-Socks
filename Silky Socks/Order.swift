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
    
    @NSManaged var orderId: NSNumber!
    @NSManaged var name: String!
    @NSManaged var email: String!
    @NSManaged var price: NSDecimalNumber!
    @NSManaged var address: String!
    
    // File one
    @NSManaged var file1: PFFile!
    @NSManaged var mockup1: PFFile!
    
    // File two
    @NSManaged var file2: PFFile!
    @NSManaged var mockup2: PFFile!

    // File three
    @NSManaged var file3: PFFile!
    @NSManaged var mockup3: PFFile!

}

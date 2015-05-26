//
//  UserCart.swift
//  Silky Socks
//
//  Created by Saurabh Jain on 5/26/15.
//  Copyright (c) 2015 Full Stak. All rights reserved.
//

import UIKit

class UserCart: NSObject {
   
    // User Cart
    private var cart = [Template]()
    
    // Singleton support
    class func sharedCart() -> UserCart {
        struct Singleton {
            static let sharedInstance = UserCart()
        }
        return Singleton.sharedInstance
    }
    
    // Add Product
    func addProduct(template: Template) {
        
    }
    
    // Remove Product
    func removeProduct(template: Template) {
        
    }
}

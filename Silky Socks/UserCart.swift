//
//  UserCart.swift
//  Silky Socks
//
//  Created by Saurabh Jain on 5/26/15.
//  Copyright (c) 2015 Full Stak. All rights reserved.
//

import UIKit

/*! 
    @class          User Cart Class
    @abstract       Used to encapsulate the cart system
    @description    Singleton support, becuase every user can have only one cart

*/
class UserCart: NSObject {
   
    // Singleton support
    static let sharedCart = UserCart()
    
    // User Cart
    private var cart = [Template]()
    
    // Add Product
    func addProduct(template: Template, snapshot: UIImage) {
        
    }
    
    // Remove Product
    func removeProduct(template: Template) {
        
    }
}

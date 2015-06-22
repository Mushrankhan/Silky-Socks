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
   
    struct UserCartNotifications {
        static let AddToCartNotification = "AddToCartNotification"
    }
    
    // Singleton support
    static let sharedCart = UserCart()
    
    // User Cart
    var cart = [CartProduct]()
    
    var numberOfItems: Int {
        return cart.count
    }
    
    // Add Product
    func addProduct(template: CartProduct) {

        for (_, product) in enumerate(cart) {
            if product == template {
                ++product.quantity
                return
            }
        }
        
        cart.append(template)
        
        // Post notification
        NSNotificationCenter.defaultCenter().postNotificationName(UserCartNotifications.AddToCartNotification, object: nil)
    }
    
    // Remove Product
    func removeProduct(template: CartProduct) {
        for (index , product) in enumerate(cart) {
            if product == template {
                cart.removeAtIndex(index)
                return
            }
        }
    }
}

//
//  UserCart.swift
//  Silky Socks
//
//  Created by Saurabh Jain on 5/26/15.
//  Copyright (c) 2015 Saurabh Jain. All rights reserved.
//

import UIKit


// Notifications, which classes can subscribe to
struct UserCartNotifications {
    static let AddToCartNotification = "AddToCartNotification"
    static let BoughtProductNotification = "BoughtProductNotification"
}

/*! 
    @class          User Cart Class
    @abstract       Used to encapsulate the cart system
    @description    Singleton support, becuase every user can have only one cart

*/
class UserCart: NSObject {
    
    // Singleton support
    static let sharedCart = UserCart()
    
    // User Cart
    private var cart = [CartProduct]()
    
    // Override the subscript operator: []
    subscript(index: Int) -> CartProduct? {
        return cart[index]
    }
    
    var numberOfItems: Int {
        return cart.count
    }
    
    // Add Product
    func addProduct(template: CartProduct) {
        cart.append(template)
        NSNotificationCenter.defaultCenter().postNotificationName(UserCartNotifications.AddToCartNotification, object: nil)
    }
    
    // Remove the item at a particular index
    func removeProductAtIndex(index: Int) {
        cart.removeAtIndex(index)
    }
    
    // When a product is bought
    func boughtProduct() {
        cart.removeAtIndex(0)
        NSNotificationCenter.defaultCenter().postNotificationName(UserCartNotifications.BoughtProductNotification, object: nil)
    }
}

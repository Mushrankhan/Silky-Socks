//
//  UserCart.swift
//  Silky Socks
//
//  Created by Saurabh Jain on 5/26/15.
//  Copyright (c) 2015 Saurabh Jain. All rights reserved.
//

import UIKit

// Notifications, which classes can subscribe to
internal let kAddToCartNotification = "AddToCartNotification"
internal let kBoughtProductNotification = "BoughtProductNotification"

/*! 
    @class          User Cart Class
    @abstract       Used to encapsulate the cart system
    @description    Singleton support, becuase every user can have only one cart

*/
class UserCart: NSObject {
    
    private struct Constant {
        static let MaximumSize = 3
    }
    
    // Singleton support
    static let sharedCart = UserCart()
    
    private override init() {
        // So that creating an instance is not possible
    }
    
    // User Cart
    private(set) var cart = [CartProduct]()
    
    // Override the subscript operator: []
    subscript(index: Int) -> CartProduct? {
        return cart[index]
    }
    
    var numberOfItems: Int {
        return cart.count
    }
    
    // Add Product
    func addProduct(template: CartProduct) throws {
        if numberOfItems >= Constant.MaximumSize {
            throw CartError.MaxItemsReached(Constant.MaximumSize)
        }
        cart.append(template)
        NSNotificationCenter.defaultCenter().postNotificationName(kAddToCartNotification, object: nil)
    }
    
    // Remove the item at a particular index
    func removeProductAtIndex(index: Int) {
        cart.removeAtIndex(index)
    }
    
    // When a product is bought
    func boughtProduct() {
        cart.removeAll()
        NSNotificationCenter.defaultCenter().postNotificationName(kBoughtProductNotification, object: nil)
    }
}

enum CartError: ErrorType {
    case MaxItemsReached(Int)
}


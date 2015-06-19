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
   
    internal struct UserCartNotifications {
        static let AddToCartNotification = "Add"
    }
    
    // Singleton support
    static let sharedCart = UserCart()
    
    // User Cart
    private var cart = [CartProduct]()
    
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
        
    }
}

/*!
    @class          CartProduct
    @abstract       Represents an item in the cart
    @description    An instance of the CartProduct Class is used to be stored
                    in the UserCart
*/
class CartProduct: NSObject, Printable, Equatable {
    
    var productImage: UIImage
    var name: String
    var price: Float
    var quantity: Int
    
    init(name: String, productImage: UIImage, price: Float) {
        
        self.name = name
        self.productImage = productImage
        self.price = price
        self.quantity = 1
        
    }
    
    convenience init(template: Template, withImage image: UIImage) {
        self.init(name: template.infoCaption, productImage: image, price: template.price)
    }
    
    // Printable
    override var description: String {
        return "Name: " + name + "\n" + "Price: \(price)\n" + "Quantity: \(quantity)\n"
    }
    
}

// MARK: Equatable
func ==(lhs: CartProduct, rhs: CartProduct) -> Bool {
    return (lhs.name == rhs.name && lhs.price == rhs.price && lhs.productImage == rhs.productImage)
}

//
//  CartProduct.swift
//  Silky Socks
//
//  Created by Saurabh Jain on 6/22/15.
//  Copyright (c) 2015 Full Stak. All rights reserved.
//

import UIKit

/*!
    @class          CartProduct
    @abstract       Represents an item in the cart
    @description    An instance of the CartProduct Class is used to be stored
                    in the UserCart
*/
class CartProduct: NSObject, Printable, Equatable {
    
    // Image
    private(set) var productImage: UIImage
    
    // Name
    private(set) var name: String
    
    // The product id used to grab the product from Shopify
    private(set) var productID: String
    
    // The Type of the product
    private(set) var productType: TemplateType!
    
    // The base price changes with the change in quantity
    // Computed property
    var basePrice: Float {
        switch quantity {
            case 1...11:
                return prices[0]
            case 12...23:
                return prices[1]
            default:
                return prices[2]
        }
    }
    
    // Storing all the prices
    // The base price consisit of prices in the array
    private var prices: [Float]
    
    // The current quantity
    // If quantity changes, then change the price
    var quantity: Int {
        didSet {
            price = Float(quantity) * basePrice
        }
    }
    
    // The current price
    private(set) var price: Float
    
    init(name: String, productImage: UIImage, prices: [Float], productID: String, type: TemplateType) {
        
        self.name = name
        self.productImage = productImage
        self.prices = prices
        self.quantity = 1
        self.price = prices[0]
        self.productID = productID
        self.productType = type
        
    }
    
    convenience init(template: Template, withImage image: UIImage) {
        self.init(name: template.infoCaption, productImage: image, prices: template.prices, productID: template.productId, type: template.type)
    }
    
    // Printable
    override var description: String {
        return "Name: " + name + "\n" + "Price: \(prices)\n" + "Quantity: \(quantity)\n"
    }
    
}

// MARK: Equatable
func ==(lhs: CartProduct, rhs: CartProduct) -> Bool {
    return (lhs.name == rhs.name && lhs.productImage == rhs.productImage)
}


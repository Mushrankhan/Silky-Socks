//
//  CartProduct.swift
//  Silky Socks
//
//  Created by Saurabh Jain on 6/22/15.
//  Copyright (c) 2015 Saurabh Jain. All rights reserved.
//

import UIKit

/*!
    @class          CartProduct
    @abstract       Represents an item in the cart
    @description    An instance of the CartProduct Class is used to be stored
                    in the UserCart
*/
class CartProduct: NSObject {
    
    // MARK: - Properties
    
    // Image in small size
    private(set) var productImage: UIImage
    
    // Image sent to Parse when the user checks out
    var checkoutImage: UIImage?
    
    // Image displayed in app
    var cartImage: UIImage!

    private(set) var name: String // Name
    private(set) var productID: String // Shopify product id
    private(set) var productType: TemplateType! // Product type
    
    private(set) var productSize: CGSize // Size in which to be printed
    private(set) var sizesAvailable: [String]
    
    // The base price changes with the change in quantity
    // Computed property
    var basePrice: NSDecimalNumber {
//        switch quantity {
//            case 1...11:
//                return prices[0]
//            case 12...23:
//                return prices[1]
//            default:
//                return prices[2]
//        }
        return prices[0]
    }
    
    // Storing all the prices
    // The base price consists of prices in the array
    private var prices: [NSDecimalNumber]
    
    // The current quantity
    // If quantity changes, then change the price
    var quantity: Int {
        didSet {
            price = NSDecimalNumber(integer: quantity).decimalNumberByMultiplyingBy(basePrice)
        }
    }
    
    // The current price
    private(set) var price: NSDecimalNumber
    
    
    // MARK: - Init
    
    init(name: String, productImage: UIImage, prices: [NSDecimalNumber], productID: String, type: TemplateType, size: CGSize, sizesAvailable: [String]){
        
        self.name = name
        self.productImage = productImage
        self.prices = prices
        self.quantity = 1
        self.price = prices[0]
        self.productID = productID
        self.productType = type
        self.productSize = size
        self.sizesAvailable = sizesAvailable
    }
    
    convenience init(template: Template, withImage image: UIImage) {
        self.init(name: template.infoCaption, productImage: image, prices: template.prices, productID: template.productId, type: template.type, size: template.productSize, sizesAvailable: template.availabilitySizes)
    }
    
    override var description: String {
        return "Name: " + name + "\n" + "Price: \(prices)\n" + "Quantity: \(quantity)\n"
    }
    
}

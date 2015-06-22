//
//  ShopifyUtilities.swift
//  Silky Socks
//
//  Created by Saurabh Jain on 6/22/15.
//  Copyright (c) 2015 Full Stak. All rights reserved.
//

import Foundation

extension BUYCart: Printable {
    
    func addProduct(product: CartProduct) {
        
        let buyProduct = BUYLineItem()
        buyProduct.title = product.name
        buyProduct.quantity = NSDecimalNumber(integer: product.quantity)
        buyProduct.price = NSDecimalNumber(float: product.basePrice)
        buyProduct.requiresShipping = 1
        addLineItemsObject(buyProduct)
    }
    
    override public var description: String {
        return "Items: \(lineItems)\n" + "Is Valid: \(isValid())"
    }
}
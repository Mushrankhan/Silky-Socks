//
//  ShopifyUtilities.swift
//  Silky Socks
//
//  Created by Saurabh Jain on 6/22/15.
//  Copyright (c) 2015 Saurabh Jain. All rights reserved.
//

import Foundation

// Shopify Details
struct Shopify {
    static let ShopDomain = "ssa-store.myshopify.com"
    static let ApiKey = "8215b08c21b4759e3b0758e54d1d7c40"
    static let ChannelId = "12734081"
    static let ApplePayMerchantId = "merchant.com.danny-silkysocks"
}

extension BUYCart {
    
    func addProduct(product: CartProduct, withVariant variant: BUYProductVariant) {
        
//        let buyProduct = BUYLineItem(variant: variant)
//        buyProduct.title = product.name
//        buyProduct.quantity = NSDecimalNumber(integer: product.quantity)
//        buyProduct.price = product.basePrice
//        buyProduct.requiresShipping = variant.requiresShipping
//        addLineItemsObject(buyProduct)
        
        for _ in 0..<product.quantity {
            addVariant(variant)
        }
    }
    
    override public var description: String {
        return "Items: \(lineItems)\n" + "Is Valid: \(isValid())"
    }
}

extension BUYClient {
    class func sharedClient() -> BUYClient {
        struct Singleton {
            static let sharedClient = BUYClient(shopDomain: Shopify.ShopDomain, apiKey: Shopify.ApiKey, channelId: Shopify.ChannelId)
        }
        return Singleton.sharedClient
    }
}

extension BUYAddress {
    func isValid() -> Bool {
        return firstName != nil && firstName.parseString().characters.count > 0 && lastName != nil && lastName.parseString().characters.count > 0 && address1 != nil && address1.parseString().characters.count > 2 && city != nil && city.parseString().characters.count > 0 && province.characters.count == 2 && zip != nil && zip.characters.count == 5
    }
    
    func getAddress() -> String {
        return address1 + " " + address2 + " " + city + " " + province + " " + zip + " " + countryCode
    }
}

extension BUYCreditCard {
    func isValid() -> Bool {
        return number != nil && number.characters.count == 16 && expiryMonth != nil && expiryMonth.characters.count == 2 && expiryYear != nil && expiryYear.characters.count == 4 && cvv != nil && cvv.characters.count == 3
    }
}

//
//  ShopifyUtilities.swift
//  Silky Socks
//
//  Created by Saurabh Jain on 6/22/15.
//  Copyright (c) 2015 Full Stak. All rights reserved.
//

import Foundation


// Shopify Details
struct Shopify {
    static let ShopDomain = "ssa-store.myshopify.com"
    static let ApiKey = "8215b08c21b4759e3b0758e54d1d7c40"
    static let ChannelId = "12734081"
    static let ApplePayMerchantId = "merchant.com.danny-silkysocks"
}


extension BUYCart: Printable {
    
    func addProduct(product: CartProduct, withVariant variant: BUYProductVariant) {
        
        let buyProduct = BUYLineItem(variant: variant)
        buyProduct.title = product.name
        buyProduct.quantity = NSDecimalNumber(integer: product.quantity)
        buyProduct.price = NSDecimalNumber(float: product.basePrice)
        buyProduct.requiresShipping = variant.requiresShipping
        addLineItemsObject(buyProduct)
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
        return firstName != nil && count(firstName.parseString()) > 0 && lastName != nil && count(lastName.parseString()) > 0 && address1 != nil && count(address1.parseString()) > 2 && city != nil && count(city.parseString()) > 0 && count(province) == 2 && zip != nil && count(zip) == 5
    }
    
    func getAddress() -> String {
        
        let address = address1 + " " + address2 + " " + city + " " + province + " " + zip + " " + countryCode
        println(address)
        return address
    }
}

extension BUYCreditCard {
    
    func isValid() -> Bool {
        return number != nil && count(number) == 16 && expiryMonth != nil && count(expiryMonth) == 2 && expiryYear != nil && count(expiryYear) == 4 && cvv != nil && count(cvv) == 3
    }
    
}

//
//  ShopifyUtilities.swift
//  Silky Socks
//
//  Created by Saurabh Jain on 6/22/15.
//  Copyright (c) 2015 Full Stak. All rights reserved.
//

import Foundation

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

// Shopify Details
struct Shopify {
    static let ShopDomain = "ssa-store.myshopify.com"
    static let ApiKey = "8215b08c21b4759e3b0758e54d1d7c40"
    static let ChannelId = "12734081"
    static let ApplePayMerchantId = "merchant.com.saurabhjain"
}

extension BUYClient {
    
    class func sharedClient() -> BUYClient {
        struct Singleton {
            static let sharedClient = BUYClient(shopDomain: Shopify.ShopDomain, apiKey: Shopify.ApiKey, channelId: Shopify.ChannelId)
        }
        return Singleton.sharedClient
    }
}
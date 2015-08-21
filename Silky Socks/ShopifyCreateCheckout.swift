//
//  ShopifyCreateCheckout.swift
//  Silky Socks
//
//  Created by Saurabh Jain on 8/3/15.
//  Copyright © 2015 Full Stak. All rights reserved.
//

import UIKit

class ShopifyCreateCheckout: Operation {
    
    private let client: BUYClient
    private let cart: BUYCart
    private let address: BUYAddress?
    private let email: String?
    private let handler: (BUYCheckout, NSError?) -> Void
    
    init(client: BUYClient, cart: BUYCart, address: BUYAddress, email: String, handler: (BUYCheckout, NSError?) -> Void) {
        self.client = client
        self.cart = cart
        self.address = address
        self.email = email
        self.handler = handler
        super.init()
    }
    
    override func execute() {
        
        // Create Checkout
        let checkout = BUYCheckout(cart: cart)
        
        if let address = address, email = email {
            checkout.shippingAddress = address
            checkout.billingAddress = address
            checkout.email = email
        }
        
        client.createCheckout(checkout) { [weak self] (checkout, error) -> Void in
            if error != nil {
                self?.finishWithError(error)
            } else {
                self?.handler(checkout, error)
                self?.finish()
            }
        }
    }

    override func finished(errors: [NSError]) {
        if !errors.isEmpty {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                SVProgressHUD.dismiss()
            })
            let operation = AlertOperation(title: "Error creating Checkout", message: "Make sure that you are connected to the internet")
            operation.showSweetAlert = true
            produceOperation(operation)
        }
    }
}

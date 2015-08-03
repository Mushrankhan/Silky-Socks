//
//  ShopifyGetShippingRate.swift
//  Silky Socks
//
//  Created by Saurabh Jain on 8/4/15.
//  Copyright © 2015 Full Stak. All rights reserved.
//

import UIKit

class ShopifyGetShippingRate: Operation {

    private let checkout: BUYCheckout
    private let client: BUYClient
    private let handler: [BUYShippingRate] -> Void
    
    init(client: BUYClient, checkout: BUYCheckout, handler: [BUYShippingRate] -> Void) {
        self.checkout = checkout
        self.client = client
        self.handler = handler
        super.init()
    }
    
    override func execute() {
        client.getShippingRatesForCheckout(checkout) { [weak self] (rates, status, error) in
            if error != nil {
                self?.finishWithError(error)
            } else {
                self?.handler(rates as! [BUYShippingRate])
                self?.finish()
            }
        }
    }
    
    override func finished(errors: [NSError]) {
        if !errors.isEmpty {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                SVProgressHUD.dismiss()
            })
            let operation = AlertOperation(title: "Error Getting Shipping Rates", message: "Make sure that you are connected to the internet")
            operation.showSweetAlert = true
            produceOperation(operation)
        }
    }
}

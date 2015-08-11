//
//  ShopifyGetProduct.swift
//  Silky Socks
//
//  Created by Saurabh Jain on 8/3/15.
//  Copyright © 2015 Full Stak. All rights reserved.
//

import UIKit

class ShopifyGetProduct: Operation {

    // MARK: Properties
    
    private var client: BUYClient
    private var id: [String]
    private var handler: ([BUYProduct]?, NSError?) -> Void
    
    init(client: BUYClient, productId: [String], handler: ([BUYProduct]?, NSError?) -> Void) {
        self.client = client
        self.id = productId
        self.handler = handler
        super.init()
        
        // Add a condition
        addCondition(NetworkCondition(url: NSURL(string: "http://www.google.com")!))
    }
    
    override func execute() {
        client.getProductsByIds(id) { [weak self] (products, error) in
            print(products)
            self?.handler(products as? [BUYProduct], error)
            self?.finish()
        }
    }
    
    override func finished(errors: [NSError]) {
        if !errors.isEmpty {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                SVProgressHUD.dismiss()
            })
            let operation = AlertOperation(title: "Network Error", message: "Make sure that you are connected to the internet")
            operation.showSweetAlert = true
            produceOperation(operation)
        }
    }
    
}

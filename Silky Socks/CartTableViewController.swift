//
//  CartTableViewController.swift
//  Silky Socks
//
//  Created by Saurabh Jain on 6/19/15.
//  Copyright (c) 2015 Saurabh Jain. All rights reserved.
//

import UIKit
import PassKit

class CartTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, PKPaymentAuthorizationViewControllerDelegate {

    lazy private var products: [CartProduct] = {
        return UserCart.sharedCart.cart
    }()
    
    // Table View outlet
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            // Essential
            tableView.dataSource = self
            tableView.delegate = self
            
            // Row height
            tableView.rowHeight = 160
            tableView.contentInset.top = 64;
        }
    }
    
    // Cart Check Out Button
    @IBOutlet weak var checkOutButton: UIButton!
    
    // Cart Empty Label
    private var cartEmptyLabel: UILabel!
    
    // Number of items in the cart
    var numberOfItemsInCart: Int {
        return UserCart.sharedCart.numberOfItems
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Title
        navigationItem.title = "Cart"
        
        // Register Cell
        tableView.registerNib(CartTableViewCell.nib(), forCellReuseIdentifier: cartCellReuseIdentifier)
        
        // Hide unwanted cells
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        // When a product is bought, then reload the table
        NSNotificationCenter.defaultCenter().addObserverForName(kBoughtProductNotification, object: nil, queue: NSOperationQueue.mainQueue()) { [weak self] _ in
            self?.tableView.reloadData()
            self?.tableView.tableHeaderView = self?.numberOfItemsInCart == 0 ? self?.cartEmptyLabel : nil
            UIView.animateWithDuration(0.5) {
                self?.checkOutButton.alpha = 0
            }
        }
        
        // Set up the empty cart label
        cartEmptyLabel = UILabel(frame: tableView.bounds)
        cartEmptyLabel.text = "Cart is Empty"
        cartEmptyLabel.textAlignment = .Center
        cartEmptyLabel.font = UIFont(name: "HelveticaNeue-Light", size: 48)
        
        // Header view
        tableView.tableHeaderView = numberOfItemsInCart == 0 ? cartEmptyLabel : nil
        
        // Show the alpha button
        checkOutButton.alpha = 1
        
        // Edit Button
        navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }

    // MARK: - Table view data source

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfItemsInCart
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cartCellReuseIdentifier, forIndexPath: indexPath) as! CartTableViewCell
        cell.cartProduct = products[indexPath.row]
        return cell
    }

    // MARK: - Table View Delegate
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            UserCart.sharedCart.removeProductAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
            // if the number of items after deletion comes to be 0,
            // then show the label
            if numberOfItemsInCart == 0 {
                tableView.tableHeaderView = cartEmptyLabel
                // Hide the check out button
                UIView.animateWithDuration(0.5) { [unowned self] in
                    self.checkOutButton.alpha = 0
                }
            }
        }
    }
    
    // MARK: - Navigation
    
    private struct Storyboard {
        static let CheckoutSegue = "CheckoutSegue"
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Storyboard.CheckoutSegue {
            let vc = segue.destinationViewController as! CheckoutViewController
            vc.products = UserCart.sharedCart.cart
        }
    }
    
    // MARK: - Apple Pay
    
    var applePayhelper: BUYApplePayHelpers?
    
    @IBAction func applePayCheckout(sender: UIButton) {
        
        let paymentNetworks = [PKPaymentNetworkAmex, PKPaymentNetworkMasterCard, PKPaymentNetworkVisa]
        if PKPaymentAuthorizationViewController.canMakePaymentsUsingNetworks(paymentNetworks) {
            
            // Create Checkout
            
            let client = BUYClient.sharedClient()
            let queue = OperationQueue()
            
            SVProgressHUD.showWithStatus("Creating Order");
            let products = ShopifyGetProduct(client: client, productId: UserCart.sharedCart.cart.map {$0.productID}, handler: { (products, error) in
                
                guard let products = products else {
                    let operation = AlertOperation(title: "Something Went Wrong", message: "Please try again later")
                    operation.showSweetAlert = true
                    queue.addOperation(operation)
                    return
                }
                
                // Get Variant
                let variants = (products.map {$0.variants as! [BUYProductVariant]} as [[BUYProductVariant]]).reverse()

                
                if variants.count > 0 {
                    
                    var variant = [BUYProductVariant]()
                    
                    for (index, v) in variants.enumerate() {
                        variant.append(v[(self.products[index].selectedSize!).1])
                    }
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        // Create Cart and add product
                        let cart = BUYCart()
                        
                        if self.products.count > variant.count {
                            var dic = [String: BUYProductVariant]()
                            for (index , product) in self.products.enumerate() {
                                if let _ = dic[product.productID] {
                                    
                                } else {
                                    dic[product.productID] = variant[index]
                                }
                            }
                            
                            for product in self.products {
                                cart.addProduct(product, withVariant: dic[product.productID]!)
                            }
                            
                        } else {
                            for (index, v) in variant.enumerate() {
                                cart.addProduct(self.products[index], withVariant: v)
                            }
                        }
                        
                        var checkout = BUYCheckout(cart: cart)
                        
                        client.createCheckout(checkout, completion: { (acheckout, error) -> Void in
                            
                            checkout = acheckout
                            
                            self.applePayhelper = BUYApplePayHelpers(client: client, checkout: checkout)
                            
                            let request = PKPaymentRequest()
                            request.supportedNetworks = [PKPaymentNetworkAmex, PKPaymentNetworkMasterCard, PKPaymentNetworkVisa]
                            request.countryCode = "US"
                            request.currencyCode = "USD"
                            request.merchantIdentifier = "merchant.com.danny-silkysocks"
                            request.merchantCapabilities = .Capability3DS
                            request.requiredShippingAddressFields = .All
                            
                            for product in self.products {
                                let item = PKPaymentSummaryItem(label: product.name, amount: product.price)
                                request.paymentSummaryItems.append(item)
                            }
                            
                            let total = PKPaymentSummaryItem(label: "Silky Socks", amount: checkout.totalPrice)
                            request.paymentSummaryItems.append(total)
                            
                            let viewController = PKPaymentAuthorizationViewController(paymentRequest: request)
                            viewController.delegate = self
                            self.presentViewController(viewController, animated: true, completion: nil)
                            
                            SVProgressHUD.dismiss()

                        })
                        
                    }
                    
                }

            })
            
            queue.addOperation(products)
            
        }
    }
    
    
    func paymentAuthorizationViewController(controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: (PKPaymentAuthorizationStatus) -> Void) {
        
    }
    
    func paymentAuthorizationViewControllerDidFinish(controller: PKPaymentAuthorizationViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func paymentAuthorizationViewControllerWillAuthorizePayment(controller: PKPaymentAuthorizationViewController) {
        
    }

    func paymentAuthorizationViewController(controller: PKPaymentAuthorizationViewController, didSelectShippingMethod shippingMethod: PKShippingMethod, completion: (PKPaymentAuthorizationStatus, [PKPaymentSummaryItem]) -> Void) {
        self.applePayhelper?.updateCheckoutWithShippingMethod(shippingMethod, completion: { (status, items) -> Void in
            completion(status, items as! [PKPaymentSummaryItem])
        })
    }
    
    func paymentAuthorizationViewController(controller: PKPaymentAuthorizationViewController, didSelectShippingAddress address: ABRecord, completion: (PKPaymentAuthorizationStatus, [PKShippingMethod], [PKPaymentSummaryItem]) -> Void) {
        self.applePayhelper?.updateCheckoutWithAddress(address, completion: { (status, shipping, summary) -> Void in
            print(shipping)
            print(summary)
            completion(status, shipping as! [PKShippingMethod], summary as! [PKPaymentSummaryItem])
        })
    }

    
}

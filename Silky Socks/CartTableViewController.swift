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

    private var products: [CartProduct] {
        return UserCart.sharedCart.cart
    }
    
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
    
    @IBOutlet weak var paymentOptionsView: UIView!
    
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
            UIView.animateWithDuration(0.3) {
                self?.paymentOptionsView.alpha = 0
            }
        }
        
        // Set up the empty cart label
        cartEmptyLabel = UILabel(frame: tableView.bounds)
        cartEmptyLabel.text = "Cart is Empty"
        cartEmptyLabel.textAlignment = .Center
        cartEmptyLabel.textColor = UIColor.getColor(red: 20, green: 20, blue: 20, alpha: 1)
        if #available(iOS 9.0, *) {
            cartEmptyLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleTitle1)
        } else {
            // Fallback on earlier versions
            cartEmptyLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        }
        
        // Header view
        tableView.tableHeaderView = numberOfItemsInCart == 0 ? cartEmptyLabel : nil
        
        // Show the alpha button
        paymentOptionsView.alpha = 1
        
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
                UIView.animateWithDuration(0.3) { [unowned self] in
                    self.paymentOptionsView.alpha = 0
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
    
    private struct ApplePay {
        static let Identifier = "merchant.com.danny-silkysocks"
    }
    
    private var applePayhelper: BUYApplePayHelpers?
    private var checkout: BUYCheckout?
    
    private lazy var request: PKPaymentRequest = {
        let request = PKPaymentRequest()
        request.supportedNetworks = [PKPaymentNetworkAmex, PKPaymentNetworkMasterCard, PKPaymentNetworkVisa]
        request.countryCode = "US"
        request.currencyCode = "USD"
        request.merchantIdentifier = ApplePay.Identifier
        request.merchantCapabilities = .Capability3DS
        request.requiredShippingAddressFields = .All
        request.requiredBillingAddressFields = .All
        return request
    }()
    
    @IBAction func applePayCheckout(sender: UIButton) {
        
        let paymentNetworks = [PKPaymentNetworkAmex, PKPaymentNetworkMasterCard, PKPaymentNetworkVisa]
        if PKPaymentAuthorizationViewController.canMakePayments() && PKPaymentAuthorizationViewController.canMakePaymentsUsingNetworks(paymentNetworks) {
            
            // Create Checkout
            let client = BUYClient.sharedClient()
            let queue = OperationQueue()
            SVProgressHUD.showWithStatus("Creating Order")
            
            // Fetch Products
            let products = ShopifyGetProduct(client: client, productId: UserCart.sharedCart.cart.map {$0.productID}, handler: { (products, error) in
                
                guard let products = products else {
                    SVProgressHUD.dismiss()
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
                        
                        // Create checkout
                        self.checkout = BUYCheckout(cart: cart)
                        client.createCheckout(self.checkout, completion: { (acheckout, error) -> Void in
                            
                            if error != nil {
                                SVProgressHUD.dismiss()
                                let operation = AlertOperation(title: "Error Checking Out", message: "Please try again later")
                                operation.showSweetAlert = true
                                queue.addOperation(operation)
                                return
                            }
                            
                            self.checkout = acheckout
                            self.applePayhelper = BUYApplePayHelpers(client: client, checkout: self.checkout)
                            self.request.paymentSummaryItems = self.checkout?.buy_summaryItems() as! [PKPaymentSummaryItem]
                            
                            // Create and present the Apple Pay view controller
                            let viewController = PKPaymentAuthorizationViewController(paymentRequest: self.request)
                            viewController.delegate = self
                            self.presentViewController(viewController, animated: true, completion: nil)
                            
                            SVProgressHUD.dismiss()
                        })
                    }
                }
            })
            
            queue.addOperation(products)
            
        } else {
            // Apple pay not supported
            let action = UIAlertAction(title: "Dismiss", style: .Cancel, handler: nil)
            let sheet = UIAlertController(title: "Apple Pay Not Supported", message: nil, preferredStyle: .Alert)
            sheet.addAction(action)
            presentViewController(sheet, animated: true, completion: nil)
        }
    }
     
    // Complete transaction
    func paymentAuthorizationViewController(controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: (PKPaymentAuthorizationStatus) -> Void) {
        
        let shippingAddress = BUYAddress.buy_addressFromRecord(payment.shippingAddress)
        
        let order = Order()
        order.orderId = checkout!.orderId
        order.name = shippingAddress.firstName + " " + shippingAddress.lastName
        order.email = BUYAddress.buy_emailFromRecord(payment.shippingAddress)
        order.price = checkout!.totalPrice
        order.address = shippingAddress.getAddress()
        
        for product in products {
            product.checkoutImage = product.productImage.renderImageIntoSize(product.productSize)
        }
        
        for (index, product) in products.enumerate() {
            order["file\(index+1)"] = PFFile(data: UIImageJPEGRepresentation(product.productImage, 0.5)!)
            order["mockup\(index+1)"] = PFFile(data: UIImageJPEGRepresentation(product.cartImage, 0.5)!)
        }
        
        order.saveInBackgroundWithBlock { (success, error) -> Void in
            if success {
                self.applePayhelper?.updateAndCompleteCheckoutWithPayment(payment) { status in
                    completion(status)
                    if status == .Success {
                        UserCart.sharedCart.boughtProduct()
                    }
                }
            } else {
                print("Error uploading designs")
                completion(.Failure)
            }
            
            // Nil the checkout images, primarily because they are huge
            for product in self.products {
                product.checkoutImage = nil
            }
            
        }
    }
    
    // When apple pay done/cancel
    func paymentAuthorizationViewControllerDidFinish(controller: PKPaymentAuthorizationViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    // Shipping Method
    func paymentAuthorizationViewController(controller: PKPaymentAuthorizationViewController, didSelectShippingMethod shippingMethod: PKShippingMethod, completion: (PKPaymentAuthorizationStatus, [PKPaymentSummaryItem]) -> Void) {
        self.applePayhelper?.updateCheckoutWithShippingMethod(shippingMethod, completion: { (status, items) -> Void in
            completion(status, items as! [PKPaymentSummaryItem])
        })
    }
    
    // Shipping Address
    func paymentAuthorizationViewController(controller: PKPaymentAuthorizationViewController, didSelectShippingAddress address: ABRecord, completion: (PKPaymentAuthorizationStatus, [PKShippingMethod], [PKPaymentSummaryItem]) -> Void) {
        self.applePayhelper?.updateCheckoutWithAddress(address, completion: { (status, shipping, summary) in
            completion(status, shipping as! [PKShippingMethod], summary as! [PKPaymentSummaryItem])
        })
    }
}

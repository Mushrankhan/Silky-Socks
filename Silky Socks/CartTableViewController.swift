//
//  CartTableViewController.swift
//  Silky Socks
//
//  Created by Saurabh Jain on 6/19/15.
//  Copyright (c) 2015 Saurabh Jain. All rights reserved.
//

import UIKit
import PassKit

class CartTableViewController: BUYViewController, UITableViewDataSource, UITableViewDelegate, CheckoutButtonViewDelegate, BUYViewControllerDelegate {

    // The Cart
    private var products: [CartProduct] {
        return UserCart.sharedCart.cart
    }
    
    // Table View
    private lazy var tableView : UITableView = {
        let width = CGRectGetWidth(UIScreen.mainScreen().bounds)
        let height = CGRectGetHeight(UIScreen.mainScreen().bounds)
        let frame = CGRect(origin: CGPointZero, size: CGSize(width: width, height: height-100))
        let view = UITableView(frame: frame)
        view.dataSource = self
        view.delegate = self
        view.rowHeight = 160
        return view
    }()
    
    // Checkout Payment Options
    private lazy var checkoutButtonView: CheckoutButtonView = {
        let height = CGRectGetHeight(UIScreen.mainScreen().bounds)
        let width = CGRectGetWidth(UIScreen.mainScreen().bounds)
        let frame = CGRect(x: 0, y: height-100, width: width, height: 100)
        let view = CheckoutButtonView(frame: frame)
        view.backgroundColor = UIColor.whiteColor()
        view.delegate = self
        view.setUp(self.isApplePayAvailable)
        return view
    }()
    
    // Cart Empty Label
    private var cartEmptyLabel: UILabel!
    
    // Number of items in the cart
    var numberOfItemsInCart: Int {
        return UserCart.sharedCart.numberOfItems
    }
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the delegate to BUYViewControllerDelegate
        self.delegate = self
        self.merchantId = ApplePay.Identifier
        
        // Title
        navigationItem.title = "Cart"
        
        // Add the lazily instantiated views
        view.backgroundColor = UIColor.whiteColor()
        view.addSubview(tableView)
        view.addSubview(checkoutButtonView)
        
        // Register Cell
        tableView.registerNib(CartTableViewCell.nib(), forCellReuseIdentifier: cartCellReuseIdentifier)
        
        // Hide unwanted cells
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        // When a product is bought, then reload the table
        NSNotificationCenter.defaultCenter().addObserverForName(kBoughtProductNotification, object: nil, queue: NSOperationQueue.mainQueue()) { [weak self] _ in
            self?.tableView.reloadData()
            self?.tableView.tableHeaderView = self?.numberOfItemsInCart == 0 ? self?.cartEmptyLabel : nil
            UIView.animateWithDuration(0.3) {
                self?.checkoutButtonView.alpha = 0
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
        checkoutButtonView.alpha = 1
        
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
                    self.checkoutButtonView.alpha = 0
                }
            }
        }
    }
    
    // MARK: CheckoutButtonView Delegate
    
    func didClickApplePay() {
        applePayCheckout()
    }
    
    func didClickCheckoutButton() {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CheckoutViewController") as! CheckoutViewController
        vc.products = UserCart.sharedCart.cart
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    // MARK: - Apple Pay
    
    private struct ApplePay {
        static let Identifier = "merchant.com.danny-silkysocks"
    }
    
    func applePayCheckout() {
        
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
                    
                    self.loadShopWithCallback { (success, error) in
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            SVProgressHUD.dismiss()
                            if success {
                                self.startApplePayCheckout(BUYCheckout(cart: cart))
                            } else {
                                print(error)
                            }
                        })
                    }
                }
            }
        })
        
        queue.addOperation(products)
    }
    
    // MARK: BUYViewController Delegate
    
    func controller(controller: BUYViewController!, didCompleteCheckout checkout: BUYCheckout!, status: BUYStatus) {
        
        if status == BUYStatus.Complete {
            
            var task: UIBackgroundTaskIdentifier!
            task = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler {
                UIApplication.sharedApplication().endBackgroundTask(task)
                task = UIBackgroundTaskInvalid
            }
            
            // Upload
            upload {
                UIApplication.sharedApplication().endBackgroundTask(task)
                task = UIBackgroundTaskInvalid
            }
        }
    }
    
    private func upload(block: () -> ()) {
        uploadDesigns(checkout, block: { (success, error) in
            if success {
                for product in self.products {
                    product.checkoutImage = nil
                }
                UserCart.sharedCart.boughtProduct()
            } else {
                // Error Uploading designs
                // Try again
                self.order?.saveEventually(nil)
            }
            block()
        })
    }
    
    private var order: Order?
    
    private func uploadDesigns(checkout: BUYCheckout, block: (Bool, NSError?) -> ()) {
        order = Order()
        order?.orderId = checkout.orderId
        order?.name = checkout.shippingAddress.firstName + " " + checkout.shippingAddress.lastName
        order?.email = checkout.email
        order?.price = checkout.totalPrice
        order?.address = checkout.shippingAddress.getAddress()
        
        for product in products {
            product.checkoutImage = product.productImage.renderImageIntoSize(product.productSize)
        }
        
        for (index, product) in products.enumerate() {
            order?["file\(index+1)"] = PFFile(data: UIImageJPEGRepresentation(product.productImage, 0.5)!)
            order?["mockup\(index+1)"] = PFFile(data: UIImageJPEGRepresentation(product.cartImage, 0.5)!)
        }
        
        order?.saveInBackgroundWithBlock({ (success, error) -> Void in
            dispatch_async(dispatch_get_main_queue()) {
                block(success, error)
            }
        })
    }
    
    func controller(controller: BUYViewController!, failedToCompleteCheckout checkout: BUYCheckout!, withError error: NSError!) {
        print(error)
        SweetAlert().showAlert("Error", subTitle: "Failed to complete checkout", style: .Error)
    }
    
    func controller(controller: BUYViewController!, failedToCreateCheckout error: NSError!) {
        SweetAlert().showAlert("Error", subTitle: "Failed to create checkout", style: .Error)
    }
    
    func controllerFailedToStartApplePayProcess(controller: BUYViewController!) {
        SweetAlert().showAlert("Error", subTitle: "Failed to start Apple Pay", style: .Error)
    }
    
    func controllerWillCheckoutViaApplePay(viewController: BUYViewController!) {
        
//        var task: UIBackgroundTaskIdentifier!
//        task = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler {
//            UIApplication.sharedApplication().endBackgroundTask(task)
//            task = UIBackgroundTaskInvalid
//        }
//        
//        let semaphore = dispatch_semaphore_create(0)
//        
//        SVProgressHUD.showInfoWithStatus("Uploading Designs")
//        uploadDesigns(checkout, block: { (success, error) -> () in
//            if success {
//                for product in self.products {
//                    product.checkoutImage = nil
//                }
//                UserCart.sharedCart.boughtProduct()
//                SVProgressHUD.dismiss()
//            } else {
//                // Error Uploading designs
//            }
//            SVProgressHUD.dismiss()
//            UIApplication.sharedApplication().endBackgroundTask(task)
//            task = UIBackgroundTaskInvalid
//            dispatch_semaphore_signal(semaphore)
//        })
//        
//        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
    }
}

protocol CheckoutButtonViewDelegate: NSObjectProtocol {
    func didClickApplePay()
    func didClickCheckoutButton()
}

class CheckoutButtonView: UIView {
    
    // Delegate
    weak var delegate: CheckoutButtonViewDelegate?
    
    // Buttons
    private var applePayButton: PKPaymentButton?
    private var checkoutButton: UIButton?
    
    private func setUp(applePayAvailable: Bool) {
        
        checkoutButton = UIButton(type: UIButtonType.Custom)
        checkoutButton?.backgroundColor = UIColor.blackColor()
        checkoutButton?.setTitle("Checkout", forState: UIControlState.Normal)
        checkoutButton?.addTarget(self, action: "checkoutButtonPressed:", forControlEvents: .TouchUpInside)

        let centerX = CGRectGetMidX(UIScreen.mainScreen().bounds)
        
        if applePayAvailable {
            applePayButton = PKPaymentButton(type: .Buy, style: .Black)
            applePayButton?.addTarget(self, action: "applePayButtonPressed:", forControlEvents: .TouchUpInside)
            applePayButton?.frame = CGRect(x: centerX - 50 , y: 16, width: 100, height: 34)
            
            checkoutButton?.layer.cornerRadius = 5
            checkoutButton?.frame = CGRect(x: centerX - 50, y: 58, width: 100, height:34)
            addSubview(applePayButton!)
        } else {
            checkoutButton?.frame.size = CGSize(width: CGRectGetWidth(UIScreen.mainScreen().bounds), height: 42)
            checkoutButton?.center = CGPoint(x: centerX, y: CGRectGetMaxY(self.bounds) - 42)
        }
        
        addSubview(checkoutButton!)
    }
    
    @objc private func checkoutButtonPressed(button: UIButton) {
        delegate?.didClickCheckoutButton()
    }
    
    @objc private func applePayButtonPressed(button: PKPaymentButton) {
        delegate?.didClickApplePay()
    }
    
}

//
//  CartTableViewController.swift
//  Silky Socks
//
//  Created by Saurabh Jain on 6/19/15.
//  Copyright (c) 2015 Saurabh Jain. All rights reserved.
//

import UIKit
import PassKit

class CartTableViewController: BUYViewController, UITableViewDataSource, UITableViewDelegate, CheckoutButtonViewDelegate, BUYViewControllerDelegate, CartTableViewCellDelegate {

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
        //if #available(iOS 9.0, *) {
            cartEmptyLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleTitle1)
//        } else {
//            // Fallback on earlier versions
//            cartEmptyLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
//        }
        
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
        cell.delegate = self
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
    
    // MARK: CartTableViewCell Delegate
    
    func didTapSizeChartButton() {
        let vc = SupportViewController()
        vc.path = NSBundle.mainBundle().pathForResource("Size_Charts", ofType: "pdf")
        let nav = UINavigationController(rootViewController: vc)
        self.presentViewController(nav, animated: true, completion: nil)
    }
    
    // MARK: CheckoutButtonView Delegate
    
    private var agreedToTermsAndConditions = false
    
    func didClickApplePay() {
        
        // if not agreed to terms and conditions
        if agreedToTermsAndConditions == false {
            SweetAlert().showAlert("Error", subTitle: "Please agree to the terms", style: .Error)
            return
        }
        
        applePayCheckout()
    }
    
    func didClickCheckoutButton() {
        
        // if not agreed to terms and conditions
        if agreedToTermsAndConditions == false {
            SweetAlert().showAlert("Error", subTitle: "Please agree to the terms", style: .Error)
            return
        }
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CheckoutViewController") as! CheckoutViewController
        vc.products = UserCart.sharedCart.cart
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func didAgreeToTermsAndConditions(agree: Bool) {
        agreedToTermsAndConditions = agree
    }
    
    func didPressTermsAndConditionsButton() {
        let vc = SupportViewController()
        vc.path = NSBundle.mainBundle().pathForResource("Terms_and_conditions", ofType: "pdf")
        let nav = UINavigationController(rootViewController: vc)
        self.presentViewController(nav, animated: true, completion: nil)
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
        uploadDesigns(checkout) { (success, error) in
            if success {
                for product in self.products {
                    product.checkoutImage = nil
                }
                UserCart.sharedCart.boughtProduct()
                self.order = nil
            } else {
                // Error Uploading designs
                // Try again
                self.order?.saveEventually(nil)
            }
            block()
        }
    }
    
    private var order: Order?
    
    private func uploadDesigns(checkout: BUYCheckout, block: (Bool, NSError?) -> ()) {
        
        BUYClient.sharedClient().getCheckout(checkout) { (checkout, error) -> Void in
            self.order = Order()
            self.order?.orderId = checkout.orderId
            self.order?.name = checkout.shippingAddress.firstName + " " + checkout.shippingAddress.lastName
            self.order?.email = checkout.email
            self.order?.price = checkout.totalPrice
            self.order?.address = checkout.shippingAddress.getAddress()
            
            for product in self.products {
                product.checkoutImage = product.productImage.renderImageIntoSize(product.productSize)
            }
            
            for (index, product) in self.products.enumerate() {
                let file = PFFile(name: "file\(index+1)", data: UIImageJPEGRepresentation(product.checkoutImage!, 0.5)!)
                self.order?["file\(index+1)"] = file
                
                let mock = PFFile(name: "mockup\(index+1)", data: UIImageJPEGRepresentation(product.cartImage, 0.5)!)
                self.order?["mockup\(index+1)"] = mock
            }
            
            self.order?.saveInBackgroundWithBlock({ (success, error) -> Void in
                dispatch_async(dispatch_get_main_queue()) {
                    block(success, error)
                }
            })
        }
    }
    
    func controller(controller: BUYViewController!, failedToCompleteCheckout checkout: BUYCheckout!, withError error: NSError!) {
        SweetAlert().showAlert("Error", subTitle: "Failed to complete checkout", style: .Error)
    }
    
    func controller(controller: BUYViewController!, failedToCreateCheckout error: NSError!) {
        SweetAlert().showAlert("Error", subTitle: "Failed to create checkout", style: .Error)
    }
    
    func controllerFailedToStartApplePayProcess(controller: BUYViewController!) {
        SweetAlert().showAlert("Error", subTitle: "Failed to start Apple Pay", style: .Error)
    }
    
}

protocol CheckoutButtonViewDelegate: NSObjectProtocol {
    func didClickApplePay()
    func didClickCheckoutButton()
    func didAgreeToTermsAndConditions(agree: Bool)
    func didPressTermsAndConditionsButton()
}

class CheckoutButtonView: UIView, BEMCheckBoxDelegate {
    
    // Delegate
    weak var delegate: CheckoutButtonViewDelegate?
    
    // Buttons
    private var applePayButton: PKPaymentButton?
    private var checkoutButton: UIButton!
    
    // Terms and Conditions Button
    private var termsButton: UIButton = {
        let button = UIButton()
        
        // Attributed title
        let attributedString = NSMutableAttributedString(string: "I agree to Terms and Conditions")
        let attrs = [NSForegroundColorAttributeName: UIColor.blueColor(), NSUnderlineStyleAttributeName: 1]
        attributedString.addAttributes(attrs, range: NSMakeRange(11, 20))
        let fontDescriptor = UIFontDescriptor.preferredFontDescriptorWithTextStyle(UIFontTextStyleBody)
        let font = UIFont(descriptor: fontDescriptor, size: 12)
        attributedString.addAttributes([NSFontAttributeName: font], range: NSMakeRange(0, 31))
        button.setAttributedTitle(attributedString, forState: .Normal)
        button.sizeToFit()
        return button
    }()
    
    // Check box
    private var checkBox: BEMCheckBox = {
        let checkBox = BEMCheckBox()
        checkBox.boxType = .Square
        checkBox.onCheckColor = UIColor.whiteColor()
        checkBox.onFillColor = UIColor.blackColor()
        checkBox.onTintColor = UIColor.whiteColor()
        return checkBox
    }()
    
    private func setUp(applePayAvailable: Bool) {
        
        let centerX = CGRectGetMidX(UIScreen.mainScreen().bounds)

        // Checkout button
        checkoutButton = UIButton(type: UIButtonType.Custom)
        checkoutButton?.backgroundColor = UIColor.blackColor()
        checkoutButton?.setTitle("Checkout", forState: UIControlState.Normal)
        checkoutButton?.addTarget(self, action: "checkoutButtonPressed:", forControlEvents: .TouchUpInside)

        // Conform to the check box delegate
        checkBox.delegate = self
        
        // Target for button
        termsButton.addTarget(self, action: "termsButtonPressed", forControlEvents: .TouchUpInside)
        
        if applePayAvailable {
            
            termsButton.center = CGPoint(x: centerX + 10, y: 8)
            checkBox.frame = CGRect(x: termsButton.frame.origin.x - 25, y: 0, width: 15, height: 15)
            
            applePayButton = PKPaymentButton(type: .Buy, style: .Black)
            applePayButton?.addTarget(self, action: "applePayButtonPressed:", forControlEvents: .TouchUpInside)
            applePayButton?.frame = CGRect(x: centerX - 60 , y: 24, width: 120, height: 30)
            
            checkoutButton?.layer.cornerRadius = 5
            checkoutButton?.frame = CGRect(x: centerX - 60, y: 60, width: 120, height:30)
            addSubview(applePayButton!)
        } else {
            
            termsButton.center = CGPoint(x: centerX + 10, y: 16)
            checkBox.frame = CGRect(x: termsButton.frame.origin.x - 25, y: 6, width: 20, height: 20)

            checkoutButton?.frame.size = CGSize(width: CGRectGetWidth(UIScreen.mainScreen().bounds), height: 42)
            checkoutButton?.center = CGPoint(x: centerX, y: CGRectGetMaxY(self.bounds) - 42)
        }
        
        addSubview(checkoutButton!)
        addSubview(checkBox)
        addSubview(termsButton)
    }
    
    @objc private func checkoutButtonPressed(button: UIButton) {
        delegate?.didClickCheckoutButton()
    }
    
    @objc private func applePayButtonPressed(button: PKPaymentButton) {
        delegate?.didClickApplePay()
    }
    
    @objc private func termsButtonPressed() {
        delegate?.didPressTermsAndConditionsButton()
    }
    
    // MARK: BEMCheckBox Delegate
    
    func didTapCheckBox(checkBox: BEMCheckBox) {
        delegate?.didAgreeToTermsAndConditions(checkBox.on)
    }
    
}

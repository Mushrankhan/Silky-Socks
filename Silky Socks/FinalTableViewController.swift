//
//  FinalTableViewController.swift
//  Silky Socks
//
//  Created by Saurabh Jain on 6/25/15.
//  Copyright (c) 2015 Saurabh Jain. All rights reserved.
//

import UIKit

class FinalTableViewController: UITableViewController, CreditCardTableViewCellDelegate, FinalTableViewControllerFooterViewDelegate, DiscountTableViewCellDelegate, UIViewControllerTransitioningDelegate {
    
    // Passed on from previous VC
    var checkout: BUYCheckout!
    var shippingRates: [BUYShippingRate]!
    var productImage: UIImage!
    
    // Constants
    private struct Constants {
        static let CellReuseIdentifier = "Cell"
        static let CreditCardCell = "Credit Cell"
        static let DiscountCellReuseIdentifier = "Discount Cell"
        static let CreditCardCellNib = "CreditCardTableViewCell"
        static let NumberOfSections = 4
        static let NumberOfRowsInSectionTwo = 2
        static let NumberOfRowsInSectionThree = 1
        static let SectionZeroTitle = "Select a shipping method"
        static let SectionOneTitle = "Discount"
        static let SectionThreeTitle = "Payment Method"
        static let FooterViewNibName = "FinalTableViewControllerFooterView"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        // Title
        navigationItem.title = "Final"
        
        // Register Nib
        tableView.registerNib(UINib(nibName: Constants.CreditCardCellNib, bundle: nil), forCellReuseIdentifier: Constants.CreditCardCell)
        
        // Set up the footer view
        let footerView = NSBundle.mainBundle().loadNibNamed(Constants.FooterViewNibName, owner: nil, options: nil).first as? FinalTableViewControllerFooterView
        footerView?.delegate = self
        tableView.tableFooterView = footerView
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return Constants.NumberOfSections
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if section == 0 {
            return shippingRates.count
        } else if section == 1 {
            return 1
        }
        return section == 2 ? Constants.NumberOfRowsInSectionTwo : Constants.NumberOfRowsInSectionThree
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        // Section 0 : Show Shipping Information
        // Section 2 : Show Total Tax and Total Price
        if indexPath.section == 0 || indexPath.section == 2 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier(Constants.CellReuseIdentifier, forIndexPath: indexPath) as UITableViewCell
            cell.accessoryType = .None
            
            // Section 0
            if indexPath.section == 0 {
                let rate = shippingRates[indexPath.row]
                cell.textLabel!.text = rate.title == "FREE SHIPPING" ? "\(rate.title) (Over $30)" : rate.title
                cell.detailTextLabel!.text = rate.price == NSDecimalNumber(integer: 0) ? "$\(rate.price)" : "$\(rate.price)0"
                
                // If selected a shipping method then show a check mark
                if selectedShippingIndexPath != nil && selectedShippingIndexPath == indexPath {
                    cell.accessoryType = .Checkmark
                    if selectedShipping != shippingRates[selectedShippingIndexPath!.row] {
                        selectedShipping = shippingRates[selectedShippingIndexPath!.row]
                    }
                } else {
                    cell.accessoryType = .None
                }
            }
            
            // Section 2
            else {
                cell.textLabel?.text = indexPath.row == 0 ? "Tax" : "Total"
                if self.checkout.discount != nil && indexPath.row == 1 {
                    cell.textLabel?.text = "Tax ($\(self.checkout.discount.amount) off)"
                }
                
                cell.detailTextLabel?.text = indexPath.row == 0 ? "$\(checkout.totalTax)" : "$\(checkout.totalPrice)"
                cell.selectionStyle = .None
            }
            
            return cell
        }
        
        // Section 1 : Show Discount
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier(Constants.DiscountCellReuseIdentifier, forIndexPath: indexPath) as! DiscountTableViewCell
            cell.delegate = self
            return cell
        }

        
        // Cell to collect credit card details
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.CreditCardCell, forIndexPath: indexPath) as! CreditCardTableViewCell
        cell.delegate = self
        return cell

    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 3 {
            return 80
        }
        return 44
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return Constants.SectionZeroTitle
        } else if section == 1 {
            return Constants.SectionOneTitle
        } else if section == 3 {
            return Constants.SectionThreeTitle
        }
        return nil
    }
    
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 1 {
            return "Please use 'save20' when ordering 12 or more quantities.\nOR use 'save30' when ordering 24 or more quantities."
        }
        return nil
    }
    
    // MARK: - Table View Delegate
    
    // Keep track of shipping
    private var selectedShippingIndexPath: NSIndexPath?
    
    // When a shipping method is selected, then update the checkout
    private var selectedShipping: BUYShippingRate? {
        didSet {
            checkout.shippingRate = selectedShipping
            SVProgressHUD.showWithStatus("Updating Shipping Method")
            BUYClient.sharedClient().updateCheckout(checkout) { [unowned self] (checkout, error) in
                
                // Hide
                dispatch_async(dispatch_get_main_queue()) {
                    SVProgressHUD.dismiss()
                }
                
                if error == nil {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.checkout = checkout
                        self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 1, inSection: 2)], withRowAnimation: .Fade)
                    }
                } else {
                    dispatch_async(dispatch_get_main_queue()) {
                        SweetAlert().showAlert("Error Updating", subTitle: "Shipping Method", style: .Error)
                        checkout.shippingRate = nil
                    }
                }
            }
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 0 {
            
            // If choose same shipping
            if selectedShippingIndexPath == indexPath {
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
                return
            }
            
            // One Shipping Method already has been selected
            if selectedShippingIndexPath != nil {
                let cell = tableView.cellForRowAtIndexPath(selectedShippingIndexPath!)
                cell?.accessoryType = .None
            }
            
            // Update the indexPath of the new shipping
            // And then reload the row, which also update the UI and the checkout object
            selectedShippingIndexPath = indexPath
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            return
        }
        
        // If any other section is selected, then deselect the row at that indexPath
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: - DiscountTableViewCell Delegate
    
    func discountTableViewCell(cell: DiscountTableViewCell, didEnterDiscountCode code: String){
        
        if code.characters.count == 0 {
            return
        }
        
        if code.lowercaseString == "save24" || code.lowercaseString == "save12" {
            var quantity = 0
            for item in self.checkout.lineItems as! [BUYLineItem] {
                quantity += Int(item.quantity)
            }
            
            if code.lowercaseString == "save12" && (quantity < 12 || quantity > 23) {
                SweetAlert().showAlert("Quantity", subTitle: "Discount code cannot be applied", style: .Error)
                return
            }
            
            if quantity < 24 {
                SweetAlert().showAlert("Quantity", subTitle: "Discount code cannot be applied", style: .Error)
                return
            }
            
        }
        
        // Show loading indicator
        SVProgressHUD.showWithStatus("Applying Discount Code")
        
        // Apply code
        let code = BUYDiscount(code: code)
        self.checkout.discount = code
        BUYClient.sharedClient().updateCheckout(checkout, completion: { (checkout, error) -> Void in
            
            // hide
            dispatch_async(dispatch_get_main_queue()) {
                SVProgressHUD.dismiss()
            }
            
            // If success, then update checkout
            if error == nil {
                self.checkout = checkout
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 1, inSection: 2)], withRowAnimation: .Fade)
                }
                
            } else {
                dispatch_async(dispatch_get_main_queue()) { // Show error, and nil out discount
                    SweetAlert().showAlert("Invalid Code", subTitle: "Try another one", style: .Error)
                    self.checkout.discount = nil
                }
            }
            
        })
    }
    
    // MARK: - CreditCardTableViewCell Delegate
    
    private lazy var card: BUYCreditCard = {
        let creditcard = BUYCreditCard()
        creditcard.nameOnCard = self.checkout.shippingAddress.firstName + " " + self.checkout.shippingAddress.lastName
        return creditcard
    }()
    
    func creditCardTableViewCell(cell: CreditCardTableViewCell, didEnterCreditCard creditCard: String) {
        card.number = creditCard
    }
    
    func creditCardTableViewCell(cell: CreditCardTableViewCell, didEnterExpiryMonth expiryMonth: String) {
        card.expiryMonth = expiryMonth
    }
    
    func creditCardTableViewCell(cell: CreditCardTableViewCell, didEnterExpiryYear expiryYear: String) {
        card.expiryYear = expiryYear
    }
    
    func creditCardTableViewCell(cell: CreditCardTableViewCell, didEnterCVV cvv: String) {
        card.cvv = cvv
    }
    
    // MARK: - FinalTableViewControllerFooterViewDelegate
    
    func payByCreditCard(creditCard: Bool) {
                
        // Please select a shipping method
        if self.checkout.shippingRate == nil {
            SweetAlert().showAlert("Select a Shipping", subTitle: "", style: .Error)
            return
        }
        
        // Pay by credit card
        if creditCard {
            
            if card.isValid() {
                // Show Loading
                
                UIApplication.sharedApplication().beginIgnoringInteractionEvents()
                SVProgressHUD.showWithStatus("Sending Credit Card Info")
                
                // Associate the card with the checkout
                BUYClient.sharedClient().storeCreditCard(card, checkout: self.checkout) { [unowned self] (checkout, status, error) in
                    if error == nil {
                        self.checkout = checkout
                        dispatch_async(dispatch_get_main_queue()) {
                            self.completeCheckout() // Complete Checkout
                        }
                    } else {
                        dispatch_async(dispatch_get_main_queue()) {
                            UIApplication.sharedApplication().endIgnoringInteractionEvents()
                            SVProgressHUD.dismiss()
                            SweetAlert().showAlert("Unable to Process", subTitle: "Please Try Again Later", style: .Error)
                        }
                    }
                }
            }
            
            // Credit Card Not Valid
            else {
                SweetAlert().showAlert("Credit Card Not Valid", subTitle: "", style: .Error)
            }
        }
    }
    
    // Show terms and conditions
    func agreeToTermsAndConditions() {
        let vc = SupportViewController()
        vc.path = NSBundle.mainBundle().pathForResource("Terms_and_conditions", ofType: "pdf")
        presentViewController(vc, animated: true, completion: nil)
    }
    
    // MARK: - Checkout
    
    final private func completeCheckout() {
        
        let order = Order()
        order.name = checkout.shippingAddress.firstName + " " + checkout.shippingAddress.lastName
        order.email = checkout.email
        order.price = checkout.totalPrice
        order.address = checkout.shippingAddress.getAddress()
        order.file = PFFile(data: UIImageJPEGRepresentation(self.productImage, 0.7)!)
        
        SVProgressHUD.setStatus("Uploading Image")
        // Save the object to parse
        order.saveInBackgroundWithBlock { [unowned self] (success, error) -> Void in
            
            if success {
                dispatch_async(dispatch_get_main_queue()) {
                    
                    // Get the client
                    let client = BUYClient.sharedClient()
                    
                    SVProgressHUD.setStatus("Completing...")
                    client.completeCheckout(self.checkout) { (checkout, error) in
                        
                        if error == nil {
                            self.checkout = checkout
                            dispatch_async(dispatch_get_main_queue()) {
                                self.getCompletionStatusOfCheckout()
                            }
                            
                        } else {
                            dispatch_async(dispatch_get_main_queue()) {
                                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                                order.file = nil
                                SVProgressHUD.dismiss()
                                SweetAlert().showAlert("Unable to Process", subTitle: "Please try again", style: .Error)
                            }
                        }
                    }
                    
                }
            }
            
            // Not able to save to Parse
            else {
                dispatch_async(dispatch_get_main_queue()) {
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    SVProgressHUD.dismiss()
                    SweetAlert().showAlert("Error Uploading Image", subTitle: "Check Internet Connection", style: .Error)
                }
            }
        }
    }
    
    
    final private func getCompletionStatusOfCheckout() {
        
        let client = BUYClient.sharedClient()
        var status = BUYStatus.Unknown
        var completedCheckout = self.checkout
        let semaphore = dispatch_semaphore_create(0)
        
        SVProgressHUD.setStatus("Checking for Completion")
        
        repeat {
            client.getCompletionStatusOfCheckout(self.checkout, completion: { (checkout, buystatus, error)  in
                completedCheckout = checkout
                status = buystatus
                dispatch_semaphore_signal(semaphore)
            })
            
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
            
            if (status == .Processing) {
                NSThread.sleepForTimeInterval(0.5)
            } else {
                SVProgressHUD.dismiss()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                if status == .Failed {
                    SweetAlert().showAlert("Failed", subTitle: "Try Again", style: .Error)
                } else if status == .Complete {
                    SweetAlert().showAlert("Success", subTitle: "Congratulations", style: .Success)
                    // Remove the first item from the cart
                    UserCart.sharedCart.boughtProduct()
                    self.navigationController?.popToViewController(self.navigationController!.viewControllers[1] as UIViewController, animated: true)
                }
            }
            
        } while (completedCheckout.token != nil && status != .Failed && status != .Complete)
    }
}

//
//  FinalTableViewController.swift
//  Silky Socks
//
//  Created by Saurabh Jain on 6/25/15.
//  Copyright (c) 2015 Full Stak. All rights reserved.
//

import UIKit

class FinalTableViewController: UITableViewController, CreditCardTableViewCellDelegate, FinalTableViewControllerFooterViewDelegate {
    
    // Passed on from previous VC
    var checkout: BUYCheckout!
    var shippingRates: [BUYShippingRate]!
    
    // Constants
    private struct Constants {
        static let CellReuseIdentifier = "Cell"
        static let CreditCardCell = "Credit Cell"
        static let CreditCardCellNib = "CreditCardTableViewCell"
        static let NumberOfSections = 3
        static let NumberOfRowsInSectionOne = 2
        static let NumberOfRowsInSectionTwo = 1
        static let SectionZeroTitle = "Select a shipping method"
        static let SectionTwoTitle = "Payment Method"
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
        }
        return section == 1 ? Constants.NumberOfRowsInSectionOne : Constants.NumberOfRowsInSectionTwo
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        // Section 0 : Show Shipping Information
        // Section 1 : Show Total Tax and Total Price
        if indexPath.section == 0 || indexPath.section == 1 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier(Constants.CellReuseIdentifier, forIndexPath: indexPath) as! UITableViewCell
            
            // Section 0
            if indexPath.section == 0 {
                cell.textLabel!.text = shippingRates[indexPath.row].title
                cell.detailTextLabel!.text = "$\(shippingRates[indexPath.row].price)"
                
                // If selected a shipping method then show a check mark
                if selectedShippingIndexPath != nil {
                    cell.accessoryType = .Checkmark
                    selectedShipping = shippingRates[selectedShippingIndexPath!.row] // Set the selected shipping
                } else {
                    cell.accessoryType = .None
                }
            }
            
            // Section 1
            else {
                cell.textLabel?.text = indexPath.row == 0 ? "Tax" : "Total"
                cell.detailTextLabel?.text = indexPath.row == 0 ? "$\(checkout.totalTax)" : "$\(checkout.totalPrice)"
                cell.selectionStyle = .None
            }
            
            return cell
        }
        
        // Cell to collect credit card details
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.CreditCardCell, forIndexPath: indexPath) as! CreditCardTableViewCell
        cell.delegate = self
        return cell

    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 2 {
            return 80
        }
        return 44
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return Constants.SectionZeroTitle
        } else if section == 2 {
            return Constants.SectionTwoTitle
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
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    SVProgressHUD.dismiss()
                })
                
                if error == nil {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.checkout = checkout
                        self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 1, inSection: 1)], withRowAnimation: .Fade)
                    }
                } else {
                    dispatch_async(dispatch_get_main_queue()) {
                        SweetAlert().showAlert("Error Updating", subTitle: "Shipping Method", style: .Error)
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
    
    // MARK: - CreditCardTableViewCell Delegate
    
    private lazy var card: BUYCreditCard = {
        let creditcard = BUYCreditCard()
        creditcard.nameOnCard = self.checkout.shippingAddress.firstName + " " + self.checkout.shippingAddress.lastName
        return creditcard
    }()
    
    func creditCardTableViewCell(cell: CreditCardTableViewCell, didEnterCreditCard creditCard: String) {
        card.number = creditCard
        println(creditCard)
    }
    
    func creditCardTableViewCell(cell: CreditCardTableViewCell, didEnterExpiryMonth expiryMonth: String) {
        card.expiryMonth = expiryMonth
        println(expiryMonth)
    }
    
    func creditCardTableViewCell(cell: CreditCardTableViewCell, didEnterExpiryYear expiryYear: String) {
        card.expiryYear = expiryYear
        println(expiryYear)
    }
    
    func creditCardTableViewCell(cell: CreditCardTableViewCell, didEnterCVV cvv: String) {
        card.cvv = cvv
        println(cvv)
    }
    
    // MARK: - FinalTableViewControllerFooterViewDelegate
    
    func payByCreditCard(creditCard: Bool) {
        
        // @warning Have to solve the 2 issues posted on Shopify
        
        // Please select a shipping method
        if self.checkout.shippingRate == nil {
            SweetAlert().showAlert("Select a Shipping", subTitle: "", style: .Error)
            return
        }
        
        // Pay by credit card
        if creditCard {
            
            if card.isValid() {
                // Show Loading
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
        
        // Apple Pay
        // Hidden for now
        else {
            
        }
    }
    
    // MARK: - Checkout
    
    final private func completeCheckout() {
        
        // Get the client
        let client = BUYClient.sharedClient()
        
        SVProgressHUD.setStatus("Completing...")
        client.completeCheckout(checkout) { [unowned self] (checkout, error) in
            
            if error == nil {
                self.checkout = checkout
                dispatch_async(dispatch_get_main_queue()) {
                    self.getCompletionStatusOfCheckout()
                }
                
            } else {
                dispatch_async(dispatch_get_main_queue()) {
                    SVProgressHUD.dismiss()
                    SweetAlert().showAlert("Unable to Process", subTitle: "Please try again", style: .Error)
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
        
        do {
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
                if status == .Failed {
                    SweetAlert().showAlert("Failed", subTitle: "Try Again", style: .Error)
                } else if status == .Complete {
                    SweetAlert().showAlert("Success", subTitle: "Congratulations", style: .Success)
                    // Remove the first item from the cart
                    UserCart.sharedCart.boughtProduct()
                    self.navigationController?.popToViewController(self.navigationController!.viewControllers[1] as! UIViewController, animated: true)
                }
            }
            
        } while (completedCheckout.token != nil && status != .Failed && status != .Complete)
    }
}

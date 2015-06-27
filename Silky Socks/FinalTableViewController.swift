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
        static let NumberOfSections = 3
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Final"
        tableView.registerNib(UINib(nibName: "CreditCardTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CreditCardCell)
        
        let footerView = NSBundle.mainBundle().loadNibNamed("FinalTableViewControllerFooterView", owner: nil, options: nil).first as? FinalTableViewControllerFooterView
        footerView?.delegate = self
        tableView.tableFooterView = footerView
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return Constants.NumberOfSections
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return section == 0 ? shippingRates.count : 1
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if indexPath.section == 0 || indexPath.section == 1 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier(Constants.CellReuseIdentifier, forIndexPath: indexPath) as! UITableViewCell
            
            if indexPath.section == 0 {
                let rate = shippingRates[indexPath.row]
                cell.textLabel!.text = rate.title
                cell.detailTextLabel!.text = "$\(rate.price)"
                
                if selectedShippingIndexPath != nil {
                    cell.accessoryType = .Checkmark
                    selectedShipping = shippingRates[selectedShippingIndexPath!.row]
                } else {
                    cell.accessoryType = .None
                }
            } else {
                cell.textLabel?.text = "Tax"
                cell.detailTextLabel?.text = "$\(checkout.totalTax)"
                cell.selectionStyle = .None
            }
            
            return cell
        }
        
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
            return "Select a shipping method"
        } else if section == 2 {
            return "Payment Method"
        }
        return nil
    }
    
    // MARK: - Table View Delegate
    
    // Keep track of shipping
    private var selectedShippingIndexPath: NSIndexPath?
    private var selectedShipping: BUYShippingRate? {
        didSet {
            checkout.shippingRate = selectedShipping
            SVProgressHUD.showWithStatus("Updating Shipping Method")
            BUYClient.sharedClient().updateCheckout(checkout, completion: { (checkout, error) -> Void in
                if error == nil {
                    self.checkout = checkout
                }
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    SVProgressHUD.dismiss()
                })
            })
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 0 {
            
            if selectedShippingIndexPath == indexPath {
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
                return
            }
            
            // one shipping method already selected
            if selectedShippingIndexPath != nil {
                let cell = tableView.cellForRowAtIndexPath(selectedShippingIndexPath!)
                cell?.accessoryType = .None
            }
            
            selectedShippingIndexPath = indexPath
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            return
        }
        
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
        
        // @warning Have to solve the 2 issues posted on Shopify
        
        // Please select a shipping method
        if self.checkout.shippingRate == nil {
            SweetAlert().showAlert("Select a Shipping", subTitle: "", style: .Error)
            return
        }
        
        // Pay by credit card
        if creditCard {
            if card.isValid() {
                BUYClient.sharedClient().storeCreditCard(card, checkout: self.checkout) { (checkout, status, error) in
                    if error == nil {
                        self.checkout = checkout
                        // now show total price
                        dispatch_async(dispatch_get_main_queue()) {
                            self.completeCheckout()
                        }
                        
                    } else {
                        dispatch_async(dispatch_get_main_queue()) {
                            SweetAlert().showAlert("Unable to Process", subTitle: "Please Try Again Later", style: .Error)
                        }
                    }
                }
            } else {
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
        
        let client = BUYClient.sharedClient()
        
        client.completeCheckout(self.checkout) { (checkout, error) in
            if error == nil {
                self.checkout = checkout
            }
        }
        
        var status = BUYStatus.Unknown
        var completedCheckout = self.checkout
        let semaphore = dispatch_semaphore_create(0)
        
        do {
            client.getCompletionStatusOfCheckout(self.checkout, completion: { (checkout, buystatus, error) -> Void in
                completedCheckout = checkout
                status = buystatus
                dispatch_semaphore_signal(semaphore)
            })
            
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
            if (status == .Processing) {
                NSThread.sleepForTimeInterval(0.5)
            } else {
                // Handle success/error
                if status == .Failed {
                    SweetAlert().showAlert("Failed", subTitle: "Try Again", style: .Error)
                } else if status == .Complete {
                    SweetAlert().showAlert("Success", subTitle: "Congratulations", style: .Success)
                    // now pop everything
                }
            }
            
        } while (completedCheckout.token != nil && status != .Failed && status != .Complete)
    }
}

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
        static let NumberOfSections = 2
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

        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier(Constants.CellReuseIdentifier, forIndexPath: indexPath) as! UITableViewCell
            
            let rate = shippingRates[indexPath.row]
            cell.textLabel!.text = rate.title
            cell.detailTextLabel!.text = "$\(rate.price)"
            
            if selectedShippingIndexPath != nil {
                cell.accessoryType = .Checkmark
                selectedShipping = shippingRates[selectedShippingIndexPath!.row]
            } else {
                cell.accessoryType = .None
            }
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.CreditCardCell, forIndexPath: indexPath) as! CreditCardTableViewCell
        cell.delegate = self
        return cell

    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 80
        }
        return 44
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Select a shipping method"
        }
        return "Payment Method"
    }
    
    // MARK: - Table View Delegate
    
    // Keep track of shipping
    private var selectedShippingIndexPath: NSIndexPath?
    private var selectedShipping: BUYShippingRate? {
        didSet {
            checkout.shippingRate = selectedShipping
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
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
        
        println(self.checkout.subtotalPrice)
        println(self.checkout.totalTax)
        println(self.checkout.totalPrice)
        return
        
        // Please select a shipping method
        if self.checkout.shippingRate == nil {
            
        }
        
        // Pay by credit card
        if creditCard {
            if card.isValid() {
                BUYClient.sharedClient().storeCreditCard(card, checkout: self.checkout) { (checkout, status, error) in
                    if error == nil {
                        self.checkout = checkout
                        // now show total price
                    }
                }
            }
        }
        
        // Apple Pay
        else {
            
        }
    }
}

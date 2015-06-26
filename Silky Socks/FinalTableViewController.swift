//
//  FinalTableViewController.swift
//  Silky Socks
//
//  Created by Saurabh Jain on 6/25/15.
//  Copyright (c) 2015 Full Stak. All rights reserved.
//

import UIKit

class FinalTableViewController: UITableViewController {
    
    // Passed on from previous VC
    var checkout: BUYCheckout!
    var shippingRates: [BUYShippingRate]!
    
    // Constants
    private struct Constants {
        static let CellReuseIdentifier = "Cell"
        static let CreditCardCell = "Checkout Cell"
        static let NumberOfSections = 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerNib(UINib(nibName: "CheckoutInfoTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CreditCardCell)
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return Constants.NumberOfSections
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return section == 0 ? shippingRates.count : 2
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.CreditCardCell, forIndexPath: indexPath) as! CheckoutInfoTableViewCell
        cell.infoTextField.placeholder = indexPath.row == 0 ? "1234 5678 9012 3456" : "Hello"
        return cell

    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Select a shipping method"
        }
        return nil
    }
    
    // Keep track of shipping
    private var selectedShippingIndexPath: NSIndexPath?
    private var selectedShipping: BUYShippingRate? {
        didSet {
            checkout.shippingRate = selectedShipping
        }
    }
    
    
    // MARK: - Table View Delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            selectedShippingIndexPath = indexPath
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            return
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

}

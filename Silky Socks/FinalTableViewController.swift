//
//  FinalTableViewController.swift
//  Silky Socks
//
//  Created by Saurabh Jain on 6/25/15.
//  Copyright (c) 2015 Full Stak. All rights reserved.
//

import UIKit

class FinalTableViewController: UITableViewController {
    
    var checkout: BUYCheckout!
    var shippingRates: [BUYShippingRate]!
    
    private struct Constants {
        static let CellReuseIdentifier = "Cell"
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if section == 0 {
            return shippingRates.count
        }
        return 2
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
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
        }

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
    private var selectedShipping: BUYShippingRate?
    
    
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

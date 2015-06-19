//
//  CartTableViewController.swift
//  Silky Socks
//
//  Created by Saurabh Jain on 6/19/15.
//  Copyright (c) 2015 Full Stak. All rights reserved.
//

import UIKit

class CartTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // Table View outlet
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Title
        navigationItem.title = "Cart"
        
        // Register Cell
        tableView.registerNib(CartTableViewCell.nib(), forCellReuseIdentifier: cartCellReuseIdentifier)
        
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        // Essential
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = 150
    }

    // MARK: - Table view data source

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return UserCart.sharedCart.numberOfItems
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cartCellReuseIdentifier, forIndexPath: indexPath) as! CartTableViewCell

        // Configure the cell...
        cell.cartProduct = UserCart.sharedCart.cart[indexPath.row]

        return cell
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            UserCart.sharedCart.removeProduct(UserCart.sharedCart.cart[indexPath.row])
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
            // Wrong Code. Must be called by the presenting VC
            // But will work just fine. Coz this call will be forwarded to the presenting VC, since
            // self is not a presenting VC
            if UserCart.sharedCart.numberOfItems == 0 {
                navigationController?.popViewControllerAnimated(true)
            }
        }
    }

}

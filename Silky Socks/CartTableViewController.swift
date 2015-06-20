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
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            // Essential
            tableView.dataSource = self
            tableView.delegate = self
            
            // Row height
            tableView.rowHeight = 150
        }
    }
    
    // Cart Check Out Button
    @IBOutlet weak var checkOutButton: UIButton!
    
    // Cart Empty Label
    private var cartEmptyLabel: UILabel! {
        didSet {
            cartEmptyLabel = UILabel(frame: tableView.bounds)
            cartEmptyLabel.text = "Cart is Empty"
            cartEmptyLabel.textAlignment = .Center
            cartEmptyLabel.font = UIFont(name: "HelveticaNeue-Light", size: 48)
        }
    }
    
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
        
        // Header view
        tableView.tableHeaderView = numberOfItemsInCart == 0 ? cartEmptyLabel : nil
        
        // Show the alpha button
        checkOutButton.alpha = 1
    }

    // MARK: - Table view data source

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfItemsInCart
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cartCellReuseIdentifier, forIndexPath: indexPath) as! CartTableViewCell
        cell.cartProduct = UserCart.sharedCart.cart[indexPath.row]
        return cell
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            UserCart.sharedCart.removeProduct(UserCart.sharedCart.cart[indexPath.row])
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
            // if the number of items after deletion comes to be 0,
            // then show the label
            if numberOfItemsInCart == 0 {
                tableView.tableHeaderView = cartEmptyLabel
                
                // Hide the check out button
                UIView.animateWithDuration(0.5) { [unowned self] in
                    self.checkOutButton.alpha = 0
                }
            }
        }
    }

    // MARK: - Check Out
    
    @IBAction func didPressCheckoutButton(sender: UIButton) {
        
    }
    
}

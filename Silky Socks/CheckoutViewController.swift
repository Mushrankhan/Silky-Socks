//
//  CheckoutViewController.swift
//  Silky Socks
//
//  Created by Saurabh Jain on 6/21/15.
//  Copyright (c) 2015 Full Stak. All rights reserved.
//

import UIKit

class CheckoutViewController: UITableViewController {

    // Product
    var product: CartProduct!
    
    // Placeholders
    lazy var infoToBeAsked = [["First Name", "Last Name"], ["Street Address", "Street Address 2", "City", "State", "Zip" ,"Country"], ["Front and Back", "Size", "Quantity", "Cost"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Title
        navigationItem.title = "CheckOut"
        
        // Register Cell
        tableView.registerNib(UINib(nibName: "CheckoutInfoTableViewCell", bundle: nil), forCellReuseIdentifier: Storyboard.InfoCellReuseIdentifier)
        tableView.registerNib(UINib(nibName: "StatesPickerTableViewCell", bundle: nil), forCellReuseIdentifier: Storyboard.StatesPickerReuseIdentifier)
        
        // Set up the table header view
        let headerView = NSBundle.mainBundle().loadNibNamed("CheckoutTableHeaderView", owner: nil, options: nil).first as! CheckoutTableHeaderView
        headerView.productImageView.image = product.productImage
        tableView.tableHeaderView = headerView
        
        let footerView = NSBundle.mainBundle().loadNibNamed("CheckoutTableFooterView", owner: nil, options: nil).first as! CheckoutTableFooterView
        footerView.delegate = self
        tableView.tableFooterView = footerView
    }
    
    // Constants
    private struct Storyboard {
        static let InfoCellReuseIdentifier = "Checkout Cell"
        static let StatesPickerReuseIdentifier = "States Cell"
        static let NormalCellReuseIdentifier = "Normal"
    }
    
    // Index path at which we have the Picker View
    private var indexPathForStatesCell = NSIndexPath(forRow: 3, inSection: 1)
    
    
    // MARK: UITableView Data Source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        switch section {
            case 0:
                return 2
            case 1 :
                return 6
            case 2:
                return 4
            default:
                return 0
        }
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Special Cell for States: StatesPickerTableViewCell
        if indexPath == indexPathForStatesCell {
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.StatesPickerReuseIdentifier, forIndexPath: indexPath) as! StatesPickerTableViewCell
            cell.selectionStyle = .None
            return cell
        }
        
        // Get Info Cell: CheckoutInfoTableViewCell
        if indexPath.section < 2 {
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.InfoCellReuseIdentifier, forIndexPath: indexPath) as! CheckoutInfoTableViewCell
            cell.infoTextField.placeholder = infoToBeAsked[indexPath.section][indexPath.row]
            if cell.infoTextField.placeholder == "Country" { cell.infoTextField.text = "United States" }
            return cell
        }
        
        // Show Info Cell: UITableViewCell
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.NormalCellReuseIdentifier, forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote)
        cell.textLabel?.text = infoToBeAsked[indexPath.section][indexPath.row]
        cell.detailTextLabel?.text = ""
        if indexPath.row == 1 {
            let segmentedControl = UISegmentedControl(items: ["S", "M", "L", "XL", "XXL", "XXXL"])
            segmentedControl.tintColor = UIColor.blackColor()
            segmentedControl.selectedSegmentIndex = 2
            cell.accessoryView = segmentedControl
        }
        if indexPath.row == 2 { cell.detailTextLabel?.text = "\(product.quantity)" }
        if indexPath.row == 3 { cell.detailTextLabel?.text = "\(product.price)" }
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return ((indexPath == indexPathForStatesCell) ? 172 : self.tableView.rowHeight);
    }
    
    // MARK: UITableView Delegate

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
            case 0:
                return "Contact Info"
            case 1:
                return "Shipping Info"
            case 2:
                return "Details"
            default:
                return ""
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 2 {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
}


// MARK: Checkout Table Footer View Delegate

extension CheckoutViewController: CheckoutTableFooterViewDelegate {
    func checkOutTableFooterView(view: CheckoutTableFooterView, didPressNextButton sender: UIButton) {
        print("Next")
    }
}


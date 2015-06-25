//
//  CheckoutViewController.swift
//  Silky Socks
//
//  Created by Saurabh Jain on 6/21/15.
//  Copyright (c) 2015 Full Stak. All rights reserved.
//

import UIKit

class CheckoutViewController: UITableViewController, StatesPickerTableViewCellDelegate {

    // Product
    var product: CartProduct!
    
    // Placeholders
    lazy var infoToBeAsked = [["First Name", "Last Name", "Email"], ["Street Address", "Street Address 2", "City", "State", "Zip" ,"Country"], ["Front and Back", "Size", "Quantity", "Cost"]]
    
    // Segmented Control showing the different sizes
    private var sizesSegmentedControl: UISegmentedControl!
    
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
        
        // Next button footer view
        let footerView = NSBundle.mainBundle().loadNibNamed("CheckoutTableFooterView", owner: nil, options: nil).first as! CheckoutTableFooterView
        footerView.delegate = self
        tableView.tableFooterView = footerView
    }
    
    // Storyboard Constants
    private struct Storyboard {
        static let InfoCellReuseIdentifier = "Checkout Cell"
        static let StatesPickerReuseIdentifier = "States Cell"
        static let NormalCellReuseIdentifier = "Normal" // In Storyboard
        static let FinalTVCSegue = "FinalCheckoutSegue"
    }
    
    // Constants
    private struct Constants {
        static let ContactInfo = "Contact Info"
        static let ShippingInfo = "Shipping Info"
        static let Details = "Details"
        static let NumberOfSections = 3
        static let ContactInfoRows = 3
        static let ShippingInfoRows = 6
        static let DetialsRows = 4
    }
    
    // Index path at which we have the Picker View
    private var indexPathForStatesCell = NSIndexPath(forRow: 3, inSection: 1)
    
    // MARK: UITableView Data Source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return Constants.NumberOfSections
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        switch section {
            case 0:
                return Constants.ContactInfoRows
            case 1 :
                return Constants.ShippingInfoRows
            case 2:
                return Constants.DetialsRows
            default:
                return 0
        }
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Special Cell for States: StatesPickerTableViewCell
        if indexPath == indexPathForStatesCell {
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.StatesPickerReuseIdentifier, forIndexPath: indexPath) as! StatesPickerTableViewCell
            cell.selectionStyle = .None
            cell.delegate = self
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
            sizesSegmentedControl = UISegmentedControl(items: ["S", "M", "L", "XL", "XXL", "XXXL"])
            sizesSegmentedControl.tintColor = UIColor.blackColor()
            sizesSegmentedControl.selectedSegmentIndex = 2
            cell.accessoryView = sizesSegmentedControl
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
                return Constants.ContactInfo
            case 1:
                return Constants.ShippingInfo
            case 2:
                return Constants.Details
            default:
                return ""
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 2 {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    // MARK: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Storyboard.FinalTVCSegue {
            let vc = segue.destinationViewController as! FinalTableViewController
            vc.checkout = self.checkout
            vc.shippingRates = self.shippingRates
        }
    }
    
    // Store the shipping rates
    private var shippingRates: [BUYShippingRate]!
    private var checkout: BUYCheckout!
    
    // Selected State
    private var selectedState = "AL"
}


// MARK: StatesPickerTableViewCellDelegate

extension CheckoutViewController: StatesPickerTableViewCellDelegate {
    func statesPickerTableViewCell(cell: StatesPickerTableViewCell, didSelectState state: String) {
        selectedState = state
    }
}


// MARK: Checkout Table Footer View Delegate

extension CheckoutViewController: CheckoutTableFooterViewDelegate {
    
    func checkOutTableFooterView(view: CheckoutTableFooterView, didPressNextButton sender: UIButton) {
        
        // Shipping address
        let address = BUYAddress()
        address.firstName = "Saurabh"
        address.lastName = "Jain"
        address.address1 = "7357 Franklin Avenue"
        address.city = "Los Angeles"
        address.zip = "90046"
        address.province = selectedState
        address.countryCode = "US"
        
        // Get the product
        let client = BUYClient.sharedClient()
        client.getProductById("460236989") { (product, _) in
            
            // If product exists
            if product != nil {
                let variants = product.variants as! [BUYProductVariant]
                if variants.count > 0 {
                    let variant = variants[0] //[self.sizesSegmentedControl.selectedSegmentIndex]
                    
                    // Create Cart and add product
                    let cart = BUYCart()
                    cart.addProduct(self.product, withVariant: variant)
                    
                    // Create Checkout
                    let checkout = BUYCheckout(cart: cart)
                    checkout.shippingAddress = address
                    checkout.billingAddress = address
                    
                    client.createCheckout(checkout) { (checkout, error) in
                        if error == nil {
                            client.getShippingRatesForCheckout(checkout) { (rates, status, error) in
                                self.shippingRates = rates as! [BUYShippingRate]
                                self.checkout = checkout
                                dispatch_async(dispatch_get_main_queue()) {
                                    self.performSegueWithIdentifier(Storyboard.FinalTVCSegue, sender: nil)
                                }
                            }
                        }
                    }
                }
            }
        }
        
    }
}

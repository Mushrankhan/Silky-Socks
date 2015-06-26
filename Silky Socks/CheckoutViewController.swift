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
        navigationItem.title = "Checkout"
        
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
            cell.delegate = self
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
    
    // Selected State
    private var selectedState = "AL"
    
    // Store the shipping rates
    private var shippingRates: [BUYShippingRate]!
    private var checkout: BUYCheckout!
    
    private var address = BUYAddress()
    private var email: String?
}


// MARK: StatesPickerTableViewCellDelegate

extension CheckoutViewController: StatesPickerTableViewCellDelegate {
    func statesPickerTableViewCell(cell: StatesPickerTableViewCell, didSelectState state: String) {
        selectedState = state
    }
}


// MARK: CheckoutInfoTableViewCellDelegate

extension CheckoutViewController: CheckoutInfoTableViewCellDelegate {
    func checkoutInfoTableViewCell(cell: CheckoutInfoTableViewCell, didEnterInfo info: String) {
        let indexPath = tableView.indexPathForCell(cell)
        if let indexPath = indexPath {
            switch indexPath.section {
                case 0 :
                    switch indexPath.row {
                        case 0:
                            address.firstName = info
                        case 1:
                            address.lastName = info
                        case 2:
                            email = info
                        default:
                            break
                    }
                case 1:
                    switch indexPath.row {
                        case 0:
                            address.address1 = info
                        case 1:
                            address.address2 = info
                        case 2:
                            address.city = info
                        case 4:
                            address.zip = info
                        default:
                            break
                    }
                default:
                    break
            }
        }
    }
}

// MARK: Checkout Table Footer View Delegate

extension CheckoutViewController: CheckoutTableFooterViewDelegate {
    
    func checkOutTableFooterView(view: CheckoutTableFooterView, didPressNextButton sender: UIButton) {
        
        // Shipping address
        address.province = selectedState
        address.countryCode = "US"
        
        // Testing Purposes
        let addr = BUYAddress()
        addr.firstName = "Saurabh"
        addr.lastName = "Jain"
        addr.address1 = "7357 Franklin Avenue"
        addr.city = "Los Angeles"
        addr.province = "CA"
        addr.countryCode = "US"
        addr.zip = "90046"
        address = addr
        
        // Invalid address
        if !address.isValid() {
            println("Address not valid")
            return
        }
        
        // Invalid error
//        if email == nil || ((email! as NSString).rangeOfString(".com").location == NSNotFound) {
//            println("Enter Email")
//            return
//        }
        
        // Get the product
        let client = BUYClient.sharedClient()
        client.getProductById("1334414273") { (product, _) in
            
            // If product exists
            if product != nil {
                let variants = product.variants as! [BUYProductVariant]
                if variants.count > 0 {
                    let variant = variants[self.sizesSegmentedControl.selectedSegmentIndex]
                    
                    // Create Cart and add product
                    let cart = BUYCart()
                    cart.addProduct(self.product, withVariant: variant)
                    
                    // Create Checkout
                    let checkout = BUYCheckout(cart: cart)
                    checkout.shippingAddress = self.address
                    checkout.billingAddress = self.address
                    checkout.email = "saurabhj80@gmail.com"//self.email
                    
                    client.createCheckout(checkout) { (checkout, error) in
                        println(error)
                        if error == nil {
                            client.getShippingRatesForCheckout(checkout) { (rates, status, error) in
                                dispatch_async(dispatch_get_main_queue()) {
                                    self.checkout = checkout
                                    self.shippingRates = rates as! [BUYShippingRate]
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

//
//  CheckoutViewController.swift
//  Silky Socks
//
//  Created by Saurabh Jain on 6/21/15.
//  Copyright (c) 2015 Saurabh Jain. All rights reserved.
//

import UIKit

class CheckoutViewController: UITableViewController, StatesPickerTableViewCellDelegate {

    // Product
    var product: CartProduct!
    
    // Placeholders
    let infoToBeAsked = [["First Name", "Last Name", "Email"], ["Street Address", "Street Address 2", "City", "State", "Zip" ,"Country"], ["Front Only", "Size", "Quantity", "Cost"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Title
        navigationItem.title = "Checkout"
        
        // Register Cell
        tableView.registerNib(UINib(nibName: "CheckoutInfoTableViewCell", bundle: nil), forCellReuseIdentifier: Storyboard.InfoCellReuseIdentifier)
        tableView.registerNib(UINib(nibName: "StatesPickerTableViewCell", bundle: nil), forCellReuseIdentifier: Storyboard.StatesPickerReuseIdentifier)
        
        // Set up the table header view
        let headerView = NSBundle.mainBundle().loadNibNamed("CheckoutTableHeaderView", owner: nil, options: nil).first as! CheckoutTableHeaderView
        headerView.productImageView.image = product.cartImage
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
    
    
    // MARK: UITableView Data Source

    // Segmented Control showing the different sizes
    private var sizesSegmentedControl: UISegmentedControl!
    
    // Index path at which we have the Picker View
    private var indexPathForStatesCell = NSIndexPath(forRow: 3, inSection: 1)
    
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
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.NormalCellReuseIdentifier, forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote)
        cell.textLabel?.text = infoToBeAsked[indexPath.section][indexPath.row]
        cell.detailTextLabel?.text = ""
        cell.accessoryView = nil
        if indexPath.row == 1 {
            if self.product.productType != .Socks {
                sizesSegmentedControl = UISegmentedControl(items: ["S", "M", "L", "XL", "XXL", "XXXL"])
                sizesSegmentedControl.tintColor = UIColor.blackColor()
                sizesSegmentedControl.selectedSegmentIndex = 2
                cell.accessoryView = sizesSegmentedControl
            } else {
                cell.detailTextLabel?.text = "Standard Size"
            }

        }
        if indexPath.row == 2 { cell.detailTextLabel?.text = "\(product.quantity)" }
        if indexPath.row == 3 { cell.detailTextLabel?.text = "\(product.price)"    }
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return (indexPath == indexPathForStatesCell) ? 172 : self.tableView.rowHeight
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
            vc.productImage = self.product.checkoutImage
            self.product.checkoutImage = nil
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
extension CheckoutViewController {
    func statesPickerTableViewCell(cell: StatesPickerTableViewCell, didSelectState state: String) {
        print(state)
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

        self.email = "saurabhj80@gmail.com"

        // Invalid address
        if !address.isValid() {
            SweetAlert().showAlert("Address Not Valid", subTitle: "Enter Again", style: .Error)
            return
        }
        
        // Invalid error
        if email == nil || ((email! as NSString).rangeOfString(".com").location == NSNotFound) {
            SweetAlert().showAlert("Email Address Not Valid", subTitle: "Enter Again", style: .Error)
            return
        }
        
        // Show loading indicator
        SVProgressHUD.showWithStatus("Generating Image")
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { [unowned self] in
            
            let size = self.product.productSize
            self.product.checkoutImage = self.product.productImage.renderImageIntoSize(size)
            
            dispatch_async(dispatch_get_main_queue()) {
                
                SVProgressHUD.setStatus("Loading")
                
                // Get the product
                let client = BUYClient.sharedClient()
                let queue = OperationQueue()
                
                let op1 = ShopifyGetProduct(client: client, productId: self.product.productID) { (product, _) in
                    
                    // Get Variant
                    let variants = product.variants as! [BUYProductVariant]
                    if variants.count > 0 {
                        
                        var variant = variants[0]
                        if self.product.productType != .Socks {
                            variant = variants[self.sizesSegmentedControl.selectedSegmentIndex]
                        }

                        dispatch_async(dispatch_get_main_queue()) {
                            
                            // Create Cart and add product
                            let cart = BUYCart()
                            cart.addProduct(self.product, withVariant: variant)
                            
                            // Operation can only be created here because we wait for the cart variable
                            // And if operation 1 has some error, then this block is never called
                            let op2 = ShopifyCreateCheckout(client: client, cart: cart, address: self.address, email: self.email!, handler: { (checkout, error) -> Void in
                                
                                let op3 = ShopifyGetShippingRate(client: client, checkout: checkout) { rates in
                                    dispatch_async(dispatch_get_main_queue()) {
                                        SVProgressHUD.dismiss()
                                        self.checkout = checkout
                                        self.shippingRates = rates
                                        self.performSegueWithIdentifier(Storyboard.FinalTVCSegue, sender: nil)
                                    }
                                }
                                
                                queue.addOperation(op3)
                            })
                            
                            queue.addOperation(op2)
                        }
                    }
                }
                
                queue.addOperation(op1)
            }
        }
    }
}

//
//  CartTableViewCell.swift
//  Silky Socks
//
//  Created by Saurabh Jain on 6/19/15.
//  Copyright (c) 2015 Saurabh Jain. All rights reserved.
//

import UIKit

internal let cartCellReuseIdentifier = "Cart Cell"

class CartTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .None
    }
    
    // Nib
    class func nib() -> UINib {
        return UINib(nibName: "CartTableViewCell", bundle: nil)
    }
    
    // IBOutlets
    @IBOutlet private weak var cartImgView: UIImageView!
    @IBOutlet private weak var productNameLabel: UILabel!
    @IBOutlet private weak var quantityLabel: UILabel!
    @IBOutlet private weak var quantityStepper: UIStepper!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var basePriceLabel: UILabel! { didSet { basePriceLabel.hidden = true } }
    @IBOutlet weak var sizeSelectionStepper: UISegmentedControl! {
        didSet {
            sizeSelectionStepper.removeAllSegments()
        }
    }
    
    
    // Object passed to init self
    var cartProduct: CartProduct? {
        didSet {
            guard let cartProduct = cartProduct else { return }
            
            // Set image and product name once
            cartImgView?.image = cartProduct.cartImage
            productNameLabel?.text = cartProduct.name
            
            for (index, size) in cartProduct.sizesAvailable.enumerate() {
                sizeSelectionStepper.insertSegmentWithTitle(size, atIndex: index, animated: false)
                sizeSelectionStepper.setWidth(30, forSegmentAtIndex: index)
            }
            sizeSelectionStepper.selectedSegmentIndex = 1
            cartProduct.selectedSize = (cartProduct.sizesAvailable[1], 1)
            
            // Update UI
            updateUI()
        }
    }
    
    deinit {
        cartProduct = nil
        cartImgView = nil
        productNameLabel = nil
        quantityLabel = nil
        quantityStepper = nil
        priceLabel = nil
        basePriceLabel = nil
        sizeSelectionStepper = nil
    }
    
    // Stepper IBAction
    @IBAction func incrementQuantity(sender: UIStepper) {
        cartProduct!.quantity = Int(sender.value)  // Increase quantity in the model
        updateUI()
    }
    
    /* Updates the UI based on the model */
    private func updateUI() {
        quantityLabel?.text     = "\(cartProduct!.quantity)"
        quantityStepper?.value  = Double(cartProduct!.quantity)
        priceLabel?.text        = "$ \(cartProduct!.price).00"
        basePriceLabel?.text    = "$ \(cartProduct!.basePrice).00/pc"
    }
    
    @IBAction func sizeSelection(sender: UISegmentedControl) {
        cartProduct!.selectedSize = (cartProduct!.sizesAvailable[sender.selectedSegmentIndex], sender.selectedSegmentIndex)
    }
    
}

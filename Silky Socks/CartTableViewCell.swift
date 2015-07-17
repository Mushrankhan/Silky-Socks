//
//  CartTableViewCell.swift
//  Silky Socks
//
//  Created by Saurabh Jain on 6/19/15.
//  Copyright (c) 2015 Saurabh Jain. All rights reserved.
//

import UIKit

let cartCellReuseIdentifier = "Cart Cell"

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
    @IBOutlet weak var basePriceLabel: UILabel! { didSet { basePriceLabel.hidden = true } }
    
    // Object passed to init self
    var cartProduct: CartProduct? {
        didSet {
            // Set image and product name once
            cartImgView?.image = cartProduct?.productImage
            productNameLabel?.text = cartProduct?.name
            
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
    }
    
    // Stepper IBAction
    @IBAction func incrementQuantity(sender: UIStepper) {
        cartProduct!.quantity = Int(sender.value)        // Increase quantity in the model
        updateUI()
    }
    
    private func updateUI() {
        quantityLabel?.text = "\(cartProduct!.quantity)"
        quantityStepper?.value = Double(cartProduct!.quantity)
        priceLabel?.text = "$ \(cartProduct!.price).00"
        basePriceLabel?.text = "$ \(cartProduct!.basePrice).00/pc"
    }
}

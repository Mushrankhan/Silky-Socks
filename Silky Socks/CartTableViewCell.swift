//
//  CartTableViewCell.swift
//  Silky Socks
//
//  Created by Saurabh Jain on 6/19/15.
//  Copyright (c) 2015 Full Stak. All rights reserved.
//

import UIKit

let cartCellReuseIdentifier = "Cart Cell"

class CartTableViewCell: UITableViewCell {

    // Nib
    class func nib() -> UINib {
        return UINib(nibName: "CartTableViewCell", bundle: nil)
    }
    
    // IBOutlets
    @IBOutlet private weak var cartImgView: UIImageView!
    @IBOutlet private weak var cartProductName: UILabel!
    @IBOutlet private weak var cartQuantity: UILabel! {
        didSet {
            if let product = cartProduct {
                product.price  = Float(product.quantity) * product.basePrice
            }
        }
    }
    
    // Object passed to init self
    var cartProduct: CartProduct? {
        didSet {
            cartImgView?.image = cartProduct?.productImage
            cartProductName?.text = cartProduct?.name
            cartQuantity?.text = "\(cartProduct!.quantity)"
        }
    }
    
    // Stepper IBAction
    @IBAction func incrementQuantity(sender: UIStepper) {
        cartProduct!.quantity = Int(sender.value)
        cartQuantity?.text = "\(cartProduct!.quantity)"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .None
    }
}

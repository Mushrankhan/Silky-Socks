//
//  DiscountTableViewCell.swift
//  Silky Socks
//
//  Created by Saurabh Jain on 6/30/15.
//  Copyright (c) 2015 Saurabh Jain. All rights reserved.
//

import UIKit

protocol DiscountTableViewCellDelegate: class {
    func discountTableViewCell(cell: DiscountTableViewCell, didEnterDiscountCode code: String)
}

class DiscountTableViewCell: UITableViewCell, UITextFieldDelegate {

    weak var delegate: DiscountTableViewCellDelegate?
    
    @IBOutlet weak var discountTextField: UITextField! {
        didSet {
            discountTextField.delegate = self
            discountTextField.returnKeyType = .Done
        }
    }

    // UITextField Delegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        delegate?.discountTableViewCell(self, didEnterDiscountCode: textField.text ?? "")
    }
    
}

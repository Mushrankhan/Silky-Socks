//
//  CheckoutInfoTableViewCell.swift
//  Silky Socks
//
//  Created by Saurabh Jain on 6/21/15.
//  Copyright (c) 2015 Full Stak. All rights reserved.
//

import UIKit

protocol CheckoutInfoTableViewCellDelegate: class {
    func checkoutInfoTableViewCell(cell: CheckoutInfoTableViewCell, didEnterInfo info: String)
}

class CheckoutInfoTableViewCell: UITableViewCell, UITextFieldDelegate {

    // Delegate
    weak var delegate: CheckoutInfoTableViewCellDelegate?
    
    // The text field
    @IBOutlet weak var infoTextField: UITextField! { didSet { infoTextField.delegate = self } }
    
    // MARK: UITextField Delegate
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if infoTextField.text == "United States" {
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        delegate?.checkoutInfoTableViewCell(self, didEnterInfo: textField.text)
    }
    
}

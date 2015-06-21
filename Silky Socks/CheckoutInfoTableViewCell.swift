//
//  CheckoutInfoTableViewCell.swift
//  Silky Socks
//
//  Created by Saurabh Jain on 6/21/15.
//  Copyright (c) 2015 Full Stak. All rights reserved.
//

import UIKit

class CheckoutInfoTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var infoTextField: UITextField! {
        didSet {
            infoTextField.delegate = self
        }
    }
    
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
    
}

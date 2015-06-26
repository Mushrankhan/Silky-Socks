//
//  CreditCardTableViewCell.swift
//  Silky Socks
//
//  Created by Saurabh Jain on 6/26/15.
//  Copyright (c) 2015 Full Stak. All rights reserved.
//

import UIKit

class CreditCardTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var creditCardNumber: UITextField! { didSet { conformToDelegate(creditCardNumber) } }
    @IBOutlet weak var month: UITextField! { didSet { conformToDelegate(month) } }
    @IBOutlet weak var year: UITextField! { didSet { conformToDelegate(year) } }
    @IBOutlet weak var cvv: UITextField! { didSet { conformToDelegate(cvv) } }
    
    final private func conformToDelegate(textField: UITextField) {
        textField.delegate = self
    }
    
    // MARK: - UITextField Delegate
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        var length = 0
        if textField == creditCardNumber {
            length = 16
        } else if textField == month {
            length = 2
        } else if textField == year {
            length = 4
        } else {
            length = 3
        }
        
        return count(textField.text) + count(string) - range.length <= length
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
//
//  CreditCardTableViewCell.swift
//  Silky Socks
//
//  Created by Saurabh Jain on 6/26/15.
//  Copyright (c) 2015 Saurabh Jain. All rights reserved.
//

import UIKit

protocol CreditCardTableViewCellDelegate: class {
    func creditCardTableViewCell(cell: CreditCardTableViewCell, didEnterCreditCard creditCard: String)
    func creditCardTableViewCell(cell: CreditCardTableViewCell, didEnterExpiryMonth expiryMonth: String)
    func creditCardTableViewCell(cell: CreditCardTableViewCell, didEnterExpiryYear expiryYear: String)
    func creditCardTableViewCell(cell: CreditCardTableViewCell, didEnterCVV cvv: String)
}

class CreditCardTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    // Delegate
    weak var delegate: CreditCardTableViewCellDelegate?
    
    @IBOutlet weak var creditCardNumber: UITextField!   { didSet { setUp(creditCardNumber) } }
    @IBOutlet weak var month: UITextField!              { didSet { setUp(month) } }
    @IBOutlet weak var year: UITextField!               { didSet { setUp(year)  } }
    @IBOutlet weak var cvv: UITextField!                { didSet { setUp(cvv)   } }
    
    override func awakeFromNib() {
        selectionStyle = .None
    }
    
    final private func setUp(textField: UITextField) {
        textField.delegate = self
        textField.keyboardType = .NumberPad
        NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: NSOperationQueue.mainQueue()) { [unowned self] notification in
            if let text = (notification.object as? UITextField)?.text {
                if textField == self.creditCardNumber {
                    self.delegate?.creditCardTableViewCell(self, didEnterCreditCard: text)
                } else if textField == self.month {
                    self.delegate?.creditCardTableViewCell(self, didEnterExpiryMonth: text)
                } else if textField == self.year {
                    self.delegate?.creditCardTableViewCell(self, didEnterExpiryYear: text)
                } else {
                    self.delegate?.creditCardTableViewCell(self, didEnterCVV: text)
                }
            }
        }
    }
    
    // MARK: - UITextField Delegate
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String)  -> Bool {

        var length = 0        
        switch textField {
            case creditCardNumber:
                length = 16
            case month:
                length = 2
            case year:
                length = 4
            case cvv:
                length = 3
            default:
                break
        }
        
        return textField.text!.characters.count + string.characters.count - range.length <= length
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


class CreditView: UIView {
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        CGContextMoveToPoint(context, 0, rect.height/2)
        CGContextAddLineToPoint(context, rect.width, rect.height/2)
        UIColor(red: 0.783922, green: 0.780392, blue: 0.8, alpha: 1).setStroke()
        CGContextSetLineWidth(context, 0.5)
        CGContextStrokePath(context)
        
        CGContextMoveToPoint(context, rect.width/3, rect.height/2)
        CGContextAddLineToPoint(context, rect.width/3, rect.height)
        CGContextStrokePath(context)
        
        CGContextMoveToPoint(context, 2*rect.width/3, rect.height/2)
        CGContextAddLineToPoint(context, 2*rect.width/3, rect.height)
        CGContextStrokePath(context)
    }
}

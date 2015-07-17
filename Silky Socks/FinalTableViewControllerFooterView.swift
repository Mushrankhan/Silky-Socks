//
//  FinalTableViewControllerFooterView.swift
//  Silky Socks
//
//  Created by Saurabh Jain on 6/26/15.
//  Copyright (c) 2015 Saurabh Jain. All rights reserved.
//

import UIKit

protocol FinalTableViewControllerFooterViewDelegate: class {
    func payByCreditCard(creditCard: Bool)
}

class FinalTableViewControllerFooterView: UIView {

    // Delegate
    weak var delegate: FinalTableViewControllerFooterViewDelegate?
    
    // Hide it for now
    // Apple Pay UI
    @IBOutlet weak var firstLine: UIView! { didSet { firstLine.hidden = true } }
    @IBOutlet weak var secondLine: UIView! { didSet { secondLine.hidden = true } }
    @IBOutlet weak var orLabel: UILabel! { didSet { orLabel.hidden = true } }
    @IBOutlet weak var applePayButton: UIButton! { didSet { applePayButton.hidden = true } }
    
    @IBAction func payByCreditCard(sender: UIButton) {
        delegate?.payByCreditCard(true)
    }
    
    @IBAction func payUsingApplePay(sender: UIButton) {
        delegate?.payByCreditCard(false)
    }
}

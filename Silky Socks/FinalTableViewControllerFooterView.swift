//
//  FinalTableViewControllerFooterView.swift
//  Silky Socks
//
//  Created by Saurabh Jain on 6/26/15.
//  Copyright (c) 2015 Full Stak. All rights reserved.
//

import UIKit

protocol FinalTableViewControllerFooterViewDelegate: class {
    func payByCreditCard(creditCard: Bool)
}

class FinalTableViewControllerFooterView: UIView {

    // Delegate
    weak var delegate: FinalTableViewControllerFooterViewDelegate?
    
    @IBAction func payByCreditCard(sender: UIButton) {
        delegate?.payByCreditCard(true)
    }
    
    @IBAction func payUsingApplePay(sender: UIButton) {
        delegate?.payByCreditCard(false)
    }
}

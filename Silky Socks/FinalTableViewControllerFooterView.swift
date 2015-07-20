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
    func agreeToTermsAndConditions()
}

class FinalTableViewControllerFooterView: UIView {

    // Delegate
    weak var delegate: FinalTableViewControllerFooterViewDelegate?
    
    @IBAction private func payByCreditCard(sender: UIButton) {
        delegate?.payByCreditCard(true)
    }
    
    @IBAction private func termsAndConditionsButtonPressed() {
        delegate?.agreeToTermsAndConditions()
    }

}

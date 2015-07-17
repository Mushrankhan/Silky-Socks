//
//  CheckoutTableFooterView.swift
//  Silky Socks
//
//  Created by Saurabh Jain on 6/22/15.
//  Copyright (c) 2015 Saurabh Jain. All rights reserved.
//

import UIKit

protocol CheckoutTableFooterViewDelegate: class {
    func checkOutTableFooterView(view: CheckoutTableFooterView, didPressNextButton sender: UIButton)
}

class CheckoutTableFooterView: UIView {

    // Delegate
    weak var delegate: CheckoutTableFooterViewDelegate?
    
    @IBAction func nextButtonClecked(sender: UIButton) {
        delegate?.checkOutTableFooterView(self, didPressNextButton: sender)
    }
}


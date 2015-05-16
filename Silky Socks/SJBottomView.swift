//
//  SJBottomView.swift
//  Silky Socks
//
//  Created by Kevin Koeller on 4/19/15.
//  Copyright (c) 2015 Full Stak. All rights reserved.
//

import UIKit

protocol SJBottomViewDelegate: NSObjectProtocol {
    
    func sj_bottomView(view: SJBottomView, didPressRightButton button:SJButton)
    func sj_bottomView(view: SJBottomView, didPressLeftButton button:SJButton)
}

class SJBottomView: UIView {

    // the delegate object
    weak var delegate: SJBottomViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        self.setTranslatesAutoresizingMaskIntoConstraints(false)
    }
}

// Navigation Button
extension SJBottomView {
    
    @IBAction func didPressNextButton(sender: SJButton) {
        delegate?.sj_bottomView(self, didPressRightButton: sender)
    }
    
    @IBAction func didPressPreviousButton(sender: SJButton) {
        delegate?.sj_bottomView(self, didPressLeftButton: sender)
    }
}

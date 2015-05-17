//
//  SJBottomView.swift
//  Silky Socks
//
//  Created by Kevin Koeller on 4/19/15.
//  Copyright (c) 2015 Full Stak. All rights reserved.
//

import UIKit

protocol SJBottomViewDelegate: NSObjectProtocol {
    
    func sj_bottomView(view: SJBottomView, didPressRightButton button:UIButton)
    func sj_bottomView(view: SJBottomView, didPressLeftButton button:UIButton)
}

public let utilitiesReuseIdentifier = "UtilitiesReuseIdentifier"
public let utilitiesElementkind = "Utilities"

class SJBottomView: UICollectionReusableView {

    // the delegate object
    weak var delegate: SJBottomViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        autoresizingMask = .FlexibleWidth | .FlexibleHeight
        setTranslatesAutoresizingMaskIntoConstraints(false)
    }
}

// Navigation Button
extension SJBottomView {
    
    @IBAction func didPressNextButton(sender: UIButton) {
        delegate?.sj_bottomView(self, didPressRightButton: sender)
    }
    
    @IBAction func didPressPreviousButton(sender: UIButton) {
        delegate?.sj_bottomView(self, didPressLeftButton: sender)
    }
}

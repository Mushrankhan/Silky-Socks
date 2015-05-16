//
//  SJBottomView.swift
//  Silky Socks
//
//  Created by Kevin Koeller on 4/19/15.
//  Copyright (c) 2015 Full Stak. All rights reserved.
//

import UIKit

class SJBottomView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        self.setTranslatesAutoresizingMaskIntoConstraints(false)
    }
}

// Navigation Button
extension SJBottomView {
    
    @IBAction func didPressNextButton(sender: SJButton) {
        
    }

}

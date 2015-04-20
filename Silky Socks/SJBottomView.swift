//
//  SJBottomView.swift
//  Silky Socks
//
//  Created by Kevin Koeller on 4/19/15.
//  Copyright (c) 2015 Full Stak. All rights reserved.
//

import UIKit

@IBDesignable
class SJBottomView: UIView {

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        
        self.setTranslatesAutoresizingMaskIntoConstraints(false)
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}

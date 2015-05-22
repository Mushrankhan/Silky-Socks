//
//  SJLabel.swift
//  Silky Socks
//
//  Created by Saurabh Jain on 5/21/15.
//  Copyright (c) 2015 Full Stak. All rights reserved.
//

import UIKit

class SJLabel: UILabel {
    
    init() {
        super.init(frame: .zeroRect)
        initialSetUp()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetUp()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialSetUp()
    }
    
    private func initialSetUp() {
        numberOfLines = 0
        userInteractionEnabled = true
        backgroundColor = UIColor.clearColor()
    }
}
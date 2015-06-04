//
//  SJLabel.swift
//  Silky Socks
//
//  Created by Saurabh Jain on 5/21/15.
//  Copyright (c) 2015 Full Stak. All rights reserved.
//

import UIKit

class SJLabel: UILabel {
    
    // When instatiated from storyboard
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialSetUp()
    }
    
    // Custom Init
    init(frame: CGRect, text: String, font: UIFont) {
        super.init(frame: frame)
        self.text = text
        self.font = font
        initialSetUp()
    }
    
    // Basic Set Up
    private func initialSetUp() {
        numberOfLines = 1
        backgroundColor = UIColor.clearColor()
        contentMode = .Redraw
        textAlignment = .Center
        adjustsFontSizeToFitWidth = true
    }
}
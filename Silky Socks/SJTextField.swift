//
//  SJTextField.swift
//  Silky Socks
//
//  Created by Saurabh Jain on 5/21/15.
//  Copyright (c) 2015 Saurabh Jain. All rights reserved.
//

import UIKit

class SJTextField: UITextField {

    // When instantiated in code
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetUp()
    }

    // When instantiated in storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialSetUp()
    }
    
    // Basic Setup
    private func initialSetUp() {
        backgroundColor = UIColor.clearColor()
        textAlignment = .Center
        font = UIFont(name: "Helvetica Neue", size: UIFont.AppFontSize())
        textColor = UIColor.blackColor()
        returnKeyType = .Done
        tintColor = UIColor.blackColor()
    }
    
}
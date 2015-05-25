//
//  SJTextField.swift
//  Silky Socks
//
//  Created by Saurabh Jain on 5/21/15.
//  Copyright (c) 2015 Full Stak. All rights reserved.
//

import UIKit

class SJTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetUp()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialSetUp()
    }
    
    private func initialSetUp() {
        backgroundColor = UIColor.clearColor()
        textAlignment = .Center
        font = UIFont(name: "Helvetica Neue", size: 42.0)
        textColor = UIColor.blackColor()
        returnKeyType = .Done
        tintColor = UIColor.blackColor()
    }
    
}
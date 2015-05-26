//
//  SJLabel.swift
//  Silky Socks
//
//  Created by Saurabh Jain on 5/21/15.
//  Copyright (c) 2015 Full Stak. All rights reserved.
//

import UIKit

class SJLabel: UILabel {
    
    var maskImage: UIImage?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetUp()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialSetUp()
    }
    
    init(frame: CGRect, text: String, font: UIFont, maskImage: UIImage) {
        super.init(frame: frame)
        self.text = text
        self.font = font
        self.maskImage = maskImage
        initialSetUp()
    }
    
    private func initialSetUp() {
        numberOfLines = 1
        backgroundColor = UIColor.clearColor()
        contentMode = .Redraw
        textAlignment = .Center
        adjustsFontSizeToFitWidth = true
    }
    
    override func drawRect(rect: CGRect) {
        let context : CGContextRef = UIGraphicsGetCurrentContext()
        let flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, rect.size.height)
        CGContextConcatCTM(context, flipVertical)
        
        let maskRect = CGRect(x: -self.frame.origin.x, y: self.frame.origin.y, width: rect.size.width, height: rect.size.height);
        
        CGContextClipToMask(context, maskRect, self.maskImage!.CGImage)
        
//        CGContextSetRGBFillColor(context, 1, 0, 0, 0.5)
//        CGContextFillRect(context, rect);

        CGContextConcatCTM(context, flipVertical)
        super.drawRect(rect)
    }

}
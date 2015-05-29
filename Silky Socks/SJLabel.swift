//
//  SJLabel.swift
//  Silky Socks
//
//  Created by Saurabh Jain on 5/21/15.
//  Copyright (c) 2015 Full Stak. All rights reserved.
//

import UIKit

class SJLabel: UILabel {
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetUp()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialSetUp()
    }
    
    init(frame: CGRect, text: String, font: UIFont) {
        super.init(frame: frame)
        self.text = text
        self.font = font
        initialSetUp()
    }
    
    private func initialSetUp() {
        numberOfLines = 1
        backgroundColor = UIColor.clearColor()
        contentMode = .Redraw
        textAlignment = .Center
        adjustsFontSizeToFitWidth = true
    }
}


//class BoundingView: UIView {
//    
//    var maskImage: UIImage?
//    
//    override func drawRect(rect: CGRect) {
//        
//        let context = UIGraphicsGetCurrentContext()
//        CGContextTranslateCTM(context, 0, rect.size.height)
//        CGContextScaleCTM(context, 1, -1)
//        
//        CGContextSetRGBFillColor(context, 0, 0, 1, 0.5)
//        CGContextFillRect(context, rect)
//        
//        let image = maskImage!.colorizeWith(UIColor.yellowColor())
//        CGContextDrawImage(context, rect, image.CGImage)
//        CGContextClipToMask(context, rect, image.CGImage)
//        
//        CGContextSetRGBFillColor(context, 0, 1, 0, 0.5)
//        CGContextFillRect(context, CGRectMake(0, 0, 100, 100))
//    }
//    
//}
//
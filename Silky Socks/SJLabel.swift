//
//  SJLabel.swift
//  Silky Socks
//
//  Created by Saurabh Jain on 5/21/15.
//  Copyright (c) 2015 Full Stak. All rights reserved.
//

import UIKit

class SJLabel: UILabel {

//    // The pinch associated with the label
//    private var pinch: UIPinchGestureRecognizer!
//    private var pan: UIPanGestureRecognizer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetUp()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialSetUp()
    }
    
    private func initialSetUp() {
        // basic
        numberOfLines = 0
        userInteractionEnabled = true
        
//        pan = UIPanGestureRecognizer(target: self, action: "handlePan:")
//        pan.delaysTouchesBegan = true
//        pan.delegate = self
//        addGestureRecognizer(pan)
//        
//        pinch = UIPinchGestureRecognizer(target: self, action: "handlePin:")
//        addGestureRecognizer(pinch)
    }
}

extension SJLabel: UIGestureRecognizerDelegate {
    
//    @objc private func handlePan(recognizer: UIPanGestureRecognizer) {
//        
//        let location = recognizer.locationInView(self)
//        print(location)
//    }
//    
//    @objc private func handlePin(recognizer: UIPinchGestureRecognizer) {
//        if recognizer.numberOfTouches() != 2 {
//            return
//        }
//
//        var fontSize = font.pointSize
//        fontSize = ((recognizer.velocity > 0) ? 1 : -1) * 1 + fontSize;
//
//        if (fontSize < 13) { fontSize = 13 }
//        if (fontSize > 42) { fontSize = 42 }
//
//        font = UIFont(name: font.fontName, size: fontSize)
//
//        let scale = recognizer.scale
//        transform = CGAffineTransformMakeScale(scale/2, scale/2)
//    }
    
    //    func handlePan(recognizer: UIPanGestureRecognizer) {
    //        if let label = label {
    //            let location = recognizer.locationInView(self)
    //            if CGRectContainsPoint(label.frame, location) {
    //                label.center = location
    //            }
    //            //recognizer.setTranslation(CGPoint.zeroPoint, inView: label)
    //        }
    //    }

}

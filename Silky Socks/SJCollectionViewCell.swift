//
//  SJCollectionViewCell.swift
//  Silky Socks
//
//  Created by Kevin Koeller on 4/19/15.
//  Copyright (c) 2015 Full Stak. All rights reserved.
//

import UIKit

public let reuseIdentifier = "Cell"

class SJCollectionViewCell: UICollectionViewCell {

    // IBOutlets
    @IBOutlet weak var ss_imgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    // The Label
    var sj_label: SJLabel?

    // The pan gesture recognizer
    private var panGestureRecognizer: UIPanGestureRecognizer!

    // Template object
    var template:Template? {
        didSet {
            if let template = template {
                ss_imgView?.image = template.image
                nameLabel.text = template.caption
            }
        }
    }
    
    // Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        autoresizingMask = UIViewAutoresizing.FlexibleHeight | .FlexibleWidth
        setTranslatesAutoresizingMaskIntoConstraints(false)
        clipsToBounds = true
        
        // Pan
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handlePan:")
        panGestureRecognizer.delaysTouchesBegan = true
        addGestureRecognizer(panGestureRecognizer)
    }
    
    // Apply Layout Attributes
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes!) {
        if let attr = layoutAttributes {
            self.frame = attr.frame
        }
    }
    
    // Create the text label
    func createLabel(text: String, font: UIFont) {
        
        let midX = CGRectGetMidX(bounds)
        let midY = CGRectGetMidY(bounds)
        
        // SJLabel comes with a pinch and pan gesture support
        sj_label = SJLabel(frame: .zeroRect)
        sj_label!.text = text
        sj_label!.font = font
        // Adjust size based on text and font
        sj_label!.sizeToFit()
        // Call this after setting the size
        sj_label!.center = CGPoint(x: midX, y: midY)
        // Add subview
        addSubview(sj_label!)
    }
    
}

// MARK: Gesture Support
extension SJCollectionViewCell {
    
    // Handle Pan Gesture
    @objc private func handlePan(recognizer: UIPanGestureRecognizer) {
        let location = recognizer.locationInView(self)
        if let sj_label = sj_label {
            if CGRectContainsPoint(sj_label.frame, location) {
                sj_label.center = location
            }
        }
    }
    
//
//    @objc private func handlePin(recognizer: UIPinchGestureRecognizer) {
//        if recognizer.numberOfTouches() != 2 {
//            return
//        }
//        
////        var fontSize = font.pointSize
////        fontSize = ((recognizer.velocity > 0) ? 1 : -1) * 1 + fontSize;
////        
////        if (fontSize < 13) { fontSize = 13 }
////        if (fontSize > 42) { fontSize = 42 }
////        
////        font = UIFont(name: font.fontName, size: fontSize)
//        
//        let scale = recognizer.scale
//        transform = CGAffineTransformMakeScale(scale/2, scale/2)
//    }
    
}

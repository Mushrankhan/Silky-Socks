//
//  SJCollectionViewCell.swift
//  Silky Socks
//
//  Created by Saurabh Jain on 4/19/15.
//  Copyright (c) 2015 Full Stak. All rights reserved.
//

import UIKit

// Cell Reuse identifier
public let reuseIdentifier = "Cell"

class SJCollectionViewCell: UICollectionViewCell {

    // IBOutlets
    @IBOutlet weak var ss_imgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    // The Label
    var sj_label: SJLabel?

    // The pan gesture recognizer
    private var panGestureRecognizer: UIPanGestureRecognizer!
    
    // The pinch gesture recognizer
    private var pinchGestureRecognizer: UIPinchGestureRecognizer!
    
    // The rotation gesture
    private var rotateGestureRecognizer: UIRotationGestureRecognizer!

    // Used in pan calculations
    private var firstX: CGFloat = 0
    private var firstY: CGFloat = 0
    
    // Template object
    var template:Template? {
        didSet {
            if let template = template {
                ss_imgView?.image = template.image
                nameLabel.text = template.caption
            }
        }
    }
    
    // Set containing the gesture - rotate and pinch
    private var activeRecognizers = NSMutableSet()
    
    // initial transform
    private var referenceTransform: CGAffineTransform?
    
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
        
        // Pinch
        pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: "handleGesture:")
        pinchGestureRecognizer.delaysTouchesBegan = true
        addGestureRecognizer(pinchGestureRecognizer)
        
        // Rotate
        rotateGestureRecognizer = UIRotationGestureRecognizer(target: self, action: "handleGesture:")
        rotateGestureRecognizer.delaysTouchesBegan = true
        rotateGestureRecognizer.delegate = self
        addGestureRecognizer(rotateGestureRecognizer)
        
    }
    
    // Add the label as a subview of boundingRectView
    // Is a view around the image because the image is smaller than the image view
    private var boundingRectView: UIView?
    
    // Aspect Fit
    private func addClipRect() {
        
        if let view = boundingRectView {
            view.removeFromSuperview()
            boundingRectView = nil
        }
        
        let aspectRatio = template!.image.size
        var boundingSize = ss_imgView.frame.size
        
        let mW = boundingSize.width / aspectRatio.width;
        let mH = boundingSize.height / aspectRatio.height;
        if mH < mW {
            boundingSize.width = boundingSize.height / aspectRatio.height * aspectRatio.width
        } else if mW < mH {
            boundingSize.height = boundingSize.width / aspectRatio.width * aspectRatio.height
        }
        
        // Create the bounding rect
        let x = (ss_imgView.frame.width - boundingSize.width)/2 + 5
        let y = (ss_imgView.frame.height - boundingSize.height)/2 + 20
        let frame = CGRectMake(x, y, boundingSize.width - 10, boundingSize.height - 5)
        boundingRectView = UIView(frame: frame)
        boundingRectView!.clipsToBounds = true
        addSubview(boundingRectView!)
    }
    
    // Apply Layout Attributes
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes!) {
        if let attr = layoutAttributes {
            self.frame = attr.frame
        }
    }
    
    // Create the text label
    func createLabel(text: String, font: UIFont) {
        
        // Create and add the bounding rect
        addClipRect()
        
        // Create the text label
        sj_label = SJLabel(frame: .zeroRect)
        sj_label!.text = text
        sj_label!.font = font
        sj_label!.sizeToFit()
        sj_label!.frame.origin = CGPoint(x: 0, y: 0)
        
        // Add subview
        boundingRectView?.addSubview(sj_label!)
    }
    
}

// MARK: Gesture Support
extension SJCollectionViewCell: UIGestureRecognizerDelegate {
    
    // Handle Pan Gesture
    @objc private func handlePan(recognizer: UIPanGestureRecognizer) {
        
        if let sj_label = sj_label {
            var translatedpoint = recognizer.translationInView(self)
            
            if recognizer.state == .Began {
                firstX = sj_label.center.x
                firstY = sj_label.center.y
            }
            
            translatedpoint = CGPointMake(firstX + translatedpoint.x, firstY + translatedpoint.y);
            sj_label.center = translatedpoint
        }
    }
    
    // Handle Rotate and Pinch Gesture
    @objc private func handleGesture(recognizer: UIGestureRecognizer) {
        
        switch recognizer.state {
            
        case .Began:
            if activeRecognizers.count == 0 {
                referenceTransform = sj_label?.transform
            }
            activeRecognizers.addObject(recognizer)
            
        case .Ended:
            referenceTransform = applyRecognizer(recognizer, toTransform: referenceTransform!)
            activeRecognizers.removeObject(recognizer)
            
        case .Changed:
            var transform = referenceTransform
            for gesture in activeRecognizers {
                transform = applyRecognizer(gesture as! UIGestureRecognizer, toTransform: transform!)
            }
            sj_label?.transform = transform!
            
        default:
            break
        }
        
    }
    
    // Helper Function
    final private func applyRecognizer(recognizer: UIGestureRecognizer, toTransform transform:CGAffineTransform) -> CGAffineTransform {
        
        if recognizer.respondsToSelector("rotation") {
            return CGAffineTransformRotate(transform, (recognizer as! UIRotationGestureRecognizer).rotation)
        } else if recognizer.respondsToSelector("scale") {
            let scale = (recognizer as! UIPinchGestureRecognizer).scale
            return CGAffineTransformScale(transform, scale, scale)
        }
        
        return transform
        
    }
    
    // Important - Handle Pinch and rotate simultaneously
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
     //Handle Pinch
//    @objc private func handlePinch(recognizer: UIPinchGestureRecognizer) {
//    
//        // Base Case
//        if recognizer.numberOfTouches() != 2 {
//            return
//        }
//
//        if recognizer.state == .Changed {
//            
//            if let sj_label = sj_label {
//                
//                // Increasing font size
//                var fontSize = sj_label.font.pointSize
//                fontSize = ((recognizer.velocity > 0) ? 1 : -1) * 1 + fontSize
//                
//                // Bounds
//                if (fontSize < 13) { fontSize = 13 }
//                if (fontSize > 100) { fontSize = 100 }
//                
//                // Change the font
//                sj_label.font = UIFont(name: sj_label.font.fontName, size: fontSize)
//                
//                // Setting a new size for the frame and forcing it to re draw to get crisp text
//                let str: NSString = sj_label.text!
//                let size = str.boundingRectWithSize(CGSize(width: 400, height: CGFloat.max), options: NSStringDrawingOptions.UsesFontLeading | NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: sj_label.font], context: nil).size
//                sj_label.frame.size = size
//            }
//
//        }
//    }
}

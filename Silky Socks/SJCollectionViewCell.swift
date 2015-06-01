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
    
    // Array containing all the views added to the template
    var sj_subViews = [UIView]()
    
    // Last selected view
    private var lastSelectedView: UIView?
    
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
    // Called when instantiated from nib
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
    
    // Prepare for reuse
    override func prepareForReuse() {
        super.prepareForReuse()
//        for view in sj_subViews {
//            view.removeFromSuperview()
//        }
//        sj_subViews.removeAll(keepCapacity: true)
//        boundingRectView?.removeFromSuperview()
//        boundingRectView = nil
    }
    
    // Apply Layout Attributes
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes!) {
        if let attr = layoutAttributes {
            self.frame = attr.frame
        }
    }
    
    // Add the label as a subview of boundingRectView
    // Is a view around the image because the image is smaller than the image view
    private(set) var boundingRectView: UIView?
    
    // Masking that is applied to the boundingRectView
    private var maskImageView: UIImageView?
    
    // Aspect Fit
    private func addClipRect() {
        
        if let view = boundingRectView {
            view.removeFromSuperview()
            boundingRectView = nil
        }
        
        // Alloc the bounding View
        boundingRectView = UIView(frame: ss_imgView.frame)
        
        // Masking
        maskImageView = UIImageView(frame: boundingRectView!.bounds)
        maskImageView?.contentMode = .ScaleAspectFit
        maskImageView?.image = template!.image
        boundingRectView?.maskView = maskImageView
        
        addSubview(boundingRectView!)
    }
    
    // Create the text label
    func createLabel(text: String, font: UIFont, color: UIColor) {
        
        // Create and add the bounding rect
        if boundingRectView == nil {
            addClipRect()
        }
        
        // Create the text label
        let sj_label = SJLabel(frame: .zeroRect, text: text, font: font)
        //sj_label.frame = boundingRectView!.frame
        sj_label.frame.size.width = CGRectGetWidth(boundingRectView!.frame)
        sj_label.textColor = color
        sj_label.sizeToFit()
        sj_label.center = CGPoint(x: boundingRectView!.center.x, y: boundingRectView!.center.y)
        
        // Add the label to the array of sub views
        sj_subViews.insert(sj_label, atIndex: 0)

        // Make sure that the last selected view
        // has a value
        lastSelectedView = sj_label
        
        // Add subview
        boundingRectView?.addSubview(sj_label)
    }
    
    // Create Image
    func createImage(image: UIImage) {
        
//        // Create and add the bounding rect
//        if boundingRectView == nil {
//            addClipRect()
//        }
//        
//        // Create the image
//        let sj_imgView = UIImageView(frame: bounds)
//        sj_imgView.contentMode = .ScaleAspectFill
//        sj_imgView.image = image
//        
//        // Add it to the array of subviews
//        sj_subViews.insert(sj_imgView, atIndex: 0)
//        
//        // Make sure that the last selected view
//        // has a value
//        lastSelectedView = sj_imgView
//        
//        // Add subview
//        boundingRectView?.addSubview(sj_imgView)
        
//        let image = ss_imgView.image?.drawImage(image)
//        ss_imgView.image = image
        
    }
    
    // Add Color to image
    func addColor(color: UIColor) {
        let image = template!.image.colorizeWith(color)
        ss_imgView.image = image
    }
}

// MARK: Gesture Support
extension SJCollectionViewCell: UIGestureRecognizerDelegate {
    
    // Handle Pan Gesture
    @objc private func handlePan(recognizer: UIPanGestureRecognizer) {
        
        // Make sure that the bounding view exists
        // which it always will
        if let boundingRectView = boundingRectView {
            
            // Find the location
            var location = recognizer.locationInView(boundingRectView)
            var translatedpoint = recognizer.translationInView(boundingRectView)
            
            // Loop through the sub views array
            loop: for view in sj_subViews {
                
                // If one subview contains the point
                if CGRectContainsPoint(view.frame, location) {
                    switch recognizer.state {
                        case .Began:
                            if recognizer.state == .Began {
                                firstX = view.center.x
                                firstY = view.center.y
                            }
                        case .Changed:
                            view.center = CGPointMake(firstX + translatedpoint.x, firstY + translatedpoint.y)
                            // Break the loop after changing one view
                            // Done in order to prevent multiple views 
                            // from moving simultaneously
                            break loop
                        case .Ended:
                            lastSelectedView = view
                        default:
                            break
                    }
                }
            }
        }
    }
    
    // Handle Rotate and Pinch Gesture
    @objc private func handleGesture(recognizer: UIGestureRecognizer) {
        
        switch recognizer.state {
            
            case .Began:
                if activeRecognizers.count == 0 {
                    referenceTransform = lastSelectedView?.transform
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
                lastSelectedView?.transform = transform!
                
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

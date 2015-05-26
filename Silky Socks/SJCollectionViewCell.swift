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
        for view in sj_subViews {
            view.removeFromSuperview()
        }
        sj_subViews.removeAll(keepCapacity: true)
        boundingRectView?.removeFromSuperview()
    }
    
    // Apply Layout Attributes
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes!) {
        if let attr = layoutAttributes {
            self.frame = attr.frame
        }
    }
    
    // Add the label as a subview of boundingRectView
    // Is a view around the image because the image is smaller than the image view
    private var boundingRectView: UIView?
    
    // Aspect Fit
    private func addClipRect() {
        
        if let view = boundingRectView {
            if view.superview == nil {
                addSubview(view)
            }
            return
        }
        
        let aspectRatio = template!.image.size
        var boundingSize = ss_imgView.frame.size
        
        // Get the bounds for aspect fit
        boundingSize = UIImage.getBoundingSizeForAspectFit(aspectRatio, imageViewSize: boundingSize)
        
        // Create the bounding rect
        let x = (ss_imgView.frame.width - boundingSize.width)/2 + 5
        let y = (ss_imgView.frame.height - boundingSize.height)/2 + 20
        let frame = CGRectMake(x, y, boundingSize.width - 10, boundingSize.height - 5)
        boundingRectView = UIView(frame: frame)
        boundingRectView!.clipsToBounds = true
        addSubview(boundingRectView!)
    }
    
    // Create the text label
    func createLabel(text: String, font: UIFont) {
        
        // Create and add the bounding rect
        addClipRect()
        
        // Create the text label
        let sj_label = SJLabel(frame: .zeroRect, text: text, font: font, maskImage:template!.image)
        sj_label.frame = boundingRectView!.frame
        sj_label.frame.origin = CGPointZero

        sj_subViews.append(sj_label)
        
        // Add subview
        boundingRectView?.addSubview(sj_label)
    }
    
    // Create Image
    func createImage(image: UIImage) {
        
        // Create and add the bounding rect
        addClipRect()
        
        let sj_imgView = UIImageView(frame: bounds)
        sj_imgView.contentMode = .ScaleAspectFill
        sj_imgView.image = image
        sj_subViews.append(sj_imgView)
        
        // Add subview
        boundingRectView?.addSubview(sj_imgView)
    }
}

// MARK: Gesture Support
extension SJCollectionViewCell: UIGestureRecognizerDelegate {
    
    // Handle Pan Gesture
    @objc private func handlePan(recognizer: UIPanGestureRecognizer) {
        
        if let boundingRectView = boundingRectView {
            
            var location = recognizer.locationInView(boundingRectView)
            var translatedpoint = recognizer.translationInView(boundingRectView)
            
            loop: for view in sj_subViews {
                if CGRectContainsPoint(view.frame, location) {
                    switch recognizer.state {
                        case .Began:
                            if recognizer.state == .Began {
                                firstX = view.center.x
                                firstY = view.center.y
                            }
                        case .Changed:
                            translatedpoint = CGPointMake(firstX + translatedpoint.x, firstY + translatedpoint.y)
                            view.center = translatedpoint
                            view.setNeedsDisplay()
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

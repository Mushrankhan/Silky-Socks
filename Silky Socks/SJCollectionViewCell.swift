//
//  SJCollectionViewCell.swift
//  Silky Socks
//
//  Created by Saurabh Jain on 4/19/15.
//  Copyright (c) 2015 Saurabh Jain. All rights reserved.
//

import UIKit

// Cell Reuse identifier
let reuseIdentifier = "Cell"

// MARK: SJCollectionViewCellDelegate
protocol SJCollectionViewCellDelegate: class {
    func collectionViewCell(cell: UICollectionViewCell, didSelectView view: UIView?, atPoint point: CGPoint)
    func collectionViewCell(cell: UICollectionViewCell, didTapInfoButton button: UIButton)
}

// MARK: SJCollectionViewCell Class
class SJCollectionViewCell: UICollectionViewCell {

    // MARK: - Properties
    
    // IBOutlets
    @IBOutlet private weak var ss_imgView: UIImageView! { didSet { ss_imgView?.backgroundColor = UIColor.whiteColor() } }
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private(set) weak var infoButton: UIButton!
    @IBOutlet private weak var priceLabel: UILabel!
    
    // Delegate
    weak var delegate: SJCollectionViewCellDelegate?
    
    // Used so that we can transfer
    // the design from product to product
    static private var Color = UIColor.clearColor()
    static private var subViews = [UIView]()    // Stack
    
    // Model
    lazy private var device: String = {
        return UIDevice.currentDevice().modelName
    }()
    
    // Different Devices
    private struct Device {
        static let IPhone6s     = "iPhone 6s"
        static let IPhone6sPlus = "iPhone 6s Plus"
        static let IPhone6      = "iPhone 6"
        static let IPhone6Plus  = "iPhone 6 Plus"
        static let IPhone5      = "iPhone 5"
        static let IPhone5C     = "iPhone 5C"
        static let IPhone5S     = "iPhone 5S"
        static let IPod5        = "iPod Touch 5"
    }
    
    /* Gestures */
    private var panGestureRecognizer:    UIPanGestureRecognizer!
    private var pinchGestureRecognizer:  UIPinchGestureRecognizer!
    private var rotateGestureRecognizer: UIRotationGestureRecognizer!
    private var tapGestureRecognizer:    UITapGestureRecognizer!
    
    // Used in pan calculations
    private var firstX: CGFloat = 0
    private var firstY: CGFloat = 0
    
    // Used for keeping track of views in pan gesture
    private var selectedView: UIView?
    // Last selected view - Used in gestures
    private var lastSelectedView: UIView?

    // Set containing the gesture - rotate and pinch
    private var activeRecognizers = NSMutableSet()
    
    // initial transform
    private var referenceTransform: CGAffineTransform?
    
    // Template object
    var template:Template? {
        didSet {
            if let template = template {
                ss_imgView.image   = template.image           // Image
                nameLabel.text     = template.infoCaption     // Caption
                priceLabel.text    = "$\(template.prices[0])" // Price
                
                // Pass on Color
                if SJCollectionViewCell.Color != UIColor.clearColor() {
                    addColor(SJCollectionViewCell.Color)
                }

                // If can pass on subviews, then create bounding rect
                if SJCollectionViewCell.subViews.count > 0 {
                    if boundingRectView == nil {
                        addClipRect()
                    }
                    
                    delay(0.5) { [weak self] in
                        // Pass on image/label
                        for view in SJCollectionViewCell.subViews {
                            self?.lastSelectedView = view
                            self?.snapshotview?.addSubview(view)
                        }
                    }

                }
            }
        }
    }
    
    /*
        Heirarchy :-
            - Cell
                - BoundingView(Masking applied)
                    - SnapshotView
    */
    private var boundingRectView: UIView?
    private(set) var snapshotview: SJView?
    
    // Masking that is applied to the boundingRectView
    private var maskImageView: UIImageView?
    
    // Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
        opaque = true
        
        // Pan
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handlePan:")
        panGestureRecognizer.delegate = self
        addGestureRecognizer(panGestureRecognizer)
        
        // Pinch
        pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: "handleGesture:")
        pinchGestureRecognizer.delegate = self
        addGestureRecognizer(pinchGestureRecognizer)
        
        // Rotate
        rotateGestureRecognizer = UIRotationGestureRecognizer(target: self, action: "handleGesture:")
        rotateGestureRecognizer.delegate = self
        addGestureRecognizer(rotateGestureRecognizer)
        
        // Tap
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "handleTap:")
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    // MARK: - Layout
    
    // Apply Layout Attributes
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
        frame = layoutAttributes.frame
    }
    
    // Returns the nib associated with the cell
    class func nib() -> UINib {
        return UINib(nibName: "SJCollectionViewCell", bundle: nil)
    }
    
    // MARK: - IBAction
    
    @IBAction func infoButtonPressed(sender: UIButton) {
        delegate?.collectionViewCell(self, didTapInfoButton: sender)
    }

    // MARK: - Clean Up
    
    // Can be called by instances to clean up
    func performCleanUp() {
        // Clean up static variables
        addColor(UIColor.clearColor())
        for view in SJCollectionViewCell.subViews { view.removeFromSuperview() }
        SJCollectionViewCell.subViews.removeAll(keepCapacity: true)
        
        // Clean up normal variables
        cleanUp()
    }
    
    
    // Prepare for reuse
    override func prepareForReuse() {
        cleanUp()
        super.prepareForReuse()
    }
    
    // Used for cleaning up the cell
    // Not to clear up the color when cleaning up
    private func cleanUp() {
        
        if snapshotview?.superview     != nil { snapshotview!.removeFromSuperview()     }
        if maskImageView?.superview    != nil { maskImageView!.removeFromSuperview()    }
        if boundingRectView?.superview != nil { boundingRectView!.removeFromSuperview() }
        
        snapshotview = nil
        maskImageView = nil
        boundingRectView = nil
        
        // Tracking variables
        selectedView = nil
        lastSelectedView = nil
        activeRecognizers.removeAllObjects()
        referenceTransform = nil
        firstX = 0; firstY = 0
    }
}

// MARK: Customized Look
extension SJCollectionViewCell {
    
    // Add Bounding view
    private func addClipRect() {
        
        if let view = boundingRectView {
            view.removeFromSuperview()
            boundingRectView = nil
        }
        
        // force the auto layout to take place
        layoutIfNeeded()

        // Alloc the bounding View
        boundingRectView = UIView(frame: CGRectIntegral(ss_imgView.frame))
        maskImageView = UIImageView(frame: boundingRectView!.bounds)
        maskImageView!.contentMode = .ScaleAspectFit
        maskImageView!.image = template?.maskImage ?? template?.image
        boundingRectView!.maskView = maskImageView
        contentView.addSubview(boundingRectView!)

        var size  = UIImage.getBoundingSizeForAspectFit(template!.image.size, imageViewSize: ss_imgView.bounds.size)
        size.width = floor(size.width) + 20; size.height = floor(size.height) + 10
        
        var point = CGPoint(x: CGRectGetMidX(ss_imgView.frame) - size.width/2, y: -5)
        var frame = CGRect(origin: point, size: size)
        
        // Black Normal
        if template?.index == 1 {
            if device == Device.IPhone6 || device == Device.IPhone6s {
                size.height -= 110
            } else if device == Device.IPhone6Plus || device == Device.IPhone6sPlus {
                size.height -= 120
            } else if device == Device.IPhone5 || device == Device.IPhone5C || device == Device.IPhone5S || device == Device.IPod5 {
                size.height -= 60
            }
            frame.size = size
        } else if template?.index == 2 { // Knee high
            if device == Device.IPhone6 || device == Device.IPhone6s {
                size.height -= 40
            } else if device == Device.IPhone6Plus || device == Device.IPhone6sPlus {
                size.height -= 40
            } else if device == Device.IPhone5 || device == Device.IPhone5C || device == Device.IPhone5S || device == Device.IPod5 {
                size.height -= 20
            }
            frame.size = size
        } else if template?.index == 3 { // White tee
            if device == Device.IPhone6 || device == Device.IPhone6s {
                point.y += 30
            } else if device == Device.IPhone6Plus || device == Device.IPhone6sPlus {
                point.y += 50
            }
            frame.origin = point
        } else if template?.index == 5 { // Black tee
            size.height += 15
            if device == Device.IPhone6 || device == Device.IPhone6s {
                size.width -= 100
                point.x += 50
            } else if device == Device.IPhone6Plus || device == Device.IPhone6sPlus {
                size.width -= 120
                point.x += 50
            } else if device == Device.IPhone5 || device == Device.IPhone5C || device == Device.IPhone5S || device == Device.IPod5 {
                size.width -= 80
                point.x += 40
            }
            frame.size = size
            frame.origin = point
        }
        
        // Alloc snapshot view
        snapshotview = SJView(frame: CGRectIntegral(frame))
        snapshotview?.alpha = 0.95
        snapshotview?.clipsToBounds = true
        boundingRectView?.addSubview(snapshotview!)
    }
    
    // Create the text label
    func createLabel(text: String, font: UIFont, color: UIColor) {
        
        // Create and add the bounding rect
        if boundingRectView == nil {
            addClipRect()
        }
        
        // Create the text label
        let sj_label = SJLabel(frame: .zero, text: text, font: font)
        sj_label.frame.size.width = CGRectGetWidth(boundingRectView!.frame)
        sj_label.textColor = color
        sj_label.backgroundColor = UIColor.clearColor()
        sj_label.sizeToFit()
        sj_label.center = CGPoint(x: CGRectGetMidX(snapshotview!.bounds), y: CGRectGetMidY(snapshotview!.bounds))
        
        // Add the label to the array of sub views
        SJCollectionViewCell.subViews.append(sj_label)
        
        // Make sure that the last selected view
        // has a value
        lastSelectedView = sj_label
        
        // Add subview
        snapshotview?.addSubview(sj_label)
        
    }
    
    // Create Image
    func createImage(image: UIImage, forGrid: Bool) {
        
        // If grid then add image on the image
        if forGrid {
//            let finishedImage = template!.image.drawImage(image, forTiling: true)
//            ss_imgView.image = finishedImage
//            
//            // Create and add the bounding rect
//            if boundingRectView == nil {
//                addClipRect()
//            }
//            
//            // Tiled image
//            let image = template!.image.drawTiledImage()
//            let sj_imgView_snap = UIImageView(frame: snapshotview!.bounds)
//            sj_imgView_snap.contentMode = .ScaleAspectFill
//            sj_imgView_snap.image = image
//            
//            // Add it to the array of subviews
//            //sj_subviews_snap.append(sj_imgView_snap)
//            SJCollectionViewCell.subViews.append(sj_imgView_snap)
//            
//            // Make sure that the last selected view
//            // has a value
//            //lastSelectedSnapshotView = sj_imgView_snap
//            lastSelectedView = sj_imgView_snap
//            
//            // Add subview
//            snapshotview?.addSubview(sj_imgView_snap)

            return
        }
        
        func normalImage(image: UIImage) {
            
            // Create and add the bounding rect
            if boundingRectView == nil {
                addClipRect()
            }
            
            let width = 150

            // Create the image
            let sj_imgView = UIImageView()
            sj_imgView.frame.size = CGSize(width: width, height: width)
            sj_imgView.center = CGPoint(x: CGRectGetMidX(snapshotview!.bounds), y: CGRectGetMidY(snapshotview!.bounds))
            sj_imgView.contentMode = .ScaleAspectFill
            sj_imgView.image = image
            
            SJCollectionViewCell.subViews.append(sj_imgView)
            lastSelectedView = sj_imgView
            snapshotview?.addSubview(sj_imgView)
            
        }
        
        // add image on bounding view
        normalImage(image)
    }
    
    
    // Add Color to image
    func addColor(color: UIColor) {
        
        // Static Variable
        SJCollectionViewCell.Color = color
        
        // Alternative
        if boundingRectView == nil {
            addClipRect()
        }
        snapshotview?.backgroundColor = color
    }
}

// MARK: Undo Support
extension SJCollectionViewCell {
    
    // Undo the grid
    func undoGrid() {
//        ss_imgView.image = template?.image
//        
//        // If nothing exists, then
//        if SJCollectionViewCell.subViews.count == 0 {
//            cleanUp()
//        }
    }
    
    // Undo - Label/Image
    func undo() {
        if SJCollectionViewCell.subViews.count > 0 {
            SJCollectionViewCell.subViews[SJCollectionViewCell.subViews.count - 1].removeFromSuperview()
            SJCollectionViewCell.subViews.removeLast()
            
            // If nothing exists, then
            if SJCollectionViewCell.subViews.count == 0 && SJCollectionViewCell.Color == UIColor.clearColor() {
                cleanUp()
            }
        }
    }
    
    // Delete a view
    func undo(view: UIView) {
        for (index,subview) in SJCollectionViewCell.subViews.enumerate() {
            if subview == view {
                subview.removeFromSuperview()
                SJCollectionViewCell.subViews.removeAtIndex(index)
            }
        }
        
        // If nothing exists, then
        if SJCollectionViewCell.subViews.count == 0 && SJCollectionViewCell.Color == UIColor.clearColor() {
            cleanUp()
        }
    }
}

// MARK: Gesture Support
extension SJCollectionViewCell: UIGestureRecognizerDelegate {
    
    // Handle Tap
    func handleTap(recognizer: UITapGestureRecognizer) {
        let location = recognizer.locationInView(self)
        var selectedView: UIView?
        for (_, view) in SJCollectionViewCell.subViews.enumerate().reverse() {
            // Converting the sub view into the coordinate space of the cell from the bounding view
            let rect = convertRect(view.frame, fromView: snapshotview)
            if CGRectContainsPoint(rect, location) {
                selectedView = view
                lastSelectedView = view
            }
        }
        delegate?.collectionViewCell(self, didSelectView: selectedView, atPoint: location)
    }
    
    // Handle Pan Gesture
    @objc private func handlePan(recognizer: UIPanGestureRecognizer) {

        // Make sure that the bounding view exists
        if boundingRectView != nil {
            
            // Find the location
            let location = recognizer.locationInView(self)
            let translatedpoint = recognizer.translationInView(self)
            
            switch recognizer.state {
                
                case .Began:
                    if recognizer.state == .Began {
                        
                        // Loop through the sub views array
                        loop: for (_, view) in SJCollectionViewCell.subViews.enumerate().reverse() {
                            
                            // If one subview contains the point
                            let rect = convertRect(view.frame, fromView: snapshotview)
                            if CGRectContainsPoint(rect, location) {
                                selectedView = view
                                break loop
                            }
                        }
                        
                        if selectedView != nil {
                            firstX = selectedView!.center.x
                            firstY = selectedView!.center.y
                        }
                    }
                    
                case .Changed:
                    if let view = selectedView {
                        view.center = CGPointMake(firstX + translatedpoint.x, firstY + translatedpoint.y)
                    }
                
                case .Ended:
                        lastSelectedView = selectedView
                        selectedView = nil
                
                default:
                    break
            }
        }
    }
    
    // Handle Rotate and Pinch Gesture
    @objc private func handleGesture(recognizer: UIGestureRecognizer) {
        
        // Make sure that the bounding view exists
        if boundingRectView != nil {
            
            switch recognizer.state {
                case .Began:
                    if activeRecognizers.count == 0 {
                        referenceTransform = lastSelectedView?.transform
                    }
                    activeRecognizers.addObject(recognizer)
                    
                case .Ended:
                    referenceTransform = applyRecognizer(recognizer, toTransform: referenceTransform)
                    activeRecognizers.removeObject(recognizer)
                
                case .Changed:
                    if referenceTransform != nil {
                        var transform = referenceTransform!
                        for gesture in activeRecognizers {
                            transform = applyRecognizer(gesture as! UIGestureRecognizer, toTransform: transform)!
                        }
                        lastSelectedView?.transform = transform
                    }

                default:
                    break
            }
        }
    }
    
    // Helper Function
    private func applyRecognizer(recognizer: UIGestureRecognizer, toTransform transform:CGAffineTransform?) -> CGAffineTransform? {
        
        guard let transform = transform else {
            return nil
        }
        
        if recognizer is UIRotationGestureRecognizer {
            return CGAffineTransformRotate(transform, (recognizer as! UIRotationGestureRecognizer).rotation)
        } else if recognizer is UIPinchGestureRecognizer {
            let scale = (recognizer as! UIPinchGestureRecognizer).scale
            return CGAffineTransformScale(transform, scale, scale)
        }
        
        return nil
        
    }
    
    // Important - Handle Pinch and rotate simultaneously
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}


class SJView: UIView {
    override func actionForLayer(layer: CALayer, forKey event: String) -> CAAction? {
        if event == "sublayers" {
            return CATransition()
        }
        return nil
    }
}

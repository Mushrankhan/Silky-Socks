//
//  SJCollectionViewCell.swift
//  Silky Socks
//
//  Created by Saurabh Jain on 4/19/15.
//  Copyright (c) 2015 Saurabh Jain. All rights reserved.
//

import UIKit

// Cell Reuse identifier
public let reuseIdentifier = "Cell"

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
    
    // Delegate
    weak var delegate: SJCollectionViewCellDelegate?
    
    // Array containing all the views added to the template & snapshot view
    //private var sj_subViews      = [UIView]()
    private var sj_subviews_snap = [UIView]()
    
    // The number of the elements in the array
    var sj_subViews_count: Int {
        return Constants.sj_subViews.count
    }
    
    // Last selected view - Used in gestures
    private var lastSelectedView: UIView?
    private var lastSelectedSnapshotView: UIView?
    
    /* Gestures */
    private var panGestureRecognizer: UIPanGestureRecognizer!
    private var pinchGestureRecognizer: UIPinchGestureRecognizer!
    private var rotateGestureRecognizer: UIRotationGestureRecognizer!
    private var tapGestureRecognizer: UITapGestureRecognizer!
    
    // Used in pan calculations
    private var firstX: CGFloat = 0
    private var firstY: CGFloat = 0
    private var snapFirstX: CGFloat = 0
    private var snapFirstY: CGFloat = 0
    
    // Used for keeping track of views in pan gesture
    private var selectedView: UIView?
    private var selectedSnapshotView: UIView?

    // Set containing the gesture - rotate and pinch
    private var activeRecognizers = NSMutableSet()
    
    // initial transform
    private var referenceTransform: CGAffineTransform?
    
    // Template object
    var template:Template? {
        didSet {
            if let template = template {
                ss_imgView?.image = template.image
                nameLabel.text = template.infoCaption
                
                // Set color
                if Constants.sj_color != UIColor.clearColor() {
                    addColor(Constants.sj_color)
                }
                
                if sj_subViews_count > 0 {
                    if boundingRectView == nil {
                        addClipRect()
                    }
                }
                
                for (index, view) in Constants.sj_subViews.reverse().enumerate() {
                    if let image = view as? UIImageView {

                        lastSelectedView = image
                        boundingRectView?.addSubview(image)
                        
                        let point = snapshotview?.convertPoint(image.center, fromView: boundingRectView)

                        let sj_imgView_snap = UIImageView()
                        sj_imgView_snap.bounds.size = image.bounds.size
                        sj_imgView_snap.center = point!  //CGPoint(x: CGRectGetMidX(snapshotview!.bounds), y: CGRectGetMidY(snapshotview!.bounds) + snapshotview!.frame.origin.y)
                        sj_imgView_snap.contentMode = .ScaleAspectFill
                        sj_imgView_snap.image = image.image
                        sj_imgView_snap.transform = image.transform
                        
                        // Add it to the array of subviews
                        sj_subviews_snap.insert(sj_imgView_snap, atIndex: index)
                        
                        lastSelectedSnapshotView = sj_imgView_snap
                        
                        // Add subview
                        snapshotview?.addSubview(sj_imgView_snap)

                        
                    }
                    if let label = view as? UILabel {

                        lastSelectedView = label
                        boundingRectView?.addSubview(label)
                        
                        let point = snapshotview?.convertPoint(label.center, fromView: boundingRectView)
                        let sj_label_snap = SJLabel(frame: .zeroRect, text: label.text!, font: label.font)
                        sj_label_snap.bounds.size = label.bounds.size
                        sj_label_snap.textColor = label.textColor
                        sj_label_snap.backgroundColor = UIColor.clearColor()
                        sj_label_snap.center = point! // CGPoint(x: CGRectGetMidX(snapshotview!.bounds), y: CGRectGetMidY(snapshotview!.bounds) + snapshotview!.frame.origin.y + 8)
                        sj_label_snap.transform = label.transform
                        
                        // Add the label to the array of sub views
                        sj_subviews_snap.insert(sj_label_snap, atIndex: index)
                        
                        lastSelectedSnapshotView = sj_label_snap
                        
                        // Add subview
                        snapshotview?.addSubview(sj_label_snap)

                        
                    }
                }

            }
        }
    }
    
    // static variable
    private struct Constants {
        static var sj_color = UIColor.clearColor()
        static var sj_subViews = [UIView]()
    }
        
    // Add the label as a subview of boundingRectView
    // Is a view around the image because the image is smaller than the image view
    private(set) var boundingRectView: UIView?
    private(set) var snapshotview: UIView?
    
    // Masking that is applied to the boundingRectView
    private var maskImageView: UIImageView?
    
    // Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        autoresizingMask = [UIViewAutoresizing.FlexibleHeight, .FlexibleWidth]
        translatesAutoresizingMaskIntoConstraints = false
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
        
        // Tap
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "handleTap:")
        tapGestureRecognizer.delaysTouchesBegan = true
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    
    // MARK: - Clean Up
    
    // Can be called by instances to clean up
    func performCleanUp() {
        addColor(UIColor.clearColor())
        for view in Constants.sj_subViews { view.removeFromSuperview() }
        Constants.sj_subViews.removeAll(keepCapacity: true)
        cleanUp()
    }
    
    
    // Prepare for reuse
    override func prepareForReuse() {
        cleanUp()
        super.prepareForReuse()
    }
    
    deinit {
        cleanUp()
        nameLabel = nil
        ss_imgView = nil
        template = nil
    }
    
    // Used for cleaning up the cell
    // Not to clear up the color when cleaning up
    private func cleanUp() {
        // Clear the subviews added to the cell
        for view in sj_subviews_snap { view.removeFromSuperview() }
        sj_subviews_snap.removeAll(keepCapacity: true)
        
        // Very essential to release mask view before boundingView
        // Spent hours trying to debug it with Zombie Instruments
        if maskImageView?.superview    != nil { maskImageView!.removeFromSuperview()    }
        if boundingRectView?.superview != nil { boundingRectView!.removeFromSuperview() }
        if snapshotview?.superview     != nil { snapshotview!.removeFromSuperview()     }
        
        maskImageView = nil
        boundingRectView = nil
        snapshotview = nil
        
        // Tracking variables
        lastSelectedView = nil
        lastSelectedSnapshotView = nil
        activeRecognizers.removeAllObjects()
        referenceTransform = nil
        firstX = 0; firstY = 0
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
    
    // Returns whether the collection view should pan or not
    func shouldPan() -> Bool {
        if sj_subViews_count > 0 || template!.image != ss_imgView.image {
            return false
        }
        return true
    }
    
}

// MARK: IBAction
extension SJCollectionViewCell {
    @IBAction func infoButtonPressed(sender: UIButton) {
        delegate?.collectionViewCell(self, didTapInfoButton: sender)
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
        
        var size = UIImage.getBoundingSizeForAspectFit(template!.image.size, imageViewSize: ss_imgView.bounds.size)
        var point = CGPoint(x: CGRectGetMidX(ss_imgView.frame) - size.width/2, y: ss_imgView.frame.origin.y)
        var frame = CGRect(origin: point, size: size)
        
        // Alloc the bounding View
        boundingRectView = UIView(frame: ss_imgView.frame)
        boundingRectView?.alpha = 0.9
        
        size.width = floor(size.width) + 20; size.height = floor(size.height) + 10
        point.y -= 5; point.x -= 10
        frame = CGRect(origin: point, size: size)

        // Black Normal
        if template?.index == 1 {
            let device = UIDevice.currentDevice().modelName
            if  device == "iPhone 6" {
                size.height -= 110
            } else if device == "iPhone 6 Plus" {
                size.height -= 120
            } else if device == "iPhone 5" || device == "iPhone 5C" || device == "iPhone 5S" {
                size.height -= 60
            }
            frame.size = size
        } else if template?.index == 2 { // Knee high
            let device = UIDevice.currentDevice().modelName
            if  device == "iPhone 6" {
                size.height -= 40
            } else if device == "iPhone 6 Plus" {
                size.height -= 40
            } else if device == "iPhone 5" || device == "iPhone 5C" || device == "iPhone 5S" {
                size.height -= 20
            }
            frame.size = size
        } else if template?.index == 5 { // Black tee
            size.height += 15

            let device = UIDevice.currentDevice().modelName
            if  device == "iPhone 6" {
                size.width -= 100
                point.x += 50
            } else if device == "iPhone 6 Plus" {
                size.width -= 100
                point.x += 50
            } else if device == "iPhone 5" || device == "iPhone 5C" || device == "iPhone 5S" {
                size.width -= 80
                point.x += 40
            }
            frame.size = size
            frame.origin = point
        }
        
        // Alloc snapshot view
        snapshotview = UIView(frame: frame)
        snapshotview?.hidden = true
        snapshotview?.clipsToBounds = true
        
        // Masking
        maskImageView = UIImageView(frame: boundingRectView!.bounds)
        maskImageView!.contentMode = .ScaleAspectFit
        maskImageView!.image = template?.maskImage ?? template?.image
        
        // Mask it
        boundingRectView!.maskView = maskImageView
        
        // Add Subview
        addSubview(boundingRectView!)
        addSubview(snapshotview!)
        //sendSubviewToBack(snapshotview!)
    }
    
    // Create the text label
    func createLabel(text: String, font: UIFont, color: UIColor) {
        
        // Create and add the bounding rect
        if boundingRectView == nil {
            addClipRect()
        }
        
        // Create the text label
        let sj_label = SJLabel(frame: .zeroRect, text: text, font: font)
        sj_label.frame.size.width = CGRectGetWidth(boundingRectView!.frame)
        sj_label.textColor = color
        sj_label.backgroundColor = UIColor.clearColor()
        sj_label.sizeToFit()
        sj_label.center = CGPoint(x: boundingRectView!.center.x, y: boundingRectView!.center.y)
        
        // Add the label to the array of sub views
        Constants.sj_subViews.insert(sj_label, atIndex: 0)
        
        // Make sure that the last selected view
        // has a value
        lastSelectedView = sj_label
        
        // Add subview
        boundingRectView?.addSubview(sj_label)
        
        
        let point = snapshotview?.convertPoint(sj_label.center, fromView: boundingRectView)
        let sj_label_snap = SJLabel(frame: .zeroRect, text: text, font: font)
        sj_label_snap.frame.size.width = CGRectGetWidth(boundingRectView!.frame)
        sj_label_snap.textColor = color
        sj_label_snap.backgroundColor = UIColor.clearColor()
        sj_label_snap.sizeToFit()
        sj_label_snap.center = point! // CGPoint(x: CGRectGetMidX(snapshotview!.bounds), y: CGRectGetMidY(snapshotview!.bounds) + snapshotview!.frame.origin.y + 8)
        
        // Add the label to the array of sub views
        sj_subviews_snap.insert(sj_label_snap, atIndex: 0)
        
        lastSelectedSnapshotView = sj_label_snap
        
        // Add subview
        snapshotview?.addSubview(sj_label_snap)
        
    }
    
    
    // Create Image
    func createImage(image: UIImage, forGrid: Bool) {
        
        // If grid then add image on the image
        if forGrid {
            let finishedImage = template!.image.drawImage(image, forTiling: true)
            ss_imgView.image = finishedImage
            
            // Create and add the bounding rect
            if boundingRectView == nil {
                addClipRect()
            }
            
            // Tiled image
            let image = template!.image.drawTiledImage()
            let sj_imgView_snap = UIImageView(frame: snapshotview!.bounds)
            sj_imgView_snap.contentMode = .ScaleAspectFill
            sj_imgView_snap.image = image
            
            // Add it to the array of subviews
            sj_subviews_snap.insert(sj_imgView_snap, atIndex: 0)
            
            // Make sure that the last selected view
            // has a value
            lastSelectedSnapshotView = sj_imgView_snap
            
            // Add subview
            snapshotview?.addSubview(sj_imgView_snap)

            return
        }
        
        func normalImage(image: UIImage) {
            
            // Create and add the bounding rect
            if boundingRectView == nil {
                addClipRect()
            }
            
            let size = UIImage.getBoundingSizeForAspectFit(template!.image.size, imageViewSize: ss_imgView.frame.size)
            var width = min(size.width, size.height)
            
            if template!.type == .Shirt {
                width -= 150
            }
            
            // Create the image
            let sj_imgView = UIImageView(frame: .zeroRect)
            sj_imgView.frame.size = CGSize(width: width, height: width)
            sj_imgView.center = CGPoint(x: boundingRectView!.center.x, y: boundingRectView!.center.y)
            sj_imgView.contentMode = .ScaleAspectFill
            sj_imgView.image = image
            
            // Add it to the array of subviews
            Constants.sj_subViews.insert(sj_imgView, atIndex: 0)
            
            // Make sure that the last selected view
            // has a value
            lastSelectedView = sj_imgView
            
            // Add subview
            boundingRectView?.addSubview(sj_imgView)
            
            
            let point = snapshotview?.convertPoint(sj_imgView.center, fromView: boundingRectView)
            // Create the image
            let sj_imgView_snap = UIImageView(frame: .zeroRect)
            sj_imgView_snap.frame.size = CGSize(width: width, height: width)
            sj_imgView_snap.center = point! //CGPoint(x: CGRectGetMidX(snapshotview!.bounds), y: CGRectGetMidY(snapshotview!.bounds) + snapshotview!.frame.origin.y)
            sj_imgView_snap.contentMode = .ScaleAspectFill
            sj_imgView_snap.image = image
            
            // Add it to the array of subviews
            sj_subviews_snap.insert(sj_imgView_snap, atIndex: 0)
            
            // Make sure that the last selected view
            // has a value
            lastSelectedSnapshotView = sj_imgView_snap
            
            // Add subview
            snapshotview?.addSubview(sj_imgView_snap)
            
        }
        
        // add image on bounding view
        normalImage(image)
    }
    
    
    // Add Color to image
    func addColor(color: UIColor) {
        
        // Static Variable
        // Lot Better than saving in NSUserDefaults
        Constants.sj_color = color
        
        if color == UIColor.clearColor() {
            ss_imgView.image = template?.image
            snapshotview?.backgroundColor = color
            return
        }
        
        // Add the color on the image itself rather than
        // placing the color on top the image
        // coz we need some kind of blending
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
            let image = self.template!.image.colorizeWith(color)
            dispatch_async(dispatch_get_main_queue()) {
                self.ss_imgView.image = image
            }
        }
        
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
        ss_imgView.image = template?.image
        
        // If nothing exists, then
        if Constants.sj_subViews.count == 0 {
            cleanUp()
        }
    }
    
    // Undo - Label/Image
    func undo() {
        if Constants.sj_subViews.count > 0 {
            Constants.sj_subViews[0].removeFromSuperview()
            Constants.sj_subViews.removeAtIndex(0)
            sj_subviews_snap[0].removeFromSuperview()
            sj_subviews_snap.removeAtIndex(0)
            
            // If nothing exists, then
            if Constants.sj_subViews.count == 0 {
                cleanUp()
            }
        }
    }
    
    // Delete a view
    func undo(view: UIView) {
        for (index,subview) in Constants.sj_subViews.enumerate() {
            if subview == view {
                subview.removeFromSuperview()
                Constants.sj_subViews.removeAtIndex(index)
                sj_subviews_snap[index].removeFromSuperview()
                sj_subviews_snap.removeAtIndex(index)
            }
        }
        
        // If nothing exists, then
        if Constants.sj_subViews.count == 0 {
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
        for (index, view) in Constants.sj_subViews.enumerate() {
            // Converting the sub view into the coordinate space of the cell from the bounding view
            let rect = convertRect(view.frame, fromView: boundingRectView)
            if CGRectContainsPoint(rect, location) {
                selectedView = view
                lastSelectedView = view
                selectedSnapshotView = sj_subviews_snap[index]
                lastSelectedSnapshotView = sj_subviews_snap[index]
            }
        }
        delegate?.collectionViewCell(self, didSelectView: selectedView, atPoint: location)
    }
    
    // Handle Pan Gesture
    @objc private func handlePan(recognizer: UIPanGestureRecognizer) {
        
        // Make sure that the bounding view exists
        if let boundingRectView = boundingRectView {
            
            // Find the location
            let location = recognizer.locationInView(self)
            let translatedpoint = recognizer.translationInView(self)
            
            switch recognizer.state {
                
                case .Began:
                    if recognizer.state == .Began {
                        
                        // Loop through the sub views array
                        loop: for (index, view) in Constants.sj_subViews.enumerate() {
                            
                            // If one subview contains the point
                            let rect = convertRect(view.frame, fromView: boundingRectView)
                            if CGRectContainsPoint(rect, location) {
                                selectedView = view
                                selectedSnapshotView = sj_subviews_snap[index]
                                break loop
                            }
                        }
                        
                        if selectedView != nil && selectedSnapshotView != nil {
                            firstX = selectedView!.center.x
                            firstY = selectedView!.center.y
                            snapFirstX = selectedSnapshotView!.center.x
                            snapFirstY = selectedSnapshotView!.center.y
                        }
                    }
                    
                case .Changed:
                    if let view = selectedView {
                        view.center = CGPointMake(firstX + translatedpoint.x, firstY + translatedpoint.y)
                        selectedSnapshotView?.center = CGPointMake(snapFirstX + translatedpoint.x, snapFirstY + translatedpoint.y)
                    }
                
                case .Ended:
                        lastSelectedView = selectedView
                        lastSelectedSnapshotView = selectedSnapshotView
                
                default:
                    break
            }
        }
    }
    
    // Handle Rotate and Pinch Gesture
    @objc private func handleGesture(recognizer: UIGestureRecognizer) {
        
        // Make sure that the bounding view exists
        if let _ = boundingRectView {
            
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
                    lastSelectedSnapshotView?.transform = transform!
                    
                default:
                    break
            }
        }
    }
    
    // Helper Function
    private func applyRecognizer(recognizer: UIGestureRecognizer, toTransform transform:CGAffineTransform) -> CGAffineTransform {
        
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
}

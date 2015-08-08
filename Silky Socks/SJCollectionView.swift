//
//  SJCollectionView.swift
//  Silky Socks
//
//  Created by Saurabh Jain on 5/15/15.
//  Copyright (c) 2015 Saurabh Jain. All rights reserved.
//

import UIKit

class SJCollectionView: UICollectionView {
    
    // Custom delegate
    weak var myDelegate: SJCollectionViewDelegate?
    
    // The bottom view
    private(set) var sj_bottomView: SJBottomView?
    
    // Return the currently visible Cell
    
    var visibleCell: SJCollectionViewCell? {
        get {
            let cells = visibleCells() as! [SJCollectionViewCell]
            if cells.count == 1 {
                return cells.first!
            }
            return nil
        }
    }
    
    // the width of the screen bounds
    private var width: CGFloat {
        return CGRectGetWidth(UIScreen.mainScreen().bounds)
    }
    
    // Initialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialSetUp()
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        initialSetUp()
    }
    
    private func initialSetUp() {
        // Basic
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.whiteColor()
        keyboardDismissMode = .Interactive
        bounces = true
        indicatorStyle = .Black
        pagingEnabled = true
        panGestureRecognizer.delegate = self

        // Register the Cell
        registerNib(SJCollectionViewCell.nib(), forCellWithReuseIdentifier: reuseIdentifier)
        
        // Register Supplementary View
        registerNib(RestartViewCollectionReusableView.nib(), forSupplementaryViewOfKind: restartElementkind, withReuseIdentifier: restartIdentifier)
        registerNib(ShareViewCollectionReusableView.nib(), forSupplementaryViewOfKind: shareElementKind, withReuseIdentifier: shareIdentifier)
        registerNib(CartViewCollectionReusableView.nib(), forSupplementaryViewOfKind: addToCartElementKind, withReuseIdentifier: addToCartIdentifier)
        registerNib(SJBottomView.nib(), forSupplementaryViewOfKind: utilitiesElementkind, withReuseIdentifier: utilitiesReuseIdentifier)
        
        // Register the decoration view
        // Decoration views are owned by the layout object
        let layout = collectionViewLayout as! SJLayout
        layout.registerNib(UINib(nibName: "SJCollectionDecorationSilkySocksLogoReusableView", bundle: nil), forDecorationViewOfKind: logoElementKind)
    }
    
    override func dequeueReusableCellWithReuseIdentifier(identifier: String, forIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        // Essential to conform to cell delegate
        if let object = super.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as? SJCollectionViewCell {
            object.delegate = self
            return object
        }
        return super.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath)
    }
}

// MARK: Dequeuing the various supplementary views
extension SJCollectionView {
    
    // Dequeue the bottom utilities view
    func dequeueReusableBottomUtilitiesView(indexPath indexPath: NSIndexPath) -> SJBottomView {
        let view = super.dequeueReusableSupplementaryViewOfKind(utilitiesElementkind, withReuseIdentifier: utilitiesReuseIdentifier, forIndexPath: indexPath) as! SJBottomView
        view.delegate = self // important
        sj_bottomView = view
        return view
    }

    // Dequeue the restart buttom
    func dequeueReusableRestartView(indexPath indexPath: NSIndexPath) -> RestartViewCollectionReusableView {
        let view = super.dequeueReusableSupplementaryViewOfKind(restartElementkind, withReuseIdentifier: restartIdentifier, forIndexPath: indexPath) as! RestartViewCollectionReusableView
        view.delegate = self // important
        return view
    }
    
    // Dequeue the share button
    func dequeueReusableShareView(indexPath indexPath: NSIndexPath) -> ShareViewCollectionReusableView {
        let view = super.dequeueReusableSupplementaryViewOfKind(shareElementKind, withReuseIdentifier: shareIdentifier, forIndexPath: indexPath) as! ShareViewCollectionReusableView
        view.delegate = self // important
        return view
    }
    
    // Dequeue the add to cart button
    func dequeueReusableAddToCartView(indexPath indexPath: NSIndexPath) -> CartViewCollectionReusableView {
        let view = super.dequeueReusableSupplementaryViewOfKind(addToCartElementKind, withReuseIdentifier: addToCartIdentifier, forIndexPath: indexPath) as! CartViewCollectionReusableView
        view.delegate = self // important
        return view
    }
}

// MARK: Restart
extension SJCollectionView: RestartViewCollectionReusableViewDelegate {
    func restartReusableView(view: RestartViewCollectionReusableView, didPressRestartButton sender: UIButton) {
        myDelegate?.collectionView(self, didPressRestartButton: sender)
    }
}

// MARK: Share / Add To Cart
extension SJCollectionView: ShareViewCollectionReusableViewDelegate, CartViewCollectionReusableViewDelegate {
    func shareReusableView(view: ShareViewCollectionReusableView, didPressShareButton sender: UIButton) {
        guard let cell = visibleCell else {
            return
        }
        
        clickSnapShot(cell) { image in
            myDelegate?.collectionView(self, didPressShareButton: sender, withSnapShotImage: image)
        }

    }

    func cartReusableView(view: CartViewCollectionReusableView, didPressAddToCartButton sender: UIButton) {
        guard let cell = visibleCell else {
            return
        }
        
        // Snapshot view of the cell containing all the customizations
        if cell.snapshotview != nil {
            
            let size = cell.snapshotview!.bounds.size
            let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
            
            // Used for generating the image which is sent for printing
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
                
                UIGraphicsBeginImageContextWithOptions(size, false, 0)
                let context = UIGraphicsGetCurrentContext()
                if cell.template?.index == 3 || cell.template?.index == 4 { // White Tee || Tank
                    CGContextTranslateCTM(context, 0, rect.size.height)
                    CGContextScaleCTM(context, 1, -1)
                    CGContextClipToMask(UIGraphicsGetCurrentContext(), rect, (cell.template?.index == 3 ? UIImage(named: "tee")?.CGImage : UIImage(named: "tanktee")?.CGImage))
                    CGContextScaleCTM(context, 1, -1)
                    CGContextTranslateCTM(context, 0, -rect.size.height)
                }
                cell.snapshotview?.drawViewHierarchyInRect(rect, afterScreenUpdates: false)
                let generatedImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                
                dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                    
                    // Used for generating the image which is shown in the app
                    self.clickSnapShot(cell) { (image) in
                        self.myDelegate?.collectionView(self, didPressAddToCartButton: sender, withCartImage: image, generatedImage: generatedImage, andTemplate: cell.template!)
                    }
                }
                
            }
            
        }

    }
    
    private func clickSnapShot(cell: SJCollectionViewCell, block: (image: UIImage) -> Void) {
        // due to the presence of the info button
        let y = cell.infoButton.bounds.size.height
        var size = cell.frame.size; size.height -= y
        let rect = CGRect(origin: CGPoint(x: 0, y: y), size: size)
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
            guard let image = cell.clickSnapShot(rect, withLogo: UIImage.SilkySocksLogo()) else {
                return
            }
            dispatch_async(dispatch_get_main_queue()) {
                block(image: image)
            }
        }
    }
}

// MARK: Bottom Utilities Delegate
/*  The delegate messages from the bottom view is
    delegated to the SJCollectionViewController by
    a custom UICollectionViewDelegate   */
extension SJCollectionView: SJBottomViewDelegate {
    
    // Navigate Right
    func sj_bottomView(view: SJBottomView, didPressRightButton button: UIButton) {
        let xOffset = min(contentSize.width - width, CGFloat(Int(contentOffset.x / width)) * width + width)
        setContentOffset(CGPoint(x: xOffset, y: contentOffset.y), animated: true)
    }
    
    // Navigate Left
    func sj_bottomView(view: SJBottomView, didPressLeftButton button: UIButton) {
        let xOffset = max(0, CGFloat(Int(contentOffset.x / width)) * width - width)
        setContentOffset(CGPoint(x: xOffset, y: contentOffset.y), animated: true)
    }
    
    // Text button clicked
    func sj_bottomView(view: SJBottomView, didPressTextButton button:UIButton) {        
        myDelegate?.collectionView(self, bottomView: view, didPressTextButton: button)
    }
    
    // Camera Button
    func sj_bottomView(view: SJBottomView, didPressCameraButton button:UIButton) {
        myDelegate?.collectionView(self, bottomView: view, didPressCameraButton: button)
    }
    
    // Color Wheel
    func sj_bottomView(view: SJBottomView, didPressColorWheelButton button:UIButton) {
        myDelegate?.collectionView(self, bottomView: view, didPressColorWheelButton: button)
    }
    
    // Grid Button
    func sj_bottomView(view: SJBottomView, didPressGridButton button:UIButton) {
        myDelegate?.collectionView(self, bottomView: view, didPressGridButton: button)
    }
    
    // Smiley button
    func sj_bottomView(view: SJBottomView, didPressQuestionButton button:UIButton) {
        myDelegate?.collectionView(self, bottomView: view, didPressQuestionButton: button)
    }
}

// MARK: Messages from the VC
// Pass on to the cell to create/remove the appropriate views
extension SJCollectionView {
    
    // Pass the message to the appropriate cell
    func sj_createTextLabel(text: String, afont: UIFont, acolor: UIColor) {
        if let cell = visibleCell {
            cell.createLabel(text, font: afont, color: acolor)
        }
    }
    
    // Pass the message to the appropriate cell
    func sj_createImage(image: UIImage, forGrid: Bool) {
        if let cell = visibleCell {
            cell.createImage(image, forGrid: forGrid)
        }
    }
    
    // Pass the message to the appropriate cell
    // Passing on UIColor.clearColor() will get rid of the color
    func sj_addColor(color: UIColor) {
        if let cell = visibleCell {
            cell.addColor(color)
        }
    }
    
    // Undo Grid
    func sj_undoGrid() {
        if let cell = visibleCell {
            cell.undoGrid()
        }
    }
    
    // Undo Label/Image
    func sj_undo() {
        if let cell = visibleCell {
            cell.undo()
        }
    }
    
    func sj_undo(view: UIView) {
        if let cell = visibleCell {
            cell.undo(view)
        }
    }
}

// MARK: SJCollectionViewCellDelegate
extension SJCollectionView : SJCollectionViewCellDelegate {
    
    func collectionViewCell(cell: UICollectionViewCell, didSelectView view: UIView?, atPoint point: CGPoint) {
        guard let view = view else {
            myDelegate?.collectionView(self, touchesBegan: point)
            return
        }
        
        myDelegate?.collectionView(self, didTapSubview: view)
    }
    
    func collectionViewCell(cell: UICollectionViewCell, didTapInfoButton button: UIButton) {
        myDelegate?.collectionView(self, didTapInfoButton: button, withTemplateObject: (cell as! SJCollectionViewCell).template!)
    }
}


// MARK: Gesture Handling
extension SJCollectionView: UIGestureRecognizerDelegate {
    
    // Disable pan gesture
    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is UIPanGestureRecognizer {
            return false
        }
        return true
    }
    
    // Essential
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

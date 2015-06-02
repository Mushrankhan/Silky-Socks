//
//  SJCollectionView.swift
//  Silky Socks
//
//  Created by Saurabh Jain on 5/15/15.
//  Copyright (c) 2015 Full Stak. All rights reserved.
//

import UIKit

class SJCollectionView: UICollectionView {
    
    // Custom delegate
    var myDelegate: SJCollectionViewDelegate?
    
    // the width of the screen bounds
    private var width: CGFloat {
        get {
           return CGRectGetWidth(UIScreen.mainScreen().bounds)
        }
    }
    
    // The bottom view
    private(set) var sj_bottomView: SJBottomView?
    
    // The Count
    var cell_subViewsCount: Int {
        get {
            let cells = visibleCells() as! [SJCollectionViewCell]
            if cells.count == 1 {
                return cells.first!.sj_subViews.count
            }
            return 0
        }
    }
    
    // Initialization
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialSetUp()
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        initialSetUp()
    }
    
    private func initialSetUp() {
        // Basic
        setTranslatesAutoresizingMaskIntoConstraints(false)
        backgroundColor = UIColor.whiteColor()
        keyboardDismissMode = .Interactive
        bounces = true
        indicatorStyle = .Black
        pagingEnabled = true

        // Register the Cell
        registerNib(UINib(nibName: "SJCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        
        // Register Supplementary View
        registerNib(UINib(nibName: "SJCollectionRestartReusableView", bundle: nil), forSupplementaryViewOfKind: restartElementkind, withReuseIdentifier: restartIdentifier)
        registerNib(UINib(nibName: "SJCollectionShareReusableView", bundle: nil), forSupplementaryViewOfKind: shareElementKind, withReuseIdentifier: shareIdentifier)
        registerNib(UINib(nibName: "SJCollectionAddToCartReusableView", bundle: nil), forSupplementaryViewOfKind: addToCartElementKind, withReuseIdentifier: addToCartIdentifier)
        registerNib(UINib(nibName: "SJBottomView", bundle: nil), forSupplementaryViewOfKind: utilitiesElementkind, withReuseIdentifier: utilitiesReuseIdentifier)
        
        // Register the decoration view
        // Decoration views are owned by the layout object
        let layout = collectionViewLayout as! SJLayout
        layout.registerNib(UINib(nibName: "SJCollectionDecorationSilkySocksLogoReusableView", bundle: nil), forDecorationViewOfKind: logoElementKind)
    }
    
    // Using it to dismiss the color palette
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as! UITouch
        myDelegate?.collectionView(self, touchesBegan: touch)
        super.touchesBegan(touches, withEvent: event)
    }
}

// MARK: Dequeuing the various supplementary views
extension SJCollectionView {
    
    // Dequeue the bottom utilities view
    func dequeueReusableBottomUtilitiesView(#indexPath: NSIndexPath) -> SJBottomView {
        
        let view = super.dequeueReusableSupplementaryViewOfKind(utilitiesElementkind, withReuseIdentifier: utilitiesReuseIdentifier, forIndexPath: indexPath) as! SJBottomView
        view.delegate = self // important
        sj_bottomView = view
        return view
    }

    // Dequeue the restart buttom
    func dequeueReusableRestartView(#indexPath: NSIndexPath) -> RestartViewCollectionReusableView {
        
        let view = super.dequeueReusableSupplementaryViewOfKind(restartElementkind, withReuseIdentifier: restartIdentifier, forIndexPath: indexPath) as! RestartViewCollectionReusableView
        view.delegate = self // important
        return view
    }
    
    // Dequeue the share button
    func dequeueReusableShareView(#indexPath: NSIndexPath) -> ShareViewCollectionReusableView {
        
        let view = super.dequeueReusableSupplementaryViewOfKind(shareElementKind, withReuseIdentifier: shareIdentifier, forIndexPath: indexPath) as! ShareViewCollectionReusableView
        view.delegate = self // important
        return view
    }
    
    // Dequeue the add to cart button
    func dequeueReusableAddToCartView(#indexPath: NSIndexPath) -> CartViewCollectionReusableView {
        
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

// MARK: Share
extension SJCollectionView: ShareViewCollectionReusableViewDelegate {
    func shareReusableView(view: ShareViewCollectionReusableView, didPressShareButton sender: UIButton) {
        
    }
}

// MARK: Add To Cart
extension SJCollectionView: CartViewCollectionReusableViewDelegate {
    func cartReusableView(view: CartViewCollectionReusableView, didPressAddToCartButton sender: UIButton) {
        let cells = visibleCells() as! [SJCollectionViewCell]
        if cells.count == 1 {
            let cell = cells.first!
            UIGraphicsBeginImageContextWithOptions(cell.frame.size, cell.opaque, 0)
            cell.layer.renderInContext(UIGraphicsGetCurrentContext())
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            // Do Something with the snapshot
            myDelegate?.collectionView(self, didPressAddToCartButton: sender, withSnapShotImage: image, andTemplate: cell.template!)
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
        if cell_subViewsCount == 0 {
            let xOffset = min(contentSize.width - width, contentOffset.x + width)
            setContentOffset(CGPoint(x: xOffset, y: contentOffset.y), animated: true)
        }
    }
    
    // Navigate Left
    func sj_bottomView(view: SJBottomView, didPressLeftButton button: UIButton) {
        if cell_subViewsCount == 0 {
            let xOffset = max(0, contentOffset.x - width)
            setContentOffset(CGPoint(x: xOffset, y: contentOffset.y), animated: true)
        }
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
    func sj_bottomView(view: SJBottomView, didPressSmileyButton button:UIButton) {
        myDelegate?.collectionView(self, bottomView: view, didPressSmileyButton: button)
    }
}

// MARK: Messages from the VC
// Delegate to the cell to create the appropriate views
extension SJCollectionView {
    
    func sj_createTextLabel(text: String, afont: UIFont, acolor: UIColor) {
        if let cell = findCurrentCell() {
            cell.createLabel(text, font: afont, color: acolor)
        }
    }
    
    func sj_createImage(image: UIImage, forGrid: Bool) {
        if let cell = findCurrentCell() {
            cell.createImage(image, forGrid: forGrid)
        }
    }
    
    func sj_addColor(color: UIColor) {
        if let cell = findCurrentCell() {
            cell.addColor(color)
        }
    }
    
    final private func findCurrentCell() -> SJCollectionViewCell? {
        
        let cells = visibleCells() as! [SJCollectionViewCell]
        if cells.count == 1 {
            return cells.first!
        }
        return nil
    }
}

// MARK: Gesture Handling
extension SJCollectionView: UIGestureRecognizerDelegate {
    
    // Essential
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

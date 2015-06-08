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
        
        // KVO
        addObserver(self, forKeyPath: "contentOffset", options: .New, context: nil)
    }
    
    // Using KVO to keep track of the content offset of the collection view
    // Done to prevent navigation when the content offset is already being changed
    var changingOffset = false
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if keyPath == "contentOffset" {
            changingOffset = true
            if let new = change["new"]?.CGPointValue() {
                if new.x % width == 0 {
                    changingOffset = false
                }
            }
        }
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
        if let cell = visibleCell {
            // due to the presence of the info button
            let y = cell.infoButton.bounds.size.height
            let rect = CGRect(origin: CGPoint(x: 0, y: y), size: cell.frame.size)
            let image = cell.clickSnapShot(rect, withLogo: UIImage.SilkySocksLogo())
            myDelegate?.collectionView(self, didPressShareButton: sender, withSnapShotImage: image)
        }
    }
}

// MARK: Add To Cart
extension SJCollectionView: CartViewCollectionReusableViewDelegate {
    func cartReusableView(view: CartViewCollectionReusableView, didPressAddToCartButton sender: UIButton) {
        if let cell = visibleCell {
            let y = cell.infoButton.bounds.size.height
            let rect = CGRect(origin: CGPoint(x: 0, y: y), size: cell.frame.size)
            let image = cell.clickSnapShot(rect, withLogo: UIImage.SilkySocksLogo())
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
        // Make sure that the content offset is not being changed
        // when the right button is clicked
        if !changingOffset {
            let xOffset = min(contentSize.width - width, contentOffset.x + width)
            setContentOffset(CGPoint(x: xOffset, y: contentOffset.y), animated: true)
        }
    }
    
    // Navigate Left
    func sj_bottomView(view: SJBottomView, didPressLeftButton button: UIButton) {
        // Make sure that the content offset is not being changed
        // when the left button is clicked
        if !changingOffset {
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

extension SJCollectionView : SJCollectionViewCellDelegate {
    
    func collectionViewCell(cell: UICollectionViewCell, didSelectView view: UIView?, atPoint point: CGPoint) {
        if let view = view {
            myDelegate?.collectionView(self, didTapSubview: view)
        } else {
            myDelegate?.collectionView(self, touchesBegan: point)
        }
    }
}


// MARK: Gesture Handling
extension SJCollectionView: UIGestureRecognizerDelegate {
    
    // Essential
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

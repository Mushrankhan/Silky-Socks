//
//  SJCollectionView.swift
//  Silky Socks
//
//  Created by Saurabh Jain on 5/15/15.
//  Copyright (c) 2015 Full Stak. All rights reserved.
//

import UIKit

class SJCollectionView: UICollectionView {
    
    // the width of the screen bounds
    private var width: CGFloat {
        get {
           return CGRectGetWidth(UIScreen.mainScreen().bounds)
        }
    }
    
    // The bottom view
    private var sj_bottomView: SJBottomView?
    
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
        
        // Re enable user interaction
        if let sj_bottomView = sj_bottomView {
            sj_bottomView.userInteractionEnabled = true
        }
        
        // Check if the text field exists
        for subView in subviews as! [UIView] {
            if subView.isKindOfClass(SJTextField.self) {
                if subView.canResignFirstResponder() {
                    subView.resignFirstResponder()
                }
                subView.removeFromSuperview()
                return
            }
        }
        
        // If the Label exists
        let cell = visibleCells() as! [SJCollectionViewCell]
        if cell.count == 1 {
            if let sj_label = cell.first!.sj_label {
                sj_label.removeFromSuperview()
                cell.first!.sj_label = nil
            }
        }
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
        
    }
}

// MARK: Bottom Utilities Delegate
extension SJCollectionView: SJBottomViewDelegate {
    
    // Navigate Right
    func sj_bottomView(view: SJBottomView, didPressRightButton button: UIButton) {
        let xOffset = min(contentSize.width - width, contentOffset.x + width)
        setContentOffset(CGPoint(x: xOffset, y: contentOffset.y), animated: true)
    }
    
    // Navigate Left
    func sj_bottomView(view: SJBottomView, didPressLeftButton button: UIButton) {
        let xOffset = max(0, contentOffset.x - width)
        setContentOffset(CGPoint(x: xOffset, y: contentOffset.y), animated: true)
    }
    
    // Text button clicked
    func sj_bottomView(view: SJBottomView, didPressTextButton button:UIButton) {
        let width = CGRectGetWidth(UIScreen.mainScreen().bounds)
        let midY = CGRectGetMidY(bounds)
        let height: CGFloat = 60

        // Create an instance of Text Field
        let textField = SJTextField(frame: CGRect(x: contentOffset.x, y: midY, width: width, height: 60))
        textField.delegate = self
        textField.becomeFirstResponder()
        addSubview(textField)
        
        if let sj_bottomView = sj_bottomView {
            sj_bottomView.userInteractionEnabled = false
        }
    }
}

// MARK: TEXT BUTTON
extension SJCollectionView: UITextFieldDelegate {
    
    // When Done button is pressed
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if count(textField.text) > 0 {
            if textField.canResignFirstResponder() {
                textField.resignFirstResponder()
                // Remove from superview
                textField.removeFromSuperview()
                // Create The label
                createTextLabel(textField.text, afont: textField.font)
                return true
            }
        } else {
            textField.resignFirstResponder()
            textField.removeFromSuperview()
            if let sj_bottomView = sj_bottomView {
                sj_bottomView.userInteractionEnabled = true
            }
            return true
        }
        
        return false
    }
    
    // Create Text Label
    private func createTextLabel(text: String, afont: UIFont) {
        
        let font = UIFont(name: afont.fontName, size: 44)
        // Should return only one cell, because one cell covers the entire area
        let cells = visibleCells() as! [SJCollectionViewCell]
        if cells.count == 1 {
            cells.first!.createLabel(text, font: font!)
        }
    }
}

// MARK: Gesture Handling
extension SJCollectionView: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        if gestureRecognizer == panGestureRecognizer {
            
            for subview in subviews as! [UIView] {
                if subview.isKindOfClass(SJTextField.self) {
                    return false
                }
            }
            
            let location = touch.locationInView(self)
            let index = indexPathForItemAtPoint(location)
            
            if let index = index {
                let cell = cellForItemAtIndexPath(index) as! SJCollectionViewCell
                
                // If the label exists then return false
                if let sj_label = cell.sj_label {
                    return false
                }
            }
        }
        
        return true
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

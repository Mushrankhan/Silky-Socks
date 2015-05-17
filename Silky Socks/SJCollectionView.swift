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

/* Dequeuing the various supplementary views */
extension SJCollectionView {
    
    // Dequeue the bottom utilities view
    func dequeueReusableBottomUtilitiesView(#indexPath: NSIndexPath) -> SJBottomView {
        
        let view = super.dequeueReusableSupplementaryViewOfKind(utilitiesElementkind, withReuseIdentifier: utilitiesReuseIdentifier, forIndexPath: indexPath) as! SJBottomView
        view.delegate = self // important
        return view
    }

    // Dequeue the restart buttom
    func dequeueReusableRestartView(#indexPath: NSIndexPath) -> RestartViewCollectionReusableView {
        
        let view = super.dequeueReusableSupplementaryViewOfKind(restartElementkind, withReuseIdentifier: restartIdentifier, forIndexPath: indexPath) as! RestartViewCollectionReusableView
        return view
    }
    
    // Dequeue the share button
    func dequeueReusableShareView(#indexPath: NSIndexPath) -> ShareViewCollectionReusableView {
        
        let view = super.dequeueReusableSupplementaryViewOfKind(shareElementKind, withReuseIdentifier: shareIdentifier, forIndexPath: indexPath) as! ShareViewCollectionReusableView
        return view
    }
    
    // Dequeue the add to cart button
    func dequeueReusableAddToCartView(#indexPath: NSIndexPath) -> CartViewCollectionReusableView {
        
        let view = super.dequeueReusableSupplementaryViewOfKind(addToCartElementKind, withReuseIdentifier: addToCartIdentifier, forIndexPath: indexPath) as! CartViewCollectionReusableView
        return view
    }
}

/* The bottom utilites view delegate */
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
}




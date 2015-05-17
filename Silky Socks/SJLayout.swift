//
//  SJLayout.swift
//  Silky Socks
//
//  Created by Kevin Koeller on 4/19/15.
//  Copyright (c) 2015 Full Stak. All rights reserved.
//

import UIKit

class SJLayout: UICollectionViewLayout {
    
    // Cache to store the attributes
    private var cache = [UICollectionViewLayoutAttributes]()
    
    // Number of items
    var numberOfItems:Int {
        get {
            return collectionView!.numberOfItemsInSection(0)
        }
    }
    
    // Content Size
    private var contentWidth: CGFloat = 0
    private var contentHeight :CGFloat {
        get {
            let inset = collectionView!.contentInset
            return width - inset.top - inset.bottom
        }
    }
    
    // Width of the collection view
    private var width: CGFloat {
        get {
            return CGRectGetWidth(UIScreen.mainScreen().bounds)
        }
    }
    
    // Height of the collection view
    private var height: CGFloat {
        get {
           return CGRectGetHeight(UIScreen.mainScreen().bounds)
        }
    }
    
    private var heightOfUtilView: CGFloat {
        get {
            return 125
        }
    }
    
    /* The content size of the collection view */
    override func collectionViewContentSize() -> CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    /* Preparing Layout */
    override func prepareLayout() {
        
        // Set the content width
        contentWidth = CGRectGetWidth(UIScreen.mainScreen().bounds) * CGFloat(numberOfItems)
        
        if cache.isEmpty {
            
            // Loop through the items
            for item in 0..<numberOfItems {
                
                // Cell
                let indexPath = NSIndexPath(forItem: item, inSection: 0)
                let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
                let x = CGFloat(item) * width
                
                let frame = CGRect(x: x, y: 0, width: width, height: CGRectGetMaxY(collectionView!.bounds) - heightOfUtilView)
                let insets = UIEdgeInsets(top: 20, left: 10, bottom: 50, right: 10)
                let newFrame = UIEdgeInsetsInsetRect(frame, insets)
                attributes.frame = newFrame
                cache.append(attributes)
            }
        }
    }
    
    /* The Supplementary View */
    override func layoutAttributesForSupplementaryViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        if elementKind == restartElementkind {
            let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, withIndexPath: indexPath)
            var frame = CGRectMake(10, 0, 80, 24)
            frame.origin.x += collectionView!.contentOffset.x
            attributes.frame = frame
            attributes.zIndex = 99
            return attributes
        } else if elementKind == shareElementKind {
            let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, withIndexPath: indexPath)
            var frame = CGRectMake(width - 100, 0, 80, 24)
            frame.origin.x += collectionView!.contentOffset.x
            attributes.frame = frame
            attributes.zIndex = 99
            return attributes
        } else {
            let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, withIndexPath: indexPath)
            var frame = CGRectMake(0, CGRectGetMaxY(collectionView!.bounds) - heightOfUtilView, width, heightOfUtilView)
            frame.origin.x += collectionView!.contentOffset.x
            attributes.frame = frame
            attributes.zIndex = 99
            return attributes
        }
    }
    
    /* The Decoration View */
    override func layoutAttributesForDecorationViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        let attributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind: elementKind, withIndexPath: indexPath)
        var frame = CGRectMake(10, CGRectGetMaxY(collectionView!.bounds) - heightOfUtilView - 80, 80, 80)
        frame.origin.x += collectionView!.contentOffset.x
        attributes.frame = frame
        attributes.zIndex = 99
        return attributes
    }
    
    /* The layout attributes for element in rect */
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        var layoutAttributes: [UICollectionViewLayoutAttributes] = []
        for attributes in cache {
            if CGRectIntersectsRect(attributes.frame, rect){
                layoutAttributes.append(attributes)
            }
        }
        
        let restartAttr = layoutAttributesForSupplementaryViewOfKind(restartElementkind, atIndexPath: NSIndexPath(forItem: 0, inSection: 0))
        let shareAttr = layoutAttributesForSupplementaryViewOfKind(shareElementKind, atIndexPath: NSIndexPath(forItem: 0, inSection: 0))
        let utilAttr = layoutAttributesForSupplementaryViewOfKind(utilitiesElementkind, atIndexPath: NSIndexPath(forItem: 0, inSection: 0))
        let decoration = layoutAttributesForDecorationViewOfKind(logoElementKind, atIndexPath: NSIndexPath(forItem: 0, inSection: 0))
        layoutAttributes.append(restartAttr)
        layoutAttributes.append(shareAttr)
        layoutAttributes.append(utilAttr)
        layoutAttributes.append(decoration)
        
        return layoutAttributes
    }
    
    /* Invalidate the layout for bounds change. Very Essential */
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
}

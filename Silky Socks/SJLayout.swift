//
//  SJLayout.swift
//  Silky Socks
//
//  Created by Kevin Koeller on 4/19/15.
//  Copyright (c) 2015 Full Stak. All rights reserved.
//

import UIKit

// MARK: SJCollectionViewController
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
    
    // Width of the screen
    private var width: CGFloat {
        get {
            return CGRectGetWidth(UIScreen.mainScreen().bounds)
        }
    }
    
    // Height of the screen
    private var height: CGFloat {
        get {
           return CGRectGetHeight(UIScreen.mainScreen().bounds)
        }
    }
    
    // The Height of the bottom utilities area
    private var heightOfUtilView: CGFloat {
        get {
            return 150
        }
    }
    
    /* The content size of the collection view */
    override func collectionViewContentSize() -> CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    /* Preparing Layout */
    override func prepareLayout() {
        
        // Set the content width
        contentWidth = width * CGFloat(numberOfItems)
        
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
        
        // Restart button
        if elementKind == restartElementkind {
            let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, withIndexPath: indexPath)
            var frame = CGRectMake(10, 0, 80, 24)
            frame.origin.x += collectionView!.contentOffset.x
            attributes.frame = frame
            attributes.zIndex = 99
            return attributes
        }
            
        // Share Button
        else if elementKind == shareElementKind {
            let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, withIndexPath: indexPath)
            var frame = CGRectMake(width - 100, 0, 80, 24)
            frame.origin.x += collectionView!.contentOffset.x
            attributes.frame = frame
            attributes.zIndex = 99
            return attributes
        }
        
        // Add To cart
        else if elementKind == addToCartElementKind {
            let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, withIndexPath: indexPath)
            let widthOfCart: CGFloat = 100
            var frame = CGRectMake(width - widthOfCart - 8, CGRectGetMaxY(collectionView!.bounds) - heightOfUtilView - 16, widthOfCart, 24)
            frame.origin.x += collectionView!.contentOffset.x
            attributes.frame = frame
            attributes.zIndex = 99
            return attributes
        }
        // Bottom Utilities View
        else {
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
        let widthOfLogo: CGFloat = 80 // is equal to the height of the logo
        var frame = CGRectMake(10, CGRectGetMaxY(collectionView!.bounds) - heightOfUtilView - widthOfLogo + 32, widthOfLogo, widthOfLogo) // 32 is half the height of the next and previous buttons. Have to do this because the height of the bottom view is bigger than it actually appears. So have to add half the width of the next button to make the decoration silky socks logo near the bottom view that appears on the screen
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
        
        // Index Path
        let indexPath = NSIndexPath(forItem: 0, inSection: 0)
        
        // Different element kinds
        let elementKinds = [restartElementkind, shareElementKind, utilitiesElementkind, addToCartElementKind]
        
        // Loop through and add the supplementary views
        for kind in elementKinds {
            let attributes = layoutAttributesForSupplementaryViewOfKind(kind, atIndexPath: indexPath)
            layoutAttributes.append(attributes)
        }
        
        // Add the decoration view
        let logoAttr = layoutAttributesForDecorationViewOfKind(logoElementKind, atIndexPath: indexPath)
        layoutAttributes.append(logoAttr)
        
        return layoutAttributes
    }
    
    /* Invalidate the layout for bounds change. Very Essential */
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
}


// MARK: Font Header View - SJColorCollectionViewController
// Layout used for the font reusable view
class SJStickyFontHeaderLayout: UICollectionViewFlowLayout {
    
    // Essential
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        
        // Super
        var layoutAttributes = super.layoutAttributesForElementsInRect(rect) as! [UICollectionViewLayoutAttributes]
        
        // Keep track of header
        var headerNeedingLayout = NSMutableIndexSet()
        
        // Register the index path section for the current cells
        for attr in layoutAttributes {
            if attr.representedElementCategory == .Cell {
                headerNeedingLayout.addIndex(attr.indexPath.section)
            }
        }
        
        // Remove the index path section of the header included in the rect
        for attr in layoutAttributes {
            if let element = attr.representedElementKind {
                if element == UICollectionElementKindSectionHeader {
                    headerNeedingLayout.removeIndex(attr.indexPath.section)
                }
            }
        }
        
        // Append the attributes of the header
        headerNeedingLayout.enumerateIndexesUsingBlock { (index, stop) -> Void in
            layoutAttributes.append(self.layoutAttributesForSupplementaryViewOfKind(UICollectionElementKindSectionHeader, atIndexPath: NSIndexPath(forItem: 0, inSection: index)))
        }
        
        // Get the attributes for the header
        for attributes in layoutAttributes {
            if let element = attributes.representedElementKind {
                if element == UICollectionElementKindSectionHeader {
                    
                    // Section in which the header belongs
                    let section = attributes.indexPath.section
                    
                    // Index path for first cell
                    let indexPath = NSIndexPath(forItem: 0, inSection: section)
                    
                    // Index Path for last cell
                    let lastIndexPath = NSIndexPath(forItem: collectionView!.numberOfItemsInSection(section) - 1, inSection: section)
                    
                    // Attributes for first cell
                    let attrForFirstElement = layoutAttributesForItemAtIndexPath(indexPath)
                    // Attributes for last cell
                    let attrForLastElement = layoutAttributesForItemAtIndexPath(lastIndexPath)
                    
                    // Frame for header
                    var frame = attributes.frame
                    
                    let width = CGRectGetWidth(UIScreen.mainScreen().bounds)
                    let minX = CGRectGetMinX(attrForFirstElement.frame) - (2 * frame.width) + width
                    let maxX = CGRectGetMaxX(attrForLastElement.frame) - (2 * frame.width) + width
                    let offset = collectionView!.contentOffset.x
                    let x = max(minX, minX + offset)
                    frame.origin.x = x
                    
                    attributes.frame = frame
                    attributes.zIndex = 100
                }
            }
        }
        
        return layoutAttributes
    }
}

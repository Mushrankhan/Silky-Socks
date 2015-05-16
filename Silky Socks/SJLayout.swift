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
            return CGRectGetWidth(collectionView!.bounds)
        }
    }
    
    // Height of the collection view
    private var height: CGFloat {
        get {
           return CGRectGetHeight(collectionView!.bounds)/2
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
            for item in 0..<collectionView!.numberOfItemsInSection(0) {
                
                // Cell
                let indexPath = NSIndexPath(forItem: item, inSection: 0)
                let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
                let x = CGFloat(item) * width
                
                // For mid - height/2 - 64
                
                let frame = CGRect(x: x, y: 0, width: width, height: height/2)
                attributes.frame = frame
                cache.append(attributes)
            }
        }
    }
    
    /* The layout attributes for element in rect */
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        var layoutAttributes: [UICollectionViewLayoutAttributes] = []
        for attributes in cache {
            if CGRectIntersectsRect(attributes.frame, rect){
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
    
}

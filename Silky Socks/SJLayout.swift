//
//  SJLayout.swift
//  Silky Socks
//
//  Created by Kevin Koeller on 4/19/15.
//  Copyright (c) 2015 Full Stak. All rights reserved.
//

import UIKit


class SJLayout: UICollectionViewLayout {
   
    // Cache
    private var cache = [UICollectionViewLayoutAttributes]()
    //private var suppcache = [UICollectionViewLayoutAttributes]()
    
    // Number of items
    var numberOfItems:Int {
        get{
            return collectionView!.numberOfItemsInSection(0)
        }
    }
    
    // Content Size
    private var contentWidth: CGFloat = 0
    private var contentHeight :CGFloat {
        get{
            let inset = collectionView!.contentInset
            return CGRectGetWidth(collectionView!.bounds) - inset.top - inset.bottom
        }
    }
    
    
    override func collectionViewContentSize() -> CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepareLayout() {
        
        contentWidth = CGRectGetWidth(UIScreen.mainScreen().bounds) * CGFloat(numberOfItems)
        
        if cache.isEmpty {
            
            let width = CGRectGetWidth(collectionView!.bounds)
            let height = CGRectGetHeight(collectionView!.bounds)/2
            
            for item in 0..<collectionView!.numberOfItemsInSection(0) {
                
                // Cell
                let indexPath = NSIndexPath(forItem: item, inSection: 0)
                let attr = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
                
                let x = CGFloat(item) * width
                let frame = CGRect(x: x, y: height/2 - 64, width: width, height: height)
                attr.frame = frame
                cache.append(attr)
             
                //if indexPath.item == 0 {
                    
                    // Supp View
                    let suppAttr = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: "Custom", withIndexPath: indexPath)
                    
                    let f = CGRect(x: x, y: CGRectGetHeight(collectionView!.bounds) - 200, width: CGRectGetWidth(collectionView!.bounds), height: 200)
                    suppAttr.frame = f
                    cache.append(suppAttr)
                    
                //}
                
            }
            
        }
        
        
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        
        var layoutAttributes: [UICollectionViewLayoutAttributes] = []
        
        for attr in cache {
            if CGRectIntersectsRect(attr.frame, rect){
                layoutAttributes.append(attr)
            }
        }
        
        //suppcache[0].frame.origin.x = rect.origin.x
    
        //layoutAttributes.append(suppcache[0])
        
        return layoutAttributes
    }

    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
    override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        var page = ceil(proposedContentOffset.x / CGRectGetWidth(collectionView!.frame));
        return CGPointMake(page * CGRectGetWidth(collectionView!.frame), 0);
        
    }
}

//
//  SJCollectionReusableView.swift
//  Silky Socks
//
//  Created by Saurabh Jain on 5/16/15.
//  Copyright (c) 2015 Full Stak. All rights reserved.
//

import UIKit

// Element Kind
public let restartElementkind = "Restart"
public let shareElementKind = "Share"
public let logoElementKind = "Logo"

// Reuse identifier - Supplementary views
public let restartIdentifier = "RestartReusableView"
public let shareIdentifier = "ShareReusableView"

/* The Restart reusable view */
class RestartViewCollectionReusableView: UICollectionReusableView {
    
    @IBAction func restartButtonPressed(sender: UIButton) {
        println("Restart Button Pressed")
    }
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes!) {
        if layoutAttributes.representedElementCategory == .SupplementaryView {
            if layoutAttributes.representedElementKind == restartElementkind {
                frame = layoutAttributes.frame
            }
        }
    }
    
}

/* The Share reusable view */
class ShareViewCollectionReusableView: UICollectionReusableView {
    
    @IBAction func shareButtonPressed(sender: UIButton) {
        println("Share Button Pressed")
    }
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes!) {
        if layoutAttributes.representedElementCategory == .SupplementaryView {
            if layoutAttributes.representedElementKind == shareElementKind {
                frame = layoutAttributes.frame
            }
        }
    }
}

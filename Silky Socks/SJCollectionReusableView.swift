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
public let addToCartElementKind = "AddToCart"
public let logoElementKind = "Logo"

// Reuse identifier - Supplementary views
public let restartIdentifier = "RestartReusableView"
public let shareIdentifier = "ShareReusableView"
public let addToCartIdentifier = "AddToCartReusableView"

protocol RestartViewCollectionReusableViewDelegate: NSObjectProtocol {
    func restartReusableView(view: RestartViewCollectionReusableView, didPressRestartButton sender: UIButton)
}

/* The Restart reusable view */
class RestartViewCollectionReusableView: UICollectionReusableView {
    
    // Delegate
    weak var delegate: RestartViewCollectionReusableViewDelegate?
    
    @IBAction func restartButtonPressed(sender: UIButton) {
        delegate?.restartReusableView(self, didPressRestartButton: sender)
    }
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes!) {
        if layoutAttributes.representedElementCategory == .SupplementaryView {
            if layoutAttributes.representedElementKind == restartElementkind {
                frame = layoutAttributes.frame
            }
        }
    }
    
    // Return Nib
    class func nib() -> UINib {
        return UINib(nibName: "SJCollectionRestartReusableView", bundle: nil)
    }
    
}

protocol ShareViewCollectionReusableViewDelegate: NSObjectProtocol {
    func shareReusableView(view: ShareViewCollectionReusableView, didPressShareButton sender: UIButton)
}

/* The Share reusable view */
class ShareViewCollectionReusableView: UICollectionReusableView {
    
    // Delegate
    weak var delegate: ShareViewCollectionReusableViewDelegate?
    
    @IBAction func shareButtonPressed(sender: UIButton) {
        delegate?.shareReusableView(self, didPressShareButton: sender)
    }
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes!) {
        if layoutAttributes.representedElementCategory == .SupplementaryView {
            if layoutAttributes.representedElementKind == shareElementKind {
                frame = layoutAttributes.frame
            }
        }
    }
    
    // Return Nib
    class func nib() -> UINib {
        return UINib(nibName: "SJCollectionShareReusableView", bundle: nil)
    }
}

protocol CartViewCollectionReusableViewDelegate: NSObjectProtocol {
    func cartReusableView(view: CartViewCollectionReusableView, didPressAddToCartButton sender: UIButton)
}

class CartViewCollectionReusableView: UICollectionReusableView {
    
    // Delegate
    weak var delegate: CartViewCollectionReusableViewDelegate?
    
    @IBAction func didPressAddToCartButton(sender: UIButton) {
        delegate?.cartReusableView(self, didPressAddToCartButton: sender)
    }
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes!) {
        if layoutAttributes.representedElementCategory == .SupplementaryView {
            if layoutAttributes.representedElementKind == addToCartElementKind {
                frame = layoutAttributes.frame
            }
        }
    }
    
    // Return Nib
    class func nib() -> UINib {
        return UINib(nibName: "SJCollectionAddToCartReusableView", bundle: nil)
    }
}

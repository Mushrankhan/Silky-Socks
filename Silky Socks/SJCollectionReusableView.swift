//
//  SJCollectionReusableView.swift
//  Silky Socks
//
//  Created by Saurabh Jain on 5/16/15.
//  Copyright (c) 2015 Saurabh Jain. All rights reserved.
//

import UIKit

// Element Kind
public let restartElementkind   = "Restart"
public let shareElementKind     = "Share"
public let addToCartElementKind = "AddToCart"
public let logoElementKind      = "Logo"

// Reuse identifier - Supplementary views
public let restartIdentifier    = "RestartReusableView"
public let shareIdentifier      = "ShareReusableView"
public let addToCartIdentifier  = "AddToCartReusableView"

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
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
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
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
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
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
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


// MARK: SJColorCollectionViewController Header View
// The following class is a sub class of UICollectionReusableView, and is used to dequeue a UICollectionElementKindHeader View for the SJColorCollectionViewController. The following view is to give users the option to switch between colors and fonts appropriately.

public let fontReuseIdentifier = "fontReuseIdentifier"

protocol FontCollectionReusableViewDelegate: class {
    func fontColorHeaderReusableView(headerView: UICollectionReusableView, didTapHeaderButton sender: UIButton)
}

enum Switch {
    case Color
    case Font
}

class FontCollectionReusableView: UICollectionReusableView {
    
    // Init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialSetUp()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetUp()
    }
    
    // Delegate
    weak var delegate: FontCollectionReusableViewDelegate?
    
    // UIButton
    private var textButton: UIButton!
    
    // Choice
    var choice: Switch = .Color {
        didSet {
            switch choice {
                case .Color:
                    textButton?.setImage(UIImage(named: "switch_color"), forState: .Normal)
                case .Font:
                    textButton?.setImage(UIImage(named: "switch_text"), forState: .Normal)
            }
        }
    }
    
    private func initialSetUp() {
        // Add a UIButton
        textButton = UIButton(frame: bounds)
        textButton?.backgroundColor = UIColor.whiteColor()
        textButton?.setImage(UIImage(named: "switch_text"), forState: .Normal)
        textButton.addTarget(self, action: "handleButtonTap:", forControlEvents: .TouchUpInside)
        
        // Add and Pin SubView
        addSubview(textButton)
        pinSubviewToView(subView: textButton)
    }
    
    // Button SEL
    @objc private func handleButtonTap(sender: UIButton) {
        delegate?.fontColorHeaderReusableView(self, didTapHeaderButton: sender)
    }
}

//
//  SJColorCollectionViewController.swift
//  Silky Socks
//
//  Created by Saurabh Jain on 5/30/15.
//  Copyright (c) 2015 Saurabh Jain. All rights reserved.
//

import UIKit

// Reuse Identifier
let colorReuseIdentifier = "Cell"

// Protocol
protocol SJColorCollectionViewControllerDelegate: class {
    func colorCollectionView(collectionView: UICollectionView, didSelectColor color: UIColor)
    func colorCollectionView(collectionView: UICollectionView, didSelectFont font: UIFont)
}

class SJColorCollectionViewController: UICollectionViewController {

    // Model
    lazy private var colors = UIColor.getColorPalette()
    lazy private var fonts = UIFont.getFontPalette()
    
    // Tells that the user wants to dequeue the supplementary header view or not
    var wantFont: Bool = false {
        didSet {
            showFont = false
        }
    }
    
    // Used to switch between colors and fonts, if 'wantFont' is true
    private var showFont: Bool = false
    
    // Used for passing data from this vc to the parent vc
    weak var delegate: SJColorCollectionViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell classes
        collectionView!.registerClass(SJColorFontCollectionViewCell.self, forCellWithReuseIdentifier: colorReuseIdentifier)
        
        // Register header view
        collectionView!.registerClass(FontCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: fontReuseIdentifier)
        
        // Do not bounce, bounciness in this collectionVC causes bounciness in the main collection VC
        collectionView!.bounces = false
    }
}

// MARK: UICollectionViewDataSource
extension SJColorCollectionViewController {
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return showFont ? fonts.count : colors.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(colorReuseIdentifier, forIndexPath: indexPath) as! SJColorFontCollectionViewCell
    
        // Configure the cell
        if showFont {
            cell.text = "Aa"
            cell.font = UIFont(name: fonts[indexPath.row].fontName, size: 18)
            cell.backgroundColor = UIColor.blackColor()
        } else {
            cell.backgroundColor = colors[indexPath.row]
        }
        
        return cell
    }
    
    // Dequeue the supplementary header view
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let fontHeader = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: fontReuseIdentifier, forIndexPath: indexPath) as! FontCollectionReusableView
        fontHeader.delegate = self // Essential to detect touches on this view
        fontHeader.choice = showFont ? .Color : .Font
        
        // If user does not want the option to switch to fonts, then hide the header view
        fontHeader.hidden = !wantFont ? true : false
        return fontHeader
    }
    
}

// MARK: UICollectionViewDelegate
extension SJColorCollectionViewController {
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // If !showFont, then pass on color : pass on font
        showFont == false ? delegate?.colorCollectionView(collectionView, didSelectColor: colors[indexPath.row]) : delegate?.colorCollectionView(collectionView, didSelectFont: fonts[indexPath.row])
    }
}

// MARK: FontCollectionReusableViewDelegate
extension SJColorCollectionViewController: FontCollectionReusableViewDelegate {
    
    func fontColorHeaderReusableView(headerView: UICollectionReusableView, didTapHeaderButton sender: UIButton) {
        // when the header view is tapped then toggle the 'showFont' variable
        showFont = !showFont
        collectionView?.reloadSections(NSIndexSet(index: 0))
    }
}

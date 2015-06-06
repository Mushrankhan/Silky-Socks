//
//  SJColorCollectionViewController.swift
//  Silky Socks
//
//  Created by Saurabh Jain on 5/30/15.
//  Copyright (c) 2015 Full Stak. All rights reserved.
//

import UIKit

let colorReuseIdentifier = "Cell"

protocol SJColorCollectionViewControllerDelegate: class {
    func colorCollectionView<T>(collectionView: UICollectionView, didSelectColorOrFont object: T)
}

class SJColorCollectionViewController: UICollectionViewController {

    lazy private var colors = UIColor.getColorPalette()
    lazy private var fonts = UIFont.getFontPalette()
    
    // Used for passing data from this vc to the parent vc
    weak var delegate: SJColorCollectionViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell classes
        collectionView!.registerClass(SJColorFontCollectionViewCell.self, forCellWithReuseIdentifier: colorReuseIdentifier)
        
        // Do not bounce
        collectionView!.bounces = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: UICollectionViewDataSource
extension SJColorCollectionViewController {

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 2
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return colors.count
        }
        return fonts.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(colorReuseIdentifier, forIndexPath: indexPath) as! SJColorFontCollectionViewCell
    
        // Configure the cell
        if indexPath.section == 0 {
            cell.backgroundColor = colors[indexPath.row]
        } else {
            cell.text = "Aa"
            cell.font = UIFont(name: fonts[indexPath.row].fontName, size: 18)
            cell.backgroundColor = UIColor.blackColor()
        }
    
        return cell
    }
}

// MARK: UICollectionViewDelegate
extension SJColorCollectionViewController {
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        indexPath.section == 0 ? delegate?.colorCollectionView(collectionView, didSelectColorOrFont: colors[indexPath.row]) : delegate?.colorCollectionView(collectionView, didSelectColorOrFont: fonts[indexPath.row])
    }
    
}

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
    func colorCollectionView(collectionView: UICollectionView, didSelectColor color: UIColor)
}

class SJColorCollectionViewController: UICollectionViewController {

    lazy private var colors = UIColor.getColorPalette()
    
    // Used for passing data from this vc to the parent vc
    weak var delegate: SJColorCollectionViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell classes
        collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: colorReuseIdentifier)
        
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
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(colorReuseIdentifier, forIndexPath: indexPath) as! UICollectionViewCell
    
        // Configure the cell
        cell.backgroundColor = colors[indexPath.row]
    
        return cell
    }
}

// MARK: UICollectionViewDelegate
extension SJColorCollectionViewController {
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        delegate?.colorCollectionView(collectionView, didSelectColor: colors[indexPath.row])
    }
    
}

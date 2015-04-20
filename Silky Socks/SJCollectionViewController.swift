//
//  SJCollectionViewController.swift
//  Silky Socks
//
//  Created by Kevin Koeller on 4/19/15.
//  Copyright (c) 2015 Full Stak. All rights reserved.
//

import UIKit

let reuseIdentifier = "Cell"
let suppReuse = "HeaderView"

class SJCollectionViewController: UICollectionViewController {

    private var dataSource = SJCollectionViewDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register Nibs
        collectionView!.registerNib(UINib(nibName: "SJCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        collectionView!.registerNib(UINib(nibName: "SJCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: "Custom", withReuseIdentifier: suppReuse)
        
        collectionView!.backgroundColor = UIColor.whiteColor()
        
        collectionView!.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 200, right: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}


// MARK: UICollectionViewDataSource

extension SJCollectionViewController: UICollectionViewDataSource {

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return dataSource.numberOfSections()
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.numberOfItemsInSection(section)
     }

  override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! SJCollectionViewCell
        
        // Configure the cell
        cell.image = dataSource.imageForRowAtIndexPath(indexPath)
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        
        switch kind {
            
        case "Custom":
            
            let footerview = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: suppReuse, forIndexPath: indexPath) as! SJCollectionReusableView
            return footerview
            
        default:
            assert(false, "Unexpected Element Kind")
            
        }
    }
    
}


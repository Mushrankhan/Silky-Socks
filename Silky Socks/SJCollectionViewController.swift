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

class SJCollectionViewController: UIViewController {

    private var dataSource = SJCollectionViewDataSource()
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var ss_utilitiesView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register Nibs
        collectionView!.registerNib(UINib(nibName: "SJCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        
        // Data Source
        collectionView!.dataSource = self
        collectionView!.delegate = self
        
        //collectionView!.backgroundColor = UIColor.yellowColor()
        collectionView!.backgroundColor = UIColor.whiteColor()
        
        collectionView!.pagingEnabled = true
        
        var bottomView = NSBundle.mainBundle().loadNibNamed("SJBottomView", owner: nil, options: nil).first as! SJBottomView
        ss_utilitiesView.addSubview(bottomView)
        ss_utilitiesView.pinSubviewToView(subView: bottomView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}


// MARK: UICollectionViewDataSource

extension SJCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return dataSource.numberOfSections()
    }


    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.numberOfItemsInSection(section)
     }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! SJCollectionViewCell
        
        // Configure the cell
        cell.image = dataSource.imageForRowAtIndexPath(indexPath)
        
        return cell
    }
        
}


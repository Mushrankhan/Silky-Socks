//
//  SJCollectionViewController.swift
//  Silky Socks
//
//  Created by Kevin Koeller on 4/19/15.
//  Copyright (c) 2015 Full Stak. All rights reserved.
//

import UIKit

class SJCollectionViewController: UIViewController {

    // the array containing templates
    private var templateArray = Template.allTemplates()
    
    // Cell Reuse identifier
    private let reuseIdentifier = "Cell"
    
    // Collection view
    @IBOutlet weak var collectionView: SJCollectionView!

    
    // Bottom utilities view
    @IBOutlet weak var ss_utilitiesView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register Nibs
        //collectionView!.registerNib(UINib(nibName: "SJCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        
        // Data Source
        collectionView!.dataSource = self
        collectionView!.delegate = self
        
        //collectionView!.backgroundColor = UIColor.yellowColor()
        collectionView!.backgroundColor = UIColor.whiteColor()
        
        // Enable paging
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

extension SJCollectionViewController: SJCollectionViewDataSource, UICollectionViewDelegate {

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return templateArray.count
     }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! SJCollectionViewCell
        
        // Configure the cell
        let template = templateArray[indexPath.row]
        cell.image = template.image
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, heightForImageAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat {
        return 100
    }
}


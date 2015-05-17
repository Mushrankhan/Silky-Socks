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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting the Top Silcy Socks Logo
        let nav_barHeight = CGRectGetHeight(navigationController!.navigationBar.bounds)
        let img_view = UIImageView(image: UIImage(named: "topbar_logo"))
        img_view.frame = CGRectMake(0, 0, 150, nav_barHeight - 10)
        img_view.contentMode = .ScaleAspectFit
        navigationItem.titleView = img_view
        
        // Data Source
        collectionView!.dataSource = self
        collectionView!.delegate = self
        
        //collectionView!.backgroundColor = UIColor.yellowColor()
        collectionView!.backgroundColor = UIColor.whiteColor()
        
        // Enable paging
        collectionView!.pagingEnabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


// MARK: UICollectionViewDataSource

extension SJCollectionViewController: SJCollectionViewDataSource, SJCollectionViewDelegate {

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
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        let collView = collectionView as! SJCollectionView
        
        if kind == restartElementkind {
            return collView.dequeueReusableRestartView(indexPath: indexPath)
        } else if kind == shareElementKind {
            return collView.dequeueReusableShareView(indexPath: indexPath)
        } else {
            return collView.dequeueReusableBottomUtilitiesView(indexPath: indexPath)
        }
    }
    
}
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
        
        // the bottom utilities view
        var bottomView = NSBundle.mainBundle().loadNibNamed("SJBottomView", owner: nil, options: nil).first as! SJBottomView
        ss_utilitiesView.addSubview(bottomView)
        ss_utilitiesView.pinSubviewToView(subView: bottomView)
        bottomView.delegate = self
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
    
//    func collectionView(collectionView: UICollectionView, heightForImageAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat {
//        return 100
//    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == restartElementkind {
            let view = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: restartIdentifier , forIndexPath: indexPath) as! RestartViewCollectionReusableView
            return view
        } else if kind == shareElementKind {
            let view = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: shareIdentifier , forIndexPath: indexPath) as! ShareViewCollectionReusableView
            return view
        }
        return collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "", forIndexPath: indexPath) as! UICollectionReusableView
    }
    
}

extension SJCollectionViewController: SJBottomViewDelegate {
    
    func sj_bottomView(view: SJBottomView, didPressRightButton button: SJButton) {
        print("Right")
        //collectionView.setContentOffset(CGPoint(x: 100, y: 0), animated: true)
    }
    
    func sj_bottomView(view: SJBottomView, didPressLeftButton button: SJButton) {
        print("Left")
    }
}


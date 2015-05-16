//
//  SJCollectionView.swift
//  Silky Socks
//
//  Created by Saurabh Jain on 5/15/15.
//  Copyright (c) 2015 Full Stak. All rights reserved.
//

import UIKit

class SJCollectionView: UICollectionView {
    
    // The Data Source Object
    //var dataSource: SJCollectionViewDataSource
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialSetUp()
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        initialSetUp()
    }

    private func initialSetUp() {
        // Basic
        setTranslatesAutoresizingMaskIntoConstraints(false)
        backgroundColor = UIColor.whiteColor()
        keyboardDismissMode = .Interactive
        bounces = true
        indicatorStyle = .Black

        // Register the cell nib
        registerNib(UINib(nibName: "SJCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        
        // Register Supplementary View
        registerNib(UINib(nibName: "SJCollectionRestartReusableView", bundle: nil), forSupplementaryViewOfKind: restartElementkind, withReuseIdentifier: restartIdentifier)
        registerNib(UINib(nibName: "SJCollectionShareReusableView", bundle: nil), forSupplementaryViewOfKind: shareElementKind, withReuseIdentifier: shareIdentifier)
        
        // Register the decoration view
        let layout = collectionViewLayout as! SJLayout
        layout.registerNib(UINib(nibName: "SJCollectionDecorationSilkySocksLogoReusableView", bundle: nil), forDecorationViewOfKind: logoElementKind)
    }
}

//
//  SJCollectionView.swift
//  Silky Socks
//
//  Created by Saurabh Jain on 5/15/15.
//  Copyright (c) 2015 Full Stak. All rights reserved.
//

import UIKit

class SJCollectionView: UICollectionView {

    private let reuseIdentifier = "Cell"
    
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
        setTranslatesAutoresizingMaskIntoConstraints(false)
        backgroundColor = UIColor.whiteColor()
        keyboardDismissMode = .Interactive
        alwaysBounceVertical = true
        bounces = true
        
        // Register the cell nib
        registerNib(UINib(nibName: "SJCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)

    }
}

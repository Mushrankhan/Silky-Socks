//
//  CheckoutTableHeaderView.swift
//  Silky Socks
//
//  Created by Saurabh Jain on 6/21/15.
//  Copyright (c) 2015 Saurabh Jain. All rights reserved.
//

import UIKit

class CheckoutTableHeaderView: UIView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var items: [CartProduct]!
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.backgroundColor = UIColor.getColor(red: 224, green: 224, blue: 224, alpha: 1)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.registerClass(CartHeaderCollectionCell.self, forCellWithReuseIdentifier: "CartHeaderCollectionCell")
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 0, left: floor(CGRectGetWidth(UIScreen.mainScreen().bounds) / 2 - 75), bottom: 0, right: 0)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CartHeaderCollectionCell", forIndexPath: indexPath) as! CartHeaderCollectionCell
        cell.imageView.image = items[indexPath.row].cartImage
        return cell
    }

}


private class CartHeaderCollectionCell: UICollectionViewCell {
    
    var imageView: UIImageView!
    
    private override func awakeFromNib() {
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        imageView = UIImageView(frame: bounds)
        imageView.contentMode = .ScaleAspectFit
        pinSubviewToView(subView: imageView)
    }
}


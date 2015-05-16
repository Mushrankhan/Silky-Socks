//
//  SJCollectionViewCell.swift
//  Silky Socks
//
//  Created by Kevin Koeller on 4/19/15.
//  Copyright (c) 2015 Full Stak. All rights reserved.
//

import UIKit

public let reuseIdentifier = "Cell"

class SJCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var ss_imgView: UIImageView!
    
    var image:UIImage? {
        didSet {
            if let img = image {
                ss_imgView?.image = img
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        autoresizingMask = UIViewAutoresizing.FlexibleHeight | .FlexibleWidth
        setTranslatesAutoresizingMaskIntoConstraints(false)
        //backgroundColor = UIColor.yellowColor()
    }
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes!) {
        
        if let attr = layoutAttributes {
            self.frame = attr.frame
        }
    }
    
}

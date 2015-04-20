//
//  SJCollectionViewCell.swift
//  Silky Socks
//
//  Created by Kevin Koeller on 4/19/15.
//  Copyright (c) 2015 Full Stak. All rights reserved.
//

import Foundation
import UIKit

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
        
        self.autoresizingMask = UIViewAutoresizing.FlexibleHeight | .FlexibleWidth
        self.setTranslatesAutoresizingMaskIntoConstraints(false)
    }
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes!) {
        
        if let attr = layoutAttributes {
            self.frame = attr.frame
        }
    }
    
}

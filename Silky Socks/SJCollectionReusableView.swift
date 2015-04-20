//
//  SJCollectionReusableView.swift
//  Silky Socks
//
//  Created by Kevin Koeller on 4/19/15.
//  Copyright (c) 2015 Full Stak. All rights reserved.
//

import UIKit

class SJCollectionReusableView: UICollectionReusableView {

    override func awakeFromNib() {
        super.awakeFromNib()
       
        self.autoresizingMask = .FlexibleHeight | .FlexibleWidth
        self.setTranslatesAutoresizingMaskIntoConstraints(false)
    }
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes!) {
        
        if let attr = layoutAttributes{
            self.frame  = attr.frame
        }
    }

    
}

//
//  SJColorFontCollectionViewCell.swift
//  Silky Socks
//
//  Created by Saurabh Jain on 6/5/15.
//  Copyright (c) 2015 Saurabh Jain. All rights reserved.
//

import UIKit

class SJColorFontCollectionViewCell: UICollectionViewCell {
    
    var text: String? { didSet { textLabel?.text = text } }
    var font: UIFont? { didSet { textLabel?.font = font } }
    
    // Text support added to the cell
    private var textLabel: UILabel?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialSetup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    // Basic Set up
    private func initialSetup() {
        textLabel = UILabel(frame: bounds)
        textLabel?.textColor = UIColor.whiteColor()
        textLabel?.textAlignment = .Center
        addSubview(textLabel!)
        pinSubviewToView(subView: textLabel!)
    }
    
    // Essential
    override func prepareForReuse() {
        text = nil
    }
    
}

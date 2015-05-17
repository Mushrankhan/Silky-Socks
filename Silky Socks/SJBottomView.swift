//
//  SJBottomView.swift
//  Silky Socks
//
//  Created by Kevin Koeller on 4/19/15.
//  Copyright (c) 2015 Full Stak. All rights reserved.
//

import UIKit

protocol SJBottomViewDelegate: NSObjectProtocol {
    
    func sj_bottomView(view: SJBottomView, didPressRightButton button:UIButton)
    func sj_bottomView(view: SJBottomView, didPressLeftButton button:UIButton)
}

public let utilitiesReuseIdentifier = "UtilitiesReuseIdentifier"
public let utilitiesElementkind = "Utilities"

class SJBottomView: UICollectionReusableView {
    
    // Grid Camera (4th button) constraints
    @IBOutlet weak var gridCameraButtonTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var gridCameraButtonLeadingConstraint: NSLayoutConstraint!
    
    // Text button (2nd Button) constraints
    @IBOutlet weak var textButtonLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var textButtonTrailingConstraint: NSLayoutConstraint!
    
    // Buttons
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var colorWheelButton: UIButton!
    @IBOutlet weak var simleyButton: UIButton!
    
    // the Delegate object
    weak var delegate: SJBottomViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        autoresizingMask = .FlexibleWidth | .FlexibleHeight
        setTranslatesAutoresizingMaskIntoConstraints(false)
    }
    
    // Set the constraints appropriately
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Calculate the distance between the surrounding buttons
        var distance = fabs(cameraButton.frame.maxX - colorWheelButton.frame.minX)
        
        // Subtract the width of the button
        distance -= cameraButton.frame.width
        
        // Set the trailing and the leading constraint to be half of the distance
        textButtonLeadingConstraint.constant = distance/2
        textButtonTrailingConstraint.constant = distance/2
        
        // Same for the grid camera button
        distance = fabs(colorWheelButton.frame.maxX - simleyButton.frame.minX)
        distance -= colorWheelButton.frame.width
        gridCameraButtonLeadingConstraint.constant = distance/2
        gridCameraButtonTrailingConstraint.constant = distance/2
    }
}

// Navigation Buttons - Previous and Forward
extension SJBottomView {
    
    // Next
    @IBAction func didPressNextButton(sender: UIButton) {
        delegate?.sj_bottomView(self, didPressRightButton: sender)
    }
    
    // Previous
    @IBAction func didPressPreviousButton(sender: UIButton) {
        delegate?.sj_bottomView(self, didPressLeftButton: sender)
    }
}

// Customization Utilities View
extension SJBottomView {
    
    @IBAction func didPressUtilityButton(sender: UIButton) {
        
        // Switching on the tags
        // Done to prevent multiple IBActions
        switch sender.tag {
            case 1:
                println("Camera")
            case 2:
                println("Text")
            case 3:
                println("Color")
            case 4:
                println("Grid")
            case 5:
                println("Smiley")
            default:
                break
        }
    }
    
}


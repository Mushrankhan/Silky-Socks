//
//  SJBottomView.swift
//  Silky Socks
//
//  Created by Kevin Koeller on 4/19/15.
//  Copyright (c) 2015 Saurabh Jain. All rights reserved.
//

import UIKit

protocol SJBottomViewDelegate: NSObjectProtocol {
    
    // Navigation
    func sj_bottomView(view: SJBottomView, didPressRightButton button:UIButton)
    func sj_bottomView(view: SJBottomView, didPressLeftButton button:UIButton)
    
    // Customization Support
    func sj_bottomView(view: SJBottomView, didPressCameraButton button:UIButton)
    func sj_bottomView(view: SJBottomView, didPressTextButton button:UIButton)
    func sj_bottomView(view: SJBottomView, didPressColorWheelButton button:UIButton)
    func sj_bottomView(view: SJBottomView, didPressGridButton button:UIButton)
    func sj_bottomView(view: SJBottomView, didPressQuestionButton button:UIButton)
}

// Bottom View Reuse Identifier
internal let utilitiesReuseIdentifier = "UtilitiesReuseIdentifier"
internal let utilitiesElementkind = "Utilities"

// The bottom utilities view which provides support
// for customization is a subclass of a UICollectionReusableView
class SJBottomView: UICollectionReusableView {
    
//    // Grid Camera (4th button) constraints
//    @IBOutlet weak var gridCameraButtonTrailingConstraint: NSLayoutConstraint!
//    @IBOutlet weak var gridCameraButtonLeadingConstraint: NSLayoutConstraint!
//
//    // Text button (2nd Button) constraints
//    @IBOutlet weak var textButtonLeadingConstraint: NSLayoutConstraint!
//    @IBOutlet weak var textButtonTrailingConstraint: NSLayoutConstraint!
    
    // Buttons
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var textButton: UIButton!
    @IBOutlet weak var colorWheelButton: UIButton!
//    @IBOutlet weak var gridButton: UIButton!
    @IBOutlet weak var questionButton: UIButton!
    
    // Navigation
    @IBOutlet weak var preButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    // the Delegate object
    weak var delegate: SJBottomViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    // Return Nib
    class func nib() -> UINib {
        return UINib(nibName: "SJBottomView", bundle: nil)
    }
    
    /* Custom Drawing */
    override func drawRect(rect: CGRect) {
        
        // Context
        let context = UIGraphicsGetCurrentContext()
        
        // Width and height
        let width = CGRectGetWidth(rect)
        let height = CGRectGetHeight(rect)
        
        // The y coordinate to draw the light gray view
        let y: CGFloat = 8 + CGRectGetHeight(nextButton.frame) / 2
        let grayRect = CGRect(x: CGFloat(0), y: y, width: width, height: height - y)
        
        // The height of the dark gray view is 8 points
        let heightOfDarkView: CGFloat = 8
        let darkGrayRect = CGRect(x: 0, y: y - heightOfDarkView, width: width, height: heightOfDarkView)
        
        // The Gray box
        CGContextSetRGBFillColor(context, 229.0/255, 229.0/255, 229.0/255, 1)
        CGContextFillRect(context, grayRect)
        
        // The dark grey box
        CGContextSetFillColorWithColor(context, UIColor.getColor(red: 216, green: 216, blue: 216, alpha: 1.0).CGColor)
        CGContextFillRect(context, darkGrayRect)
    }
    
    // Set the constraints appropriately
    override func layoutSubviews() {
        super.layoutSubviews()
                
//        // Calculate the distance between the surrounding buttons
//        var distance = fabs(cameraButton.frame.maxX - colorWheelButton.frame.minX)
//
//        // Subtract the width of the button
//        distance -= cameraButton.frame.width
//
//        // Set the trailing and the leading constraint to be half of the distance
//        textButtonLeadingConstraint.constant = distance/2
//        textButtonTrailingConstraint.constant = distance/2
//
//        // Same for the grid camera button
//        distance = fabs(colorWheelButton.frame.maxX - questionButton.frame.minX)
//        distance -= colorWheelButton.frame.width
//        gridCameraButtonLeadingConstraint.constant = distance/2
//        gridCameraButtonTrailingConstraint.constant = distance/2
    }
}

// Navigation Buttons
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
            case SJBottomViewConstants.Image:
                delegate?.sj_bottomView(self, didPressCameraButton: sender)
            case SJBottomViewConstants.Text:
                delegate?.sj_bottomView(self, didPressTextButton: sender)
            case SJBottomViewConstants.Color:
                delegate?.sj_bottomView(self, didPressColorWheelButton: sender)
            case SJBottomViewConstants.Grid:
                delegate?.sj_bottomView(self, didPressGridButton: sender)
            case SJBottomViewConstants.Question:
                delegate?.sj_bottomView(self, didPressQuestionButton: sender)
            default:
                break
        }
    }
    
}

// Storing the tags for the buttons
internal struct SJBottomViewConstants {
    static let Image = 1
    static let Text = 2
    static let Color = 3
    static let Grid = 4
    static let Question = 5
}



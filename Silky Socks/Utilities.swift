//
//  Utilities.swift
//  Silky Socks
//
//  Created by Saurabh Jain on 4/19/15.
//  Copyright (c) 2015 Full Stak. All rights reserved.
//

import UIKit

extension UIView {
    
    // Pin a subview to the edges of the superview
    func pinSubviewToView(#subView: UIView) {
        
        addAttributeToView(NSLayoutAttribute.Top, subview: subView)
        addAttributeToView(NSLayoutAttribute.Leading, subview: subView)
        addAttributeToView(NSLayoutAttribute.Bottom, subview: subView)
        addAttributeToView(NSLayoutAttribute.Trailing, subview: subView)
        
        self.setNeedsUpdateConstraints()
    }
    
    private func addAttributeToView(attribute: NSLayoutAttribute, subview: UIView) {
        addConstraint(NSLayoutConstraint(item: self, attribute: attribute, relatedBy: NSLayoutRelation.Equal, toItem: subview, attribute: attribute, multiplier: 1.0, constant: 0))
    }
    
    // Clicks a snapshot of the view
    func clickSnapShot(size: CGSize) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(size, opaque, 0)
        layer.renderInContext(UIGraphicsGetCurrentContext())
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    // Print the view heirarchy
    func logSubViews() {
        println(self)
        for view in subviews as! [UIView]{
            view.logSubViews()
        }
    }
}

extension UIColor {
    
    // Helper Function
    class func getColor(#red: Int, green: Int, blue: Int, alpha: CGFloat) -> UIColor {
        let divisor: CGFloat = 255
        return UIColor(red: CGFloat(red)/divisor, green: CGFloat(green)/divisor, blue: CGFloat(blue)/divisor, alpha: alpha)
    }
    
    // Get Color Palette
    class func getColorPalette() -> [UIColor] {
        
        var array = [UIColor]()
        
        for var i = 0; i < 6 ; ++i   { array.append(UIColor.getColor(red: i*51 , green: i*51  , blue: i*51 , alpha: 1)) }
        for var i = 0; i < 7 ; ++i   { array.append(UIColor.getColor(red: 255  , green: i*34  , blue: 0    , alpha: 1)) }
        for var i = 7; i >= 0; --i   { array.append(UIColor.getColor(red: 34*i , green: 255   , blue: 0    , alpha: 1)) }
        for var i = 1; i < 8 ; ++i   { array.append(UIColor.getColor(red: 0    , green: 255   , blue: i*34 , alpha: 1)) }
        for var i = 7; i >= 0; --i   { array.append(UIColor.getColor(red: 0    , green: i*34  , blue: 255  , alpha: 1)) }
        for var i = 1; i < 7 ; ++i   { array.append(UIColor.getColor(red: i*34 , green: 0     , blue: 255  , alpha: 1)) }
        for var i = 7; i >= 0; --i   { array.append(UIColor.getColor(red: 255  , green: 0     , blue: i*34 , alpha: 1)) }
        
        return array
    }
}

extension UIImage {
    
    // Aspect Fit Size
    class func getBoundingSizeForAspectFit(aspectRatio: CGSize, var imageViewSize boundingSize: CGSize) -> CGSize {
        
        let mW = boundingSize.width / aspectRatio.width;
        let mH = boundingSize.height / aspectRatio.height;
        if mH < mW {
            boundingSize.width = boundingSize.height / aspectRatio.height * aspectRatio.width
        } else if mW < mH {
            boundingSize.height = boundingSize.width / aspectRatio.width * aspectRatio.height
        }
        
        return boundingSize
    }
    
    // Tint the image
    func colorizeWith(color: UIColor) -> UIImage {
        
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()

        // Flip
        CGContextTranslateCTM(context, 0, size.height)
        CGContextScaleCTM(context, 1, -1)
        
        // set the blend mode to color burn, and the original image
        CGContextSetBlendMode(context, kCGBlendModeDarken)
        let rect = CGRectMake(0, 0, size.width, size.height)
        CGContextDrawImage(context, rect, CGImage)
        
        // set a mask that matches the shape of the image, then draw a colored rectangle
        CGContextClipToMask(context, rect, CGImage)
        CGContextAddRect(context, rect)
        color.setFill()
        CGContextDrawPath(context,kCGPathFill)
        
        // new image
        let coloredImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //return the tinted image
        return coloredImage;
    }
    
    // Draw image or tile
    func drawImage(overlayImage: UIImage, forTiling tile: Bool) -> UIImage {
        
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        
        // Flip the context
        CGContextTranslateCTM(context, 0, size.height)
        CGContextScaleCTM(context, 1, -1)

        // set the blend mode to color burn, and the original image
        CGContextSetBlendMode(context, kCGBlendModeMultiply)
        let rect = CGRect(origin: .zeroPoint, size: size)
        CGContextDrawImage(context, rect, CGImage)
        
        // set a mask that matches the shape of the image, then draw a colored rectangle
        CGContextClipToMask(context, rect, CGImage)
        
        // Draw normal or tiled image
        tile ? CGContextDrawTiledImage(context, CGRect(origin: .zeroPoint, size: CGSize(width: 125, height: 125)) ,overlayImage.CGImage) : CGContextDrawImage(context, rect, overlayImage.CGImage)
        
        // generate a new UIImage from the graphics context we drew onto
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        //return the image
        return image;
        
    }
    
}
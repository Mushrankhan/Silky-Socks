//
//  Utilities.swift
//  Silky Socks
//
//  Created by Kevin Koeller on 4/19/15.
//  Copyright (c) 2015 Full Stak. All rights reserved.
//

import UIKit

extension UIView {
    
    func pinSubviewToView(#subView: UIView) {
        
        addAttributeToView(NSLayoutAttribute.Top, subview: subView)
        addAttributeToView(NSLayoutAttribute.Leading, subview: subView)
        addAttributeToView(NSLayoutAttribute.Bottom, subview: subView)
        addAttributeToView(NSLayoutAttribute.Trailing, subview: subView)
        
        self.setNeedsUpdateConstraints()
    }
    
    private func addAttributeToView(attribute: NSLayoutAttribute, subview: UIView) {
        self.addConstraint(NSLayoutConstraint(item: self, attribute: attribute, relatedBy: NSLayoutRelation.Equal, toItem: subview, attribute: attribute, multiplier: 1.0, constant: 0))
    }
    
    
    func logSubViews() {
        println(self)
        for view in subviews as! [UIView]{
            view.logSubViews()
        }
    }
}

extension UIColor {
    
    class func getColor(#red: Int, green: Int, blue: Int, alpha: CGFloat) -> UIColor {
        let divisor: CGFloat = 255
        return UIColor(red: CGFloat(red)/divisor, green: CGFloat(green)/divisor, blue: CGFloat(blue)/divisor, alpha: alpha)
    }
    
    class func getColorPalette() -> [UIColor] {
        
        var array = [UIColor]()
        
        for var i = 0; i < 6; ++i {
            array.append(UIColor.getColor(red: i*51, green: i*51, blue: i*51, alpha: 1))
        }
        
        for var i = 0; i < 7; ++i {
            array.append(UIColor.getColor(red: 255, green: i*34, blue: 0, alpha: 1))
        }
        
        for var i = 7; i >= 0; --i {
            array.append(UIColor.getColor(red: 34*i, green: 255, blue: 0, alpha: 1))
        }
        
        for var i = 1; i < 8; ++i {
            array.append(UIColor.getColor(red: 0, green: 255, blue: i*34, alpha: 1))
        }
        
        for var i = 7; i >= 0; --i {
            array.append(UIColor.getColor(red: 0, green: i*34, blue: 255, alpha: 1))
        }
        
        for var i = 1; i < 7; ++i {
            array.append(UIColor.getColor(red: i*34, green: 0, blue: 255, alpha: 1))
        }
        
        return array
    }
}

extension UIImage {
    
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
    
    func colorizeWith(color: UIColor) -> UIImage {
        
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        color.setFill()
        CGContextTranslateCTM(context, 0, size.height)
        CGContextScaleCTM(context, 1, -1)
        
        // set the blend mode to color burn, and the original image
        CGContextSetBlendMode(context, kCGBlendModeDarken);
        let rect = CGRectMake(0, 0, size.width, size.height);
        CGContextDrawImage(context, rect, CGImage);
        
        // set a mask that matches the shape of the image, then draw a colored rectangle
        CGContextClipToMask(context, rect, CGImage);
        CGContextAddRect(context, rect);
        CGContextDrawPath(context,kCGPathFill);
        
        // generate a new UIImage from the graphics context we drew onto
        let coloredImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        //return the colored image
        return coloredImage;
    }
    
    func imageTintedWithColor(color: UIColor) -> UIImage {
    
        // Construct new image the same size as this one.
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0);
        
        var rect = CGRectZero
        rect.size = self.size
        
        // tint the image
        drawInRect(rect)
        color.set()
        UIRectFillUsingBlendMode(rect, kCGBlendModeDarken)
        
        // restore alpha channel
        drawInRect(rect, blendMode: kCGBlendModeDestinationIn, alpha: 1.0)
        
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return image;
        
    }
    
    func drawImage(overlayImage: UIImage) -> UIImage {
        
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        CGContextTranslateCTM(context, 0, size.height)
        CGContextScaleCTM(context, 1, -1)

        // set the blend mode to color burn, and the original image
        CGContextSetBlendMode(context, kCGBlendModeMultiply);
        let rect = CGRectMake(0, 0, size.width, size.height);
        CGContextDrawImage(context, rect, CGImage);
        
        // set a mask that matches the shape of the image, then draw a colored rectangle
        CGContextClipToMask(context, rect, CGImage);
        CGContextDrawImage(context, rect, overlayImage.CGImage)
        
        // generate a new UIImage from the graphics context we drew onto
        let coloredImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        //return the colored image
        return coloredImage;
        
    }
    
}
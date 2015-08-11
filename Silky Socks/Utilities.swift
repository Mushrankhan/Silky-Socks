//
//  Utilities.swift
//  Silky Socks
//
//  Created by Saurabh Jain on 4/19/15.
//  Copyright (c) 2015 Saurabh Jain. All rights reserved.
//

import UIKit

// MARK: UIView
extension UIView {
    
    // Pin a subview to the edges of the superview
    func pinSubviewToView(subView subView: UIView) {
        
        if subView.superview == nil {
            addSubview(subView)
        }
        
        addAttributeToView(NSLayoutAttribute.Top, subview: subView)
        addAttributeToView(NSLayoutAttribute.Leading, subview: subView)
        addAttributeToView(NSLayoutAttribute.Bottom, subview: subView)
        addAttributeToView(NSLayoutAttribute.Trailing, subview: subView)
        
        setNeedsUpdateConstraints()
    }
    
    private func addAttributeToView(attribute: NSLayoutAttribute, subview: UIView) {
        addConstraint(NSLayoutConstraint(item: self, attribute: attribute, relatedBy: NSLayoutRelation.Equal, toItem: subview, attribute: attribute, multiplier: 1.0, constant: 0))
    }
    
    // Clicks a snapshot of the view
    func clickSnapShot(area: CGRect, withLogo logo: UIImage?) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(area.size, opaque, 0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        // Essential to get rid of the black screen
        // when saving to photos and opening it
        CGContextClearRect(context, area)
        
        // Render before flipping
        CGContextTranslateCTM(context, -area.origin.x, -area.origin.y);
        layer.renderInContext(context)
        
        // Flip
        CGContextTranslateCTM(context, 0, area.size.height)
        CGContextScaleCTM(context, 1, -1)
        
        // Draw
        if let logo = logo {
            let rect = CGRect(x: 0, y: 0, width: 60, height: 50)
            CGContextDrawImage(context, rect, logo.CGImage)
        }
        
        // New Image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    // Print the view heirarchy
    func logSubViews() {
        print(self)
        for view in subviews as [UIView]{
            view.logSubViews()
        }
    }
}

// MARK: UIColor
extension UIColor {
    
    // Helper Function
    class func getColor(red red: Int, green: Int, blue: Int, alpha: CGFloat) -> UIColor {
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

// MARK: UIFont
extension UIFont {
    
    // Get the fonts used in the app
    class func getFontPalette() -> [UIFont] {
        
        var array = [UIFont]()
        let size: CGFloat = UIFont.AppFontSize()
        
        array.append(UIFont(name: "Helvetica Neue", size: size)!)
        array.append(UIFont(name: "HelveticaNeue-CondensedBold", size: size)!)
        array.append(UIFont(name: "HelveticaNeue-Italic", size: size)!)
        array.append(UIFont(name: "HelveticaNeue-Light", size: size)!)
        array.append(UIFont(name: "HelveticaNeue-UltraLight", size: size)!)
        array.append(UIFont(name: "Futura-Medium", size: size)!)
        array.append(UIFont(name: "AmericanTypewriter", size: size)!)
        array.append(UIFont(name: "GillSans", size: size)!)
        array.append(UIFont(name: "Double Feature", size: size)!)
        array.append(UIFont(name: "Courier", size: size)!)
        array.append(UIFont(name: "Arial", size: size)!)
        array.append(UIFont(name: "AvenirNext-Regular", size: size)!)
        array.append(UIFont(name: "Verdana", size: size)!)
        array.append(UIFont(name: "Iron Maiden", size: size)!)
        array.append(UIFont(name: "Times New Roman", size: size)!)
        array.append(UIFont(name: "Copperplate", size: size)!)
        array.append(UIFont(name: "Walkway Black", size: size)!)
        array.append(UIFont(name: "College", size: size)!)
        
        return array
        
    }
    
    // Size of fonts
    class func AppFontSize() -> CGFloat {
        return 80
    }
    
    // Helper to print all font names
    class func printFontNames() {
        for family in UIFont.familyNames() {
            print("Font :\(family)")
            for name in UIFont.fontNamesForFamilyName(family as String) {
                print("  \(name)")
            }
        }
    }
    
}

// MARK: UIImage
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
    
    func renderImageIntoSize(size: CGSize) -> UIImage {
        var image: UIImage?
        autoreleasepool { () -> () in
            UIGraphicsBeginImageContextWithOptions(size, false, 0)
            let rect = CGRect(origin: .zeroPoint, size: size)
            CGContextClearRect(UIGraphicsGetCurrentContext(), rect)
            drawInRect(rect)
            let img = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            image = img
        }
        return image!
    }
    
    // Tint the image
    func colorizeWith(color: UIColor) -> UIImage {
        
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()

        // Flip
        CGContextTranslateCTM(context, 0, size.height)
        CGContextScaleCTM(context, 1, -1)
        
        // set the blend mode to color burn, and the original image
        CGContextSetBlendMode(context, CGBlendMode.Darken)
        let rect = CGRectMake(0, 0, size.width, size.height)
        CGContextDrawImage(context, rect, CGImage)
        
        // set a mask that matches the shape of the image, then draw a colored rectangle
        CGContextClipToMask(context, rect, CGImage)
        CGContextAddRect(context, rect)
        color.setFill()
        CGContextDrawPath(context,CGPathDrawingMode.Fill)
        
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
        CGContextSetBlendMode(context, CGBlendMode.Multiply)
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
    
    func drawTiledImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let rect = CGRect(origin: .zeroPoint, size: CGSize(width: 125, height: 125))
        CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0, rect.size.height)
        CGContextScaleCTM(UIGraphicsGetCurrentContext(), 1, -1)
        CGContextDrawTiledImage(UIGraphicsGetCurrentContext(), rect , CGImage)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    // Return the logo
    class func SilkySocksLogo() -> UIImage? {
        return UIImage(named: "logo_left_of_template")
    }
}

// MARK: String
extension String {
    func parseString() -> String {
        return stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
}


extension NSLayoutConstraint {
    class func applyAutoLayout(superview: UIView, target: UIView, index: Int?, top: Float?, left: Float?, right: Float?, bottom: Float?, height: Float?, width: Float?) {
        
        target.translatesAutoresizingMaskIntoConstraints = false
        if let index = index {
            superview.insertSubview(target, atIndex: index)
        } else {
            superview.addSubview(target)
        }
        var verticalFormat = "V:"
        if let top = top {
            verticalFormat += "|-(\(top))-"
        }
        verticalFormat += "[target"
        if let height = height {
            verticalFormat += "(\(height))"
        }
        verticalFormat += "]"
        if let bottom = bottom {
            verticalFormat += "-(\(bottom))-|"
        }
        let verticalConstrains = NSLayoutConstraint.constraintsWithVisualFormat(verticalFormat, options: [], metrics: nil, views: [ "target" : target ])
        superview.addConstraints(verticalConstrains)
        
        var horizonFormat = "H:"
        if let left = left {
            horizonFormat += "|-(\(left))-"
        }
        horizonFormat += "[target"
        if let width = width {
            horizonFormat += "(\(width))"
        }
        horizonFormat += "]"
        if let right = right {
            horizonFormat += "-(\(right))-|"
        }
        let horizonConstrains = NSLayoutConstraint.constraintsWithVisualFormat(horizonFormat, options: [], metrics: nil, views: [ "target" : target ])
        superview.addConstraints(horizonConstrains)
    }
}


private let DeviceList = [
    /* iPod 5 */          "iPod5,1": "iPod Touch 5",
    /* iPhone 4 */        "iPhone3,1": "iPhone 4", "iPhone3,2": "iPhone 4", "iPhone3,3": "iPhone 4",
    /* iPhone 4S */       "iPhone4,1": "iPhone 4S",
    /* iPhone 5 */        "iPhone5,1": "iPhone 5", "iPhone5,2": "iPhone 5",
    /* iPhone 5C */       "iPhone5,3": "iPhone 5C", "iPhone5,4": "iPhone 5C",
    /* iPhone 5S */       "iPhone6,1": "iPhone 5S", "iPhone6,2": "iPhone 5S",
    /* iPhone 6 */        "iPhone7,2": "iPhone 6",
    /* iPhone 6 Plus */   "iPhone7,1": "iPhone 6 Plus",
    /* iPad 2 */          "iPad2,1": "iPad 2", "iPad2,2": "iPad 2", "iPad2,3": "iPad 2", "iPad2,4": "iPad 2",
    /* iPad 3 */          "iPad3,1": "iPad 3", "iPad3,2": "iPad 3", "iPad3,3": "iPad 3",
    /* iPad 4 */          "iPad3,4": "iPad 4", "iPad3,5": "iPad 4", "iPad3,6": "iPad 4",
    /* iPad Air */        "iPad4,1": "iPad Air", "iPad4,2": "iPad Air", "iPad4,3": "iPad Air",
    /* iPad Air 2 */      "iPad5,1": "iPad Air 2", "iPad5,3": "iPad Air 2", "iPad5,4": "iPad Air 2",
    /* iPad Mini */       "iPad2,5": "iPad Mini", "iPad2,6": "iPad Mini", "iPad2,7": "iPad Mini",
    /* iPad Mini 2 */     "iPad4,4": "iPad Mini", "iPad4,5": "iPad Mini", "iPad4,6": "iPad Mini",
    /* iPad Mini 3 */     "iPad4,7": "iPad Mini", "iPad4,8": "iPad Mini", "iPad4,9": "iPad Mini",
    /* Simulator */       "x86_64": "Simulator", "i386": "Simulator"
]

extension UIDevice {
    
    var modelName: String {

        var systemInfo = utsname()
        uname(&systemInfo)
        
        let machine = systemInfo.machine
        let mirror =  Mirror(reflecting: machine)
        var identifier = ""
        
         for child in mirror.children where child.value as? Int8 != 0 {
             identifier.append(UnicodeScalar(UInt8(child.value as! Int8)))
         }
        return DeviceList[identifier] ?? identifier
    }
}

/*!
    @abstract: Performs block after certain time on the main thread
    @param: time
    @param: () -> ()
*/
func delay(time: Double, block : () -> ()) {
    let after = dispatch_time(DISPATCH_TIME_NOW, Int64(time * Double(NSEC_PER_SEC)))
    dispatch_after(after, dispatch_get_main_queue(), block)
}
    
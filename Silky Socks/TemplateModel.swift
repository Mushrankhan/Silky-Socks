//
//  TemplateModel.swift
//  
//
//  Created by Saurabh Jain on 4/19/15.

import UIKit

/*!
    @enum       Template Type
    @abstract   Info contained in the template class regarding the type of the template

    @constant   Socks
    @constant   Shirt
    @constant   Tank
*/
enum TemplateType {
    case Socks
    case Shirt
    case Tank
}

/*!
    @class      Template
    @abstract   Represnt a way to encapsulate the image templates used in the app
*/
class Template: NSObject {
    
    // MARK: - Properties
    
    var image: UIImage          // Product Image
    var maskImage: UIImage?     // Mask Image
    var type: TemplateType      // Type
    var index: Int              // Order of products
    
    var prices: [NSDecimalNumber]   // Price of product
    var productId: String           // Product Id: The Id as on Shopify

    var productSize: CGSize     // Size in which to be printed
    
    // For the Info Page
    var infoCaption: String
    var info: String
    var infoImage: UIImage?
    
    
    
    // MARK: - Init
    
    init(image: UIImage, type: TemplateType, maskImage: UIImage?, infoCaption: String, info: String, infoImage: UIImage?, price: [NSDecimalNumber], productId: String, productSize: CGSize, index: Int) {
        
        self.image = image
        self.type = type
        self.maskImage = maskImage
        self.infoCaption = infoCaption
        self.info = info
        self.infoImage = infoImage
        self.prices = price
        self.productId = productId
        self.productSize = productSize
        self.index = index
    }
    
    override var description: String {
        return "Caption: \(infoCaption)\n" + "Info : \(info)\n"
    }
    
    // Return the template objects in an array
    class func allTemplates() -> [Template] {
        
        typealias Img = UIImage
        
        let IS_IPHONE = (UIDevice.currentDevice().userInterfaceIdiom == .Phone) ? true : false
        let SCREEN_WIDTH = UIScreen.mainScreen().bounds.size.width
        let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.size.height
        let SCREEN_MAX_LENGTH = max(SCREEN_HEIGHT, SCREEN_WIDTH)
        let IS_IPHONE_6P = (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
                
        let scale = UIScreen.mainScreen().scale
        let inch: CGFloat = IS_IPHONE_6P ? 401 : 326
        let calculations = floor(inch / scale)
        
        let sock = Template(image: Img(named: "socks")!, type: .Socks, maskImage: nil, infoCaption: "Streetwear Fullprint Socks", info: "This style has a Polyester, Rubber and Spandex Blend with breath-ability and superb all over print. Along with a thick ribbing for a secure, comfort fit. Quality Guaranteed!", infoImage: Img(named: "WhiteSocksProduct")!, price: [18.00, 14.00, 12.00], productId: "1334414273", productSize: CGSize(width: 10 * calculations, height: 20 * calculations), index: 0)
        
        let blackSock = Template(image: Img(named: "blackfootnew")!, type: .Socks, maskImage: Img(named: "blackfootnew_noblack"), infoCaption: "Athletic Black Foot Socks", info: "This style has a Solid Cotton foot for ultimate comfort + a Polyester, Rubber and Spandex Blend. The Leg holds the incredibly vibrant print. The foot carries extra padding and cushion for increased support along with thick ribbing for a secure, tight fit. Quality Guaranteed!", infoImage: Img(named: "BlackFootProduct")!, price: [18, 14, 12], productId: "1359200001", productSize: CGSize(width: 10 * calculations, height: 9 * calculations), index: 1)
        
        let kneeHigh = Template(image: Img(named: "kneehigh")!, type: .Socks, maskImage: Img(named: "kneehigh_noblack"), infoCaption: "Knee-high Compression Socks", info: "This style has a Solid Cotton foot for ultimate comfort + Polyester, Rubber and Spandex Blend. The Leg holds the print and goes all the way up the leg, just below the kneecap. The foot carries extra padding and cushion for increased support along with thick ribbing for a secure, tight fit. Quality Guaranteed!", infoImage: Img(named: "KneeHighProduct")!, price: [20, 16, 14], productId: "1371709761", productSize: CGSize(width: 11 * calculations, height: 16 * calculations), index: 2)

        let white_tee = Template(image: Img(named: "white_tee")!, type: .Shirt, maskImage: Img(named: "white_nocollar"), infoCaption: "T-shirt", info: "This is a full front dye sublimation print on a premium 4.5 oz. 100% polyester moisture management t-shirt. A fashion fit t-shirt with a ribbed collar with a Double-needle hem sleeves and bottom for a great fit.", infoImage: Img(named: "WhiteTeeProduct")!, price: [28, 20, 14], productId: "1371733057", productSize: CGSize(width: 41.3 * calculations, height: 33.3 * calculations), index: 3)

        let tank = Template(image: Img(named: "tank")!, type: .Tank, maskImage: Img(named: "tank_nocollar"), infoCaption: "Tank Top", info: "An American Apparel high quality tank with full front Sublimation print. Perfect for making one-of-a-kind designs with an ultra-soft-to-the-touch feel. 100% Polyester Jersey construction, Fashion fitted.  Back side will be white.", infoImage: Img(named: "TankProduct")!, price: [28, 23, 19], productId: "1371751809", productSize: CGSize(width: 24.4 * calculations, height: 36.7 * calculations), index: 4)
        
        let black_tee = Template(image: Img(named: "black_sleeve")!, type: .Shirt, maskImage: Img(named: "black_sleeve_nocollar"), infoCaption: "Blackout T-shirt", info: "This is a black sleeves and black back shirt, with a full front body dye sublimation print. A premium 4.5 oz. 100% polyester moisture management t-shirt with a fashion fit, ribbed collar, and double-needle hem sleeves and bottom for a great fit.", infoImage: Img(named: "BlackTeeProduct")!, price: [29, 24, 20], productId: "1371773057", productSize: CGSize(width: 23 * inch / scale, height: 31 * inch / scale), index: 5)
        
        return [sock, blackSock, kneeHigh, white_tee, tank, black_tee]
        
    }
}
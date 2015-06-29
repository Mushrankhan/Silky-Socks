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
class Template: NSObject, Printable {
    
    // MARK: - Properties
    
    // For the main screen
    var image: UIImage
    var maskImage: UIImage?
    var type: TemplateType
    
    // For the Info Page
    var infoCaption: String
    var info: String
    var infoImage: UIImage?
    
    var prices: [Float] // Price of product
    var productId: String // Product Id: The Id as on Shopify
    
    
    /*  The size needed to print the t-shirt in right dimensions
        If we clicked add to cart
        then draw the image in a rect of 36 x 32 inches
        1 inch = 72 points
        Dividing by scale is essential in order to get the right dimensions */
    var productSize = CGSize(width: 2592.0 / UIScreen.mainScreen().scale, height: 2304.0 / UIScreen.mainScreen().scale)
    
    
    // MARK: - Init
    
    init(image: UIImage, type: TemplateType, maskImage: UIImage?, infoCaption: String, info: String, infoImage: UIImage?, price: [Float], productId: String) {
        
        self.image = image
        self.type = type
        self.maskImage = maskImage
        self.infoCaption = infoCaption
        self.info = info
        self.infoImage = infoImage
        self.prices = price
        self.productId = productId
    }

    // MARK: - Printable
    
    override var description: String {
        get {
            let str = "Caption: \(infoCaption)\n" + "Info : \(info)\n"
            return str
        }
    }
    
    // Return the template objects in an array
    class func allTemplates() -> [Template] {
        
        typealias Img = UIImage
        
        let sock = Template(image: Img(named: "socks")!, type: .Socks, maskImage: nil, infoCaption: "Streetwear Fullprint Socks", info: "This style has a Polyester, Rubber and Spandex Blend with breath-ability and superb all over print. Along with a thick ribbing for a secure, comfort fit. Quality Guaranteed!", infoImage: Img(named: "WhiteSocksProduct")!, price: [18, 14, 12], productId: "1334414273")
        
        let blackSock = Template(image: Img(named: "blackfootnew")!, type: .Socks, maskImage: Img(named: "blackfootnew_noblack"), infoCaption: "Athletic Black Foot Socks", info: "This style has a Solid Cotton foot for ultimate comfort + a Polyester, Rubber and Spandex Blend. The Leg holds the incredibly vibrant print. The foot carries extra padding and cushion for increased support along with thick ribbing for a secure, tight fit. Quality Guaranteed!", infoImage: Img(named: "BlackFootProduct")!, price: [18, 14, 12], productId: "1359200001")
        
        let kneeHigh = Template(image: Img(named: "kneehigh")!, type: .Socks, maskImage: Img(named: "kneehigh_noblack"), infoCaption: "Knee-high Compression Socks", info: "This style has a Solid Cotton foot for ultimate comfort + Polyester, Rubber and Spandex Blend. The Leg holds the print and goes all the way up the leg, just below the kneecap. The foot carries extra padding and cushion for increased support along with thick ribbing for a secure, tight fit. Quality Guaranteed!", infoImage: Img(named: "KneeHighProduct")!, price: [20, 16, 14], productId: "1371709761")

        let white_tee = Template(image: Img(named: "white_tee")!, type: .Shirt, maskImage: Img(named: "white_nocollar"), infoCaption: "T-shirt", info: "This is a full front dye sublimation print on a premium 4.5 oz. 100% polyester moisture management t-shirt. A fashion fit t-shirt with a ribbed collar with a Double-needle hem sleeves and bottom for a great fit.", infoImage: Img(named: "WhiteTeeProduct")!, price: [28, 20, 14], productId: "1371733057")
        
        let tank = Template(image: Img(named: "tank")!, type: .Tank, maskImage: Img(named: "tank_nocollar"), infoCaption: "Tank Top", info: "An American Apparel high quality tank with full front Sublimation print. Perfect for making one-of-a-kind designs with an ultra-soft-to-the-touch feel. 100% Polyester Jersey construction, Fashion fitted.  Back side will be white.", infoImage: Img(named: "TankProduct")!, price: [28, 23, 19], productId: "1371751809")
        
        let black_tee = Template(image: Img(named: "black_sleeve")!, type: .Shirt, maskImage: Img(named: "black_sleeve_nocollar"), infoCaption: "Blackout T-shirt", info: "This is a black sleeves and black back shirt, with a full front body dye sublimation print. A premium 4.5 oz. 100% polyester moisture management t-shirt with a fashion fit, ribbed collar, and double-needle hem sleeves and bottom for a great fit.", infoImage: Img(named: "BlackTeeProduct")!, price: [29, 24, 20], productId: "1371773057")
        
        return [sock, blackSock, kneeHigh, white_tee, tank, black_tee]
        
    }
}
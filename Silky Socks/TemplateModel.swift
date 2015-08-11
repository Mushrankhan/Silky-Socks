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

    var productSize: CGSize         // Size in which to be printed
    var availabilitySizes: [String] // Sizes in which printing can happen
    
    // For the Info Page
    var infoCaption: String
    var info: String
    var infoImage: UIImage?
    
    
    // MARK: - Init
    
    init(image: UIImage, type: TemplateType, maskImage: UIImage?, infoCaption: String, info: String, infoImage: UIImage?, price: [NSDecimalNumber], productId: String, productSize: CGSize, index: Int, availabilitySizes: [String]) {
        
        self.image = image
        self.type = type
        self.maskImage = maskImage
        self.infoCaption = infoCaption
        self.info = info
        self.infoImage = infoImage
        self.prices = price
        self.productId = productId
        self.productSize = productSize
        self.availabilitySizes = availabilitySizes
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
        
        let sock = Template(image: Img(named: "socks")!, type: .Socks, maskImage: nil, infoCaption: "Streetwear Fullprint Socks", info: "This style has soft Polyester, Rubber and Spandex Blend with breathability and superb all over print.  Along with a thick ribbing for a secure, comfort fit. Quality Guaranteed!", infoImage: Img(named: "WhiteSocksProduct")!, price: [17, 14, 12], productId: "1334414273", productSize: CGSize(width: 10 * calculations, height: 20 * calculations), index: 0, availabilitySizes: ["S", "M", "L", "XL"])
        
        let blackSock = Template(image: Img(named: "blackfootnew")!, type: .Socks, maskImage: Img(named: "blackfootnew_noblack"), infoCaption: "Athletic Black Foot Socks", info: "This style has a Solid Cotton foot for ultimate comfort + a Polyester, Rubber and Spandex Blend.  The Leg holds the incredibly vibrant print. The foot carries extra padding and CUSHION for increased support along with thick ribbing for a secure, tight fit. Quality Guaranteed!", infoImage: Img(named: "BlackFootProduct")!, price: [15, 14, 12], productId: "1359200001", productSize: CGSize(width: 10 * calculations, height: 9 * calculations), index: 1, availabilitySizes: ["S", "M", "L", "XL"])
        
        let kneeHigh = Template(image: Img(named: "kneehigh")!, type: .Socks, maskImage: Img(named: "kneehigh_noblack"), infoCaption: "Knee-high Compression Socks", info: "This style has a Solid Cotton foot for ultimate comfort + Polyester, Rubber and Spandex Blend.  The Leg holds the print and goes all the way up the leg, just below the kneecap. The foot carries extra padding and CUSHION for increased support along with thick ribbing for a secure, tight fit. Quality Guaranteed!", infoImage: Img(named: "KneeHighProduct")!, price: [18, 16, 14], productId: "1371709761", productSize: CGSize(width: 11 * calculations, height: 15 * calculations), index: 2, availabilitySizes: ["S", "M", "L", "XL"])

        let white_tee = Template(image: Img(named: "white_tee")!, type: .Shirt, maskImage: Img(named: "white_tee_noneck"), infoCaption: "T-shirt", info: "This is a full front dye sublimation print on a premium American Apparel 4.5 oz. 100% polyester moisture management t-shirt.  A trusted fashion fit t-shirt with ribbed collar, Double-needle hem sleeves and bottom for a great fit.", infoImage: Img(named: "WhiteTeeProduct")!, price: [28, 20, 14], productId: "1371733057", productSize: CGSize(width: 20.65 * calculations, height: 16.3 * calculations), index: 3, availabilitySizes: ["S", "M", "L", "XL", "XXL"])

        let tank = Template(image: Img(named: "tank")!, type: .Tank, maskImage: Img(named: "tank_cut"), infoCaption: "Tank Top", info: "An American Apparel high quality tank with full front Sublimation print.  Perfect for making one-of-a-kind designs with an ultra-soft-to-the-touch feel. 100% Polyester Jersey construction, fashion fitted.  The back side will be white.", infoImage: Img(named: "TankProduct")!, price: [28, 23, 19], productId: "1371751809", productSize: CGSize(width: 12.2 * calculations, height: 18.3 * calculations), index: 4, availabilitySizes: ["S", "M", "L", "XL"])
        
        let black_tee = Template(image: Img(named: "black_sleeve")!, type: .Shirt, maskImage: Img(named: "black_sleeve_nocollar"), infoCaption: "Blackout T-shirt", info: "This shirt has is a black sleeves, black collar, and black back with a front body dye sublimation print.  A premium 4.5 oz. 100% polyester moisture management t-shirt with a fashion fit, ribbed collar, double-needle hem sleeves and bottom for a great fit.", infoImage: Img(named: "BlackTeeProduct")!, price: [26, 24, 20], productId: "1371773057", productSize: CGSize(width: 11.5 * inch / scale, height: 15.5 * inch / scale), index: 5, availabilitySizes: ["S", "M", "L", "XL", "XXL"])
        
        return [sock, blackSock, kneeHigh, white_tee, tank, black_tee]
        
    }
}
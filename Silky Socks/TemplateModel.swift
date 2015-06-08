//
//  TemplateModel.swift
//  
//
//  Created by Kevin Koeller on 4/19/15.

import UIKit

enum Type {
    case Socks
    case Shirt
    case Tank
}

class Template: NSObject, Printable {
    
    // For the main screen
    var image: UIImage
    var maskImage: UIImage?
    var caption: String
    var type: Type
    
    // For the Info Page
    var infoCaption: String
    var info: String
    var infoImage: UIImage?
    
    init(image: UIImage, caption: String, type: Type, maskImage: UIImage?, infoCaption: String, info: String, infoImage: UIImage?) {
        self.image = image
        self.caption = caption
        self.type = type
        self.maskImage = maskImage
        
        self.infoCaption = infoCaption
        self.info = info
        self.infoImage = infoImage
    }

    override var description: String {
        get {
            let str = "Caption: \(caption)\n" + "Info : \(info)\n"
            return str
        }
    }
    
    // Return the template objects in an array
    class func allTemplates() -> [Template] {
        
        typealias Img = UIImage
        
        let sock = Template(image: Img(named: "blank")!, caption: "", type: .Socks, maskImage: nil, infoCaption: "Streetwear Fullprint Socks", info: "This style has a Polyester, Rubber and Spandex Blend with breath-ability and superb all over print. Along with a thick ribbing for a secure, comfort fit. Quality Guaranteed!", infoImage: Img(named: "WhiteSocksProduct")!)
        
        let blackSock = Template(image: Img(named: "blackfootnew")!, caption: "Black Foot", type: .Socks, maskImage: Img(named: "blackfootnew_noblack"), infoCaption: "Athletic Black Foot Socks", info: "This style has a Solid Cotton foot for ultimate comfort + a Polyester, Rubber and Spandex Blend. The Leg holds the incredibly vibrant print. The foot carries extra padding and cushion for increased support along with thick ribbing for a secure, tight fit. Quality Guaranteed!", infoImage: Img(named: "BlackFootProduct")!)
        
        let kneeHigh = Template(image: Img(named: "kneehigh")!, caption: "Knee High Black Foot", type: .Socks, maskImage: Img(named: "kneehigh_noblack"), infoCaption: "Knee-high Compression Socks", info: "This style has a Solid Cotton foot for ultimate comfort + Polyester, Rubber and Spandex Blend. The Leg holds the print and goes all the way up the leg, just below the kneecap. The foot carries extra padding and cushion for increased support along with thick ribbing for a secure, tight fit. Quality Guaranteed!", infoImage: Img(named: "KneeHighProduct")!)

        let white_tee = Template(image: Img(named: "white_tee")!,caption: "White Tee", type: .Shirt, maskImage: Img(named: "white_nocollar"), infoCaption: "T-shirt", info: "This is a full front dye sublimation print on a premium 4.5 oz. 100% polyester moisture management t-shirt. A fashion fit t-shirt with a ribbed collar with a Double-needle hem sleeves and bottom for a great fit.", infoImage: Img(named: "WhiteTeeProduct")!)
        
        let tank = Template(image: Img(named: "tank")!,caption: "Tank", type: .Tank, maskImage: Img(named: "tank_nocollar"), infoCaption: "Tank Top", info: "An American Apparel high quality tank with full front Sublimation print. Perfect for making one-of-a-kind designs with an ultra-soft-to-the-touch feel. 100% Polyester Jersey construction, Fashion fitted.  Back side will be white.", infoImage: Img(named: "TankProduct")!)
        
        let black_tee = Template(image: Img(named: "black_sleeve")!,caption: "Black Sleeve Tee", type: .Shirt, maskImage: Img(named: "black_sleeve_nocollar"), infoCaption: "Blackout T-shirt", info: "This is a black sleeves and black back shirt, with a full front body dye sublimation print. A premium 4.5 oz. 100% polyester moisture management t-shirt with a fashion fit, ribbed collar, and double-needle hem sleeves and bottom for a great fit.", infoImage: Img(named: "BlackTeeProduct")!)
        
        return [sock, blackSock, kneeHigh, white_tee, tank, black_tee]
        
    }
}
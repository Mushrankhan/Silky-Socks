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

class Template {
    
    var image: UIImage
    var maskImage: UIImage?
    var caption: String
    var type: Type
    
    init(image: UIImage, caption: String, type: Type, maskImage: UIImage?) {
        self.image = image
        self.caption = caption
        self.type = type
        self.maskImage = maskImage
    }
    
    // Return the template objects in an array
    class func allTemplates() -> [Template] {
        
        typealias Img = UIImage
        
        return [
            Template(image: Img(named: "blank")!,caption: "", type: .Socks, maskImage: nil),
            Template(image: Img(named: "blackfootnew")!,caption: "Black Foot", type: .Socks, maskImage: Img(named: "blackfootnew_noblack")),
            Template(image: Img(named: "kneehigh")!,caption: "Knee High Black Foot", type: .Socks, maskImage: Img(named: "kneehigh_noblack")),
            Template(image: Img(named: "white_tee")!,caption: "White Tee", type: .Shirt, maskImage: Img(named: "white_nocollar")),
            Template(image: Img(named: "tank")!,caption: "Tank", type: .Tank, maskImage: Img(named: "tank_nocollar")),
            Template(image: Img(named: "black_sleeve")!,caption: "Black Sleeve Tee", type: .Shirt, maskImage: Img(named: "black_sleeve_nocollar")),
            Template(image: Img(named: "new_shirt_temp")!, caption: "", type: .Shirt, maskImage: nil)
        ]
    }
}
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
        return [
            Template(image: UIImage(named: "blank")!,caption: "", type: .Socks, maskImage: nil),
            Template(image: UIImage(named: "blackfoot")!,caption: "Black Foot", type: .Socks, maskImage: nil),
            Template(image: UIImage(named: "kneehigh")!,caption: "Knee High Black Foot", type: .Socks, maskImage: nil),
            Template(image: UIImage(named: "white_tee")!,caption: "White Tee", type: .Shirt, maskImage: UIImage(named: "white_nocollar")),
            Template(image: UIImage(named: "tank")!,caption: "Tank", type: .Tank, maskImage: UIImage(named: "tank_nocollar")),
            Template(image: UIImage(named: "black_sleeve_template")!,caption: "Black Sleeve Tee", type: .Shirt, maskImage: nil),
            Template(image: UIImage(named: "new_shirt_temp")!, caption: "", type: .Shirt, maskImage: nil)
        ]
    }
}
//
//  TemplateModel.swift
//  
//
//  Created by Kevin Koeller on 4/19/15.
//
//

import UIKit

class Template {
    
    // Image
    var image: UIImage
    var caption: String
    
    init(image: UIImage, caption: String) {
        self.image = image
        self.caption = caption
    }
    
    // Return the template objects in an array
    class func allTemplates() -> [Template] {
        return [Template(image: UIImage(named: "blank")!,caption: ""),
                Template(image: UIImage(named: "blackfoot_template")!,caption: "Black Foot"),
                Template(image: UIImage(named: "BlackfootHigh_template")!,caption: "Knee High Black Foot"),
                Template(image: UIImage(named: "white tee")!,caption: "White Tee"),
                Template(image: UIImage(named: "tank")!,caption: "Tank"),
                Template(image: UIImage(named: "black_sleeve_template")!,caption: "Black Sleeve Tee")]
    }
}
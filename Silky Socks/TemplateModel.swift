//
//  TemplateModel.swift
//  
//
//  Created by Kevin Koeller on 4/19/15.
//
//

import UIKit

class Template {
    
    // The Image template
    var image: UIImage
    
    init(image: UIImage) {
        self.image = image
    }

    class func allTemplates() -> [Template] {
        return [Template(image: UIImage(named: "blank")!), Template(image: UIImage(named: "blackfoot_template")!), Template(image: UIImage(named: "BlackfootHigh_template")!),Template(image: UIImage(named: "white tee")!),Template(image: UIImage(named: "tank")!),Template(image: UIImage(named: "black_sleeve_template")!)]
    }
}
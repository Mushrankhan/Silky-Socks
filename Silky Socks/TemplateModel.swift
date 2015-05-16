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
        return [Template(image: UIImage(named: "socks")!), Template(image: UIImage(named: "socksnext")!), Template(image: UIImage(named: "blank")!)]
    }
}
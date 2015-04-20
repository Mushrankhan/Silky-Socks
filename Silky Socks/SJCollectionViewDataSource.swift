//
//  SJCollectionViewDataSource.swift
//  Silky Socks
//
//  Created by Kevin Koeller on 4/19/15.
//  Copyright (c) 2015 Full Stak. All rights reserved.
//

import Foundation
import UIKit

class SJCollectionViewDataSource {
    
    var templatesArray: [Template] = []
    
    init() {
        templatesArray = loadImagesFromDisk()
    }
    
    private func loadImagesFromDisk() -> [Template] {

        return [Template(image: UIImage(named: "socks")!), Template(image: UIImage(named: "socksnext")!), Template(image: UIImage(named: "blank")!)]
    }

    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfItemsInSection(section: Int) -> Int {
        return templatesArray.count
    }
    
    func imageForRowAtIndexPath(indexPath: NSIndexPath) -> UIImage? {
        return templatesArray[indexPath.row].image
    }
}
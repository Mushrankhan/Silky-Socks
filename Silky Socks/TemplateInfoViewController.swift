//
//  TemplateInfoViewController.swift
//  Silky Socks
//
//  Created by Saurabh Jain on 6/9/15.
//  Copyright (c) 2015 Full Stak. All rights reserved.
//

import UIKit

class TemplateInfoViewController: UIViewController {

    // IBOutlets
    @IBOutlet weak var infoImageView: UIImageView!
    @IBOutlet weak var infoDescription: UILabel!
    
    var template: Template!

    private struct Nib {
        static let Name = "TemplateInfoViewController"
    }
    
    class func NibName() -> String {
        return Nib.Name
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let attrString = NSMutableAttributedString(string: template.infoCaption + ": " + template.info)
        let range = NSMakeRange(0, count(template.infoCaption) + 1)
        attrString.addAttributes([NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)], range: range)
        
        infoImageView!.image = template.infoImage
        infoDescription!.attributedText = attrString
        
        let leftBarButton = UIBarButtonItem(image: UIImage(named: "Back Arrow"), style: .Done, target: self, action: "dismiss")
        leftBarButton.tintColor = UIColor.blackColor()
        navigationItem.leftBarButtonItem = leftBarButton
        
        title = template.infoCaption
    }
    
    @objc private func dismiss() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

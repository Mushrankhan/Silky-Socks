//
//  SJApprovalViewController.swift
//  Silky Socks
//
//  Created by Saurabh Jain on 6/4/15.
//  Copyright (c) 2015 Full Stak. All rights reserved.
//

import UIKit

protocol SJApprovalViewControllerDelegate: class {
    
    func approvalView(viewController: SJApprovalViewController, didPressXButton button: UIButton)
    func approvalView(viewController: SJApprovalViewController, didPressCheckButton button: UIButton)
}

class SJApprovalViewController: UIViewController {

    weak var delegate: SJApprovalViewControllerDelegate?
    
    var buttonPressedTag: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // IBAction
    @IBAction func approvalButtonPressed(sender: UIButton) {
        
        switch sender.tag {
        case 1:
            delegate?.approvalView(self, didPressXButton: sender)
        case 2:
            delegate?.approvalView(self, didPressCheckButton: sender)
        default:
            break
        }
    }

}

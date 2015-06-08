//
//  SJApprovalViewController.swift
//  Silky Socks
//
//  Created by Saurabh Jain on 6/4/15.
//  Copyright (c) 2015 Full Stak. All rights reserved.
//

import UIKit

protocol SJApprovalViewControllerDelegate: class {
    
    func approvalView(viewController: SJApprovalViewController, didPressXButton button: UIButton, forView view: UIView?, withTag tag: Int?)
    func approvalView(viewController: SJApprovalViewController, didPressCheckButton button: UIButton, forView view: UIView?, withTag tag: Int?)
}

class SJApprovalViewController: UIViewController {

    weak var delegate: SJApprovalViewControllerDelegate?
    
    var buttonPressedTag: Int?
    var approvalViewForView: UIView?
    
    // IBAction
    @IBAction func approvalButtonPressed(sender: UIButton) {
        
        switch sender.tag {
        case 1:
            delegate?.approvalView(self, didPressXButton: sender, forView: approvalViewForView, withTag: buttonPressedTag)
        case 2:
            delegate?.approvalView(self, didPressCheckButton: sender, forView: approvalViewForView, withTag: buttonPressedTag)
        default:
            break
        }
    }

}

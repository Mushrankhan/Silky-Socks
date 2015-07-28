//
//  SJApprovalViewController.swift
//  Silky Socks
//
//  Created by Saurabh Jain on 6/4/15.
//  Copyright (c) 2015 Saurabh Jain. All rights reserved.
//

import UIKit

let kSJApprovalViewControllerDidShow = "kSJApprovalViewControllerDidShow"
let kSJApprovalViewControllerDidHide = "kSJApprovalViewControllerDidHide"

protocol SJApprovalViewControllerDelegate: class {
    
    func approvalView(viewController: SJApprovalViewController, didPressXButton button: UIButton, forView view: UIView?, withTag tag: Int?)
    func approvalView(viewController: SJApprovalViewController, didPressCheckButton button: UIButton, forView view: UIView?, withTag tag: Int?)
}

class SJApprovalViewController: UIViewController {

    // Delegate
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

    override func didMoveToParentViewController(parent: UIViewController?) {
        let name = parent != nil ? kSJApprovalViewControllerDidShow : kSJApprovalViewControllerDidHide
        NSNotificationCenter.defaultCenter().postNotificationName(name, object: nil)
        super.didMoveToParentViewController(parent)
    }
    
}

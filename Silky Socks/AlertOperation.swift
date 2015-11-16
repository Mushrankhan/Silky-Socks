//
//  AlertOperation.swift
//  Silky Socks
//
//  Created by Saurabh Jain on 8/3/15.
//  Copyright © 2015 Full Stak. All rights reserved.
//

// Adopted from the code from WWDC 2015 - Advance NSOperations

import UIKit

class AlertOperation: Operation {

    private let alert: UIAlertController!
    private let presentationController: UIViewController?
    var showSweetAlert = false
    
    init(title: String, message: String?) {
        alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        presentationController = UIApplication.sharedApplication().keyWindow?.rootViewController
    }
    
    func addAction(title: String?, style: UIAlertActionStyle = .Default, handler: (AlertOperation -> Void)? = nil) {
        let action = UIAlertAction(title: title, style: style) { [weak self] (action) in
            if let strong = self {
                handler?(strong)
            }
            self?.finish()
        }
        
        alert.addAction(action)
    }
    
    override func execute() {
        
        if showSweetAlert {
            dispatch_async(dispatch_get_main_queue()) {
                SweetAlert().showAlert("Network Error", subTitle: "Make sure that you are connected to the internet", style: .Error)
                self.finish()
            }
        } else {
            guard let vc = presentationController else {
                finish()
                return
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                if self.alert.actions.isEmpty {
                    self.addAction("Ok")
                }
                
                vc.presentViewController(self.alert, animated: true, completion: nil)
            }
        }
    }
}

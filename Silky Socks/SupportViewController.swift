//
//  SupportViewController.swift
//  Silky Socks
//
//  Created by Saurabh Jain on 7/22/15.
//  Copyright © 2015 Full Stak. All rights reserved.
//

import UIKit

class SupportViewController: UIViewController {

    // The path to the document
    var path: String?
    
    private lazy var width: CGFloat = {
        return CGRectGetWidth(UIScreen.mainScreen().bounds)
    }()
    
    private lazy var height: CGFloat = {
        return CGRectGetHeight(UIScreen.mainScreen().bounds)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIBarButtonItem(title: "Done", style: .Done, target: self, action: "done")
        navigationItem.rightBarButtonItem = button
        
        if let path = path {
            let frame = CGRect(origin: CGPointZero, size: CGSize(width: width, height: height))
            let webView = UIWebView(frame: frame)
            webView.scalesPageToFit = true
            view.addSubview(webView)
            view.pinSubviewToView(subView: webView)

            let url = NSURL(fileURLWithPath: NSBundle.mainBundle().bundlePath)
            let data = NSData(contentsOfFile: path)
            webView.loadData(data!, MIMEType: "application/pdf", textEncodingName: "utf-8", baseURL: url)
        }
    }
    
    @objc private func done() {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
}

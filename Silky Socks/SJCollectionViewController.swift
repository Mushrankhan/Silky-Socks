//
//  SJCollectionViewController.swift
//  Silky Socks
//
//  Created by Kevin Koeller on 4/19/15.
//  Copyright (c) 2015 Full Stak. All rights reserved.
//

import UIKit

class SJCollectionViewController: UIViewController {

    // the array containing templates
    private var templateArray = Template.allTemplates()
    
    // Cell Reuse identifier
    private let reuseIdentifier = "Cell"
    
    // Collection view
    @IBOutlet weak var collectionView: SJCollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting the Top Silcy Socks Logo
        let nav_barHeight = CGRectGetHeight(navigationController!.navigationBar.bounds)
        let img_view = UIImageView(image: UIImage(named: "topbar_logo"))
        img_view.frame = CGRectMake(0, 0, 150, nav_barHeight - 10)
        img_view.contentMode = .ScaleAspectFit
        navigationItem.titleView = img_view
        
        // Data Source
        collectionView!.dataSource = self
        collectionView!.myDelegate = self
        
        //collectionView!.backgroundColor = UIColor.yellowColor()
        collectionView!.backgroundColor = UIColor.whiteColor()
        
        // Enable paging
        collectionView!.pagingEnabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


// MARK: Collection View Data Source
extension SJCollectionViewController: SJCollectionViewDataSource {

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return templateArray.count
     }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! SJCollectionViewCell
        
        // Configure the cell
        cell.template = templateArray[indexPath.row]
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        let collView = collectionView as! SJCollectionView
        
        if kind == restartElementkind {
            return collView.dequeueReusableRestartView(indexPath: indexPath)
        } else if kind == shareElementKind {
            return collView.dequeueReusableShareView(indexPath: indexPath)
        } else if kind == addToCartElementKind {
            return collView.dequeueReusableAddToCartView(indexPath: indexPath)
        } else {
            return collView.dequeueReusableBottomUtilitiesView(indexPath: indexPath)
        }
    }
}

// MARK: Collection View Delegate
extension SJCollectionViewController: SJCollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, bottomView: UIView , didPressTextButton button:UIButton) {
        
        let collectionView = collectionView as! SJCollectionView
        let width = CGRectGetWidth(UIScreen.mainScreen().bounds)
        let midY = CGRectGetMidY(collectionView.bounds)
        let height: CGFloat = 60
        
        // Create an instance of Text Field
        let textField = SJTextField(frame: CGRect(x: collectionView.contentOffset.x, y: midY, width: width, height: 60))
        textField.delegate = self
        textField.becomeFirstResponder()
        collectionView.addSubview(textField)
        
        if let sj_bottomView = collectionView.sj_bottomView {
            sj_bottomView.userInteractionEnabled = false
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, bottomView: UIView, didPressCameraButton button: UIButton) {
        print("Camera")
    }
    
    func collectionView(collectionView: UICollectionView, bottomView: UIView , didPressColorWheelButton button:UIButton){
        print("Color")
    }
    
    func collectionView(collectionView: UICollectionView, bottomView: UIView , didPressGridButton button:UIButton) {
        print("Grid")
    }
    
    func collectionView(collectionView: UICollectionView, bottomView: UIView , didPressSmileyButton button:UIButton) {
        print("Smiley")
    }
}

// MARK: Text Field Delegate
// For Text Button Support
extension SJCollectionViewController: UITextFieldDelegate {
    
    // When Done button is pressed
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if count(textField.text) > 0 {
            if textField.canResignFirstResponder() {
                textField.resignFirstResponder()
                // Remove from superview
                textField.removeFromSuperview()
                // Create The label
                createTextLabel(textField.text, afont: textField.font)
                return true
            }
        } else {
            textField.resignFirstResponder()
            textField.removeFromSuperview()
            if let sj_bottomView = collectionView.sj_bottomView {
                sj_bottomView.userInteractionEnabled = true
            }
            return true
        }
        
        return false
    }
    
    // Create Text Label
    private func createTextLabel(text: String, afont: UIFont) {
        
        let font = UIFont(name: afont.fontName, size: afont.pointSize)
        // Should return only one cell, because one cell covers the entire area
        let cells = collectionView.visibleCells() as! [SJCollectionViewCell]
        if cells.count == 1 {
            cells.first!.createLabel(text, font: font!)
        }
    }
}







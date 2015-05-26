//
//  SJCollectionViewController.swift
//  Silky Socks
//
//  Created by Saurabh Jain on 4/19/15.
//  Copyright (c) 2015 Full Stak. All rights reserved.
//

import UIKit

class SJCollectionViewController: UIViewController {

    // the array containing templates
    lazy private var templateArray = Template.allTemplates()
    
    // Cell Reuse identifier
    private let reuseIdentifier = "Cell"
    
    // Collection view
    @IBOutlet weak var collectionView: SJCollectionView!
    
    // Image Picker Controller
    private var picker: UIImagePickerController!
    
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
        
        collectionView!.backgroundColor = UIColor.whiteColor()
        collectionView!.pagingEnabled = true
        
        // Create the image picker controller
        picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.mediaTypes = ["public.image"]
        picker.sourceType = .PhotoLibrary
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        templateArray = []
        picker = nil
    }
}


// MARK: Collection View Data Source
extension SJCollectionViewController: SJCollectionViewDataSource {

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return templateArray.count
     }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! SJCollectionViewCell
        cell.template = templateArray[indexPath.row]
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        let collView = collectionView as! SJCollectionView
        
        switch kind {
            case restartElementkind:
                return collView.dequeueReusableRestartView(indexPath: indexPath)
            case shareElementKind:
                return collView.dequeueReusableShareView(indexPath: indexPath)
            case addToCartElementKind:
                return collView.dequeueReusableAddToCartView(indexPath: indexPath)
            default:
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
        let frame = CGRect(x: collectionView.contentOffset.x, y: midY, width: width, height: height)
        let textField = SJTextField(frame: frame)
        textField.delegate = self
        textField.becomeFirstResponder()
        
        // Add Text Field to collection view
        collectionView.addSubview(textField)
        
    }
    
    func collectionView(collectionView: UICollectionView, bottomView: UIView, didPressCameraButton button: UIButton) {
        
        // Create On Demand
        let sheet = UIAlertController(title: "Import Photo", message: nil, preferredStyle: .ActionSheet)
        
        // Take photo
        sheet.addAction(UIAlertAction(title: "Take Photo", style: .Default) { action in
            if UIImagePickerController.isSourceTypeAvailable(.Camera) {
                self.picker.sourceType = .Camera
            }
            self.presentViewController(self.picker, animated: true, completion: nil)
        })
        
        // Choose Photo
        sheet.addAction(UIAlertAction(title: "Choose Photo", style: .Default) { action in
            if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
                self.picker.sourceType = .PhotoLibrary
            }
            self.presentViewController(self.picker, animated: true, completion: nil)
        })
        
        // Cancel
        sheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel) { action in
            self.dismissViewControllerAnimated(true, completion: nil)
        })
        
        presentViewController(sheet, animated: true, completion: nil)
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

// MARK: Text Button
extension SJCollectionViewController: UITextFieldDelegate {
    
    // When Done button is pressed
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if count(textField.text) > 0 {
            if textField.canResignFirstResponder() {
                textField.resignFirstResponder()
                textField.removeFromSuperview()
                // Create The label
                collectionView.sj_createTextLabel(textField.text, afont: textField.font)
                return true
            }
        }
        
        textField.resignFirstResponder()
        textField.removeFromSuperview()
        if let sj_bottomView = collectionView.sj_bottomView {
            sj_bottomView.userInteractionEnabled = true
        }
        return true
    }
}

// MARK: Camera Button
extension SJCollectionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        var image: UIImage!
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            image = editedImage
        } else {
            image = info[UIImagePickerControllerOriginalImage] as! UIImage
        }
        
        dismissViewControllerAnimated(true, completion: nil)
        
        // Pass the image object to the collection view
        collectionView.sj_createImage(image)
    }
}

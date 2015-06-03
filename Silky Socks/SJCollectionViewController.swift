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
    
    // Color Palette Collection View
    private var colorCollectionVC: SJColorCollectionViewController!
    
    // Keep Track of Color Palette
    private var showingText = false
    
    // The text field shown when the text button is pressed
    private var sj_textField: SJTextField?
    
    // Whether Camera button is clicked or grid button
    private var isGridButtonTapped = false
    
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
        
        // Create the image picker controller
        picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.mediaTypes = ["public.image"]
        picker.sourceType = .PhotoLibrary
        
        // Track changes in the keyboard
        // Used to display the color VC appropriately
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleKeyBoard:", name: UIKeyboardDidShowNotification, object: nil)
        
        // Set the layout for the colorVC
        let frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 50)
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: frame.size.height - 16, height: frame.size.height)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .Horizontal
        
        // Set up the color View
        // This VC is added as a child view controller
        colorCollectionVC = SJColorCollectionViewController(collectionViewLayout: layout)
        colorCollectionVC.collectionView!.frame = frame
        colorCollectionVC.collectionView!.hidden = true
        colorCollectionVC.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Doing this in view did appear
        // In view did load leads to frame issues
        collectionView.addSubview(colorCollectionVC.collectionView!)
        addChildViewController(colorCollectionVC)
        colorCollectionVC.didMoveToParentViewController(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Clear out the template array
        templateArray = []
        
        // Delete the picker
        picker = nil
    }
    
    // Dismiss the colorVC when a touch is witnessed
    func collectionView(collectionView: UICollectionView, touchesBegan touch: UITouch) {
        if !colorCollectionVC.collectionView!.hidden  {
            colorCollectionVC.collectionView!.hidden = true
        }
    }
}

// MARK: Keyboard Support
extension SJCollectionViewController {
    
    func handleKeyBoard(notification: NSNotification) {
        
        let end: CGRect = (notification.userInfo![UIKeyboardFrameEndUserInfoKey]!).CGRectValue()
        
        // if text button clicked
        // then display color VC on top of keyboard
        if showingText {
            
            let frame = CGRectMake(collectionView.contentOffset.x, end.origin.y - 50 - 64, CGRectGetWidth(UIScreen.mainScreen().bounds), 50)
            colorCollectionVC.collectionView?.hidden = false
            colorCollectionVC.collectionView?.alpha = 0
            
            UIView.animateWithDuration(0.3) {
                self.colorCollectionVC.collectionView?.frame = frame
                self.colorCollectionVC.collectionView?.alpha = 1
            }
        }
    }
}

// MARK: Collection View Data Source
extension SJCollectionViewController: UICollectionViewDataSource {

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
    
    // Text Button
    func collectionView(collectionView: UICollectionView, bottomView: UIView , didPressTextButton button:UIButton) {
        
        showingText = true
        colorCollectionVC.collectionView!.hidden = true
        self.collectionView.panGestureRecognizer.enabled = false

        let collectionView = collectionView as! SJCollectionView
        let width = CGRectGetWidth(UIScreen.mainScreen().bounds)
        let midY = CGRectGetMidY(collectionView.bounds)
        let height: CGFloat = 60
        
        // Create an instance of Text Field
        let frame = CGRect(x: collectionView.contentOffset.x, y: midY - 50, width: width, height: height)
        let textField = SJTextField(frame: frame)
        textField.delegate = self
        textField.becomeFirstResponder()
        
        // Add Text Field to collection view
        collectionView.addSubview(textField)
        
        sj_textField = textField
    }

    // Camera Button
    func collectionView(collectionView: UICollectionView, bottomView: UIView, didPressCameraButton button: UIButton) {
        commonCodeForPhotos(false)
    }
    
    // Color Wheel
    func collectionView(collectionView: UICollectionView, bottomView: UIView , didPressColorWheelButton button:UIButton){
        
        // Imp
        self.collectionView.panGestureRecognizer.enabled = false

        // 50 : height of color vc
        // 64 : height of nav bar + status bar
        let height = CGRectGetHeight(UIScreen.mainScreen().bounds)/2 - 50 - 64
        let width = CGRectGetWidth(UIScreen.mainScreen().bounds)
        colorCollectionVC.collectionView!.hidden = false
        let frame = CGRectMake(collectionView.contentOffset.x, height, width , 50)
        
        UIView.animateWithDuration(0.3) {
            self.colorCollectionVC.collectionView?.frame = frame
        }
    }
    
    // Grid Button
    func collectionView(collectionView: UICollectionView, bottomView: UIView , didPressGridButton button:UIButton) {
        commonCodeForPhotos(true)
    }
    
    // Smiley Button
    // Not Supported Right Now
    func collectionView(collectionView: UICollectionView, bottomView: UIView , didPressSmileyButton button:UIButton) {
        //showingText = true
        //colorCollectionVC.collectionView!.hidden = true
        //self.collectionView.panGestureRecognizer.enabled = false
    }
    
    // Camera and Grid
    func commonCodeForPhotos(forGrid: Bool) {
        
        // If grid button was pressed
        isGridButtonTapped = forGrid
        
        // Initial
        colorCollectionVC.collectionView!.hidden = true
        self.collectionView.panGestureRecognizer.enabled = false
        
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
            if self.collectionView.cell_subViewsCount == 0 {
                self.collectionView.panGestureRecognizer.enabled = true
            }
            })
        
        presentViewController(sheet, animated: true, completion: nil)
    }
    
    
    // Add To Cart
    func collectionView(collectionView: UICollectionView, didPressAddToCartButton button:UIButton, withSnapShotImage snapshot: UIImage, andTemplate template: Template) {
//        let cart = UserCart.sharedCart()
//        cart.addProduct(template, snapshot: snapshot)
    }
    
    
    // Restart
    func collectionView(collectionView: UICollectionView, didPressRestartButton button:UIButton) {
        
        // Show an alert
        let collectionView = collectionView as! SJCollectionView
        let alert = UIAlertController(title: "Warning", message: "Are you sure you want to delete your current design and start over?", preferredStyle: .Alert)
        
        // Okay
        alert.addAction(UIAlertAction(title: "Continue", style: .Default) { action in
            
            // Re enable collection view pan gesture
            self.collectionView.panGestureRecognizer.enabled = true
            
            // Hide the color view
            self.colorCollectionVC.collectionView!.hidden = true
            
            // Text Field
            if let sj_textField = self.sj_textField {
                if sj_textField.canResignFirstResponder() {
                    sj_textField.resignFirstResponder()
                }
                sj_textField.removeFromSuperview()
                self.sj_textField = nil
                self.showingText = false
            }
            
            // Should return only one cell
            let cells = collectionView.visibleCells() as! [SJCollectionViewCell]
            if cells.count == 1 {
                let cell = cells.first!
                for view in cell.sj_subViews {
                    view.removeFromSuperview()
                }
                cell.sj_subViews.removeAll(keepCapacity: true)
                cell.boundingRectView?.backgroundColor = UIColor.clearColor()
                cell.addColor(UIColor.clearColor())
            }
            
            // Hide the color VC
            self.colorCollectionVC.collectionView?.hidden = true
        })
        
        // Cancel
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel) { action in
            self.dismissViewControllerAnimated(true, completion: nil)
        })
        
        presentViewController(alert, animated: true, completion: nil)
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
                colorCollectionVC.collectionView?.hidden = true
                showingText = false
                // Create The label
                collectionView.sj_createTextLabel(textField.text, afont: textField.font, acolor: textField.textColor)
                return true
            }
        }

        textField.resignFirstResponder()
        textField.removeFromSuperview()
        showingText = false

        if collectionView!.cell_subViewsCount == 0 {
            collectionView!.panGestureRecognizer.enabled = true
        }
        
        if !colorCollectionVC.collectionView!.hidden {
            colorCollectionVC.collectionView!.hidden = true
        }
        
        return true
    }
}

// MARK: Camera Button
extension SJCollectionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
        if collectionView.cell_subViewsCount == 0 {
            collectionView!.panGestureRecognizer.enabled = true
        }
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
        collectionView.sj_createImage(image, forGrid: isGridButtonTapped)
    }
}

// MARK: Color Collection View Delegate
extension SJCollectionViewController: SJColorCollectionViewControllerDelegate {
    
    func colorCollectionView(collectionView: UICollectionView, didSelectColor color: UIColor) {
        
        // If pressed text button
        // then change color of label
        if showingText {
            sj_textField!.textColor = color
            return
        }
        
        // other change color of product
        self.collectionView.sj_addColor(color)
    }
}

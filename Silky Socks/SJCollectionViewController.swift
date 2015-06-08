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
    let reuseIdentifier = "Cell"
    
    // Collection view
    @IBOutlet weak var collectionView: SJCollectionView!
    
    // Image Picker Controller
    private var picker: UIImagePickerController!
    
    // Color Palette Collection View
    private var colorCollectionVC: SJColorCollectionViewController!
    
    // Keep Track of Color Palette
    // Either on clicking text or on clicking color wheel
    private var showingText = false
    
    // The text field shown when the text button is pressed
    private var sj_textField: SJTextField?
    
    // Whether Camera button is clicked or grid button
    private var isGridButtonTapped = false
    
    // Width of screen
    private var width: CGFloat {
        return CGRectGetWidth(UIScreen.mainScreen().bounds)
    }
    
    // The height of the color view controller
    private let heightOfColorVC: CGFloat = 50
    
    // The x and check view
    private var approvalVC: SJApprovalViewController!
    
    // Height of the approval view
    private let heightOfApprovalView: CGFloat = 75
    
    // the showing rect of the approval vc
    private var showRect: CGRect {
        return CGRect(x: collectionView.contentOffset.x, y: CGRectGetHeight(UIScreen.mainScreen().bounds) - 64 - heightOfApprovalView , width: width, height: heightOfApprovalView)
    }
    
    // the hiding rect of the approval vc
    private var hideRect: CGRect {
        return CGRect(x: collectionView.contentOffset.x, y: CGRectGetHeight(UIScreen.mainScreen().bounds) - 64, width: width, height: heightOfApprovalView)
    }
    
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
        collectionView!.delegate = self
        
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
        var frame = CGRect(x: 0, y: 0, width: width, height: heightOfColorVC)
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: heightOfColorVC - 16, height: heightOfColorVC)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .Horizontal
        
        // Set up the color View
        // This VC is added as a child view controller
        colorCollectionVC = SJColorCollectionViewController(collectionViewLayout: layout)
        colorCollectionVC.collectionView!.frame = frame
        colorCollectionVC.collectionView!.hidden = true
        colorCollectionVC.delegate = self
        
        // Set Up the approval VC
        // Added as a child VC
        approvalVC = SJApprovalViewController(nibName: "SJApprovalViewController", bundle: nil)
        approvalVC.delegate = self
        approvalVC.view.frame = hideRect
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Doing this in view did appear
        // In view did load leads to frame issues
        collectionView.addSubview(colorCollectionVC.collectionView!)
        addChildViewController(colorCollectionVC)
        colorCollectionVC.didMoveToParentViewController(self)
        
        // Add approval VC as a child view controller
        collectionView.addSubview(approvalVC.view)
        addChildViewController(approvalVC)
        approvalVC.didMoveToParentViewController(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Clear out the template array
        templateArray = []
        
        // Delete the picker
        picker = nil
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
        cell.delegate = self.collectionView // Very Essential
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

// MARK: Keyboard Support
extension SJCollectionViewController {
    
    // KeyBoard will appear
    func handleKeyBoard(notification: NSNotification) {
        
        // the end y coordinate
        let end = (notification.userInfo![UIKeyboardFrameEndUserInfoKey]!).CGRectValue()
        
        // if text button clicked
        // then display color VC on top of keyboard
        if showingText {
            
            // Want font
            colorCollectionVC.wantFont = true
            
            // Reload to get fonts
            colorCollectionVC.collectionView?.reloadData()
            colorCollectionVC.collectionView?.hidden = false
            colorCollectionVC.collectionView?.alpha = 0
            
            // New Frame
            let frame = CGRectMake(collectionView.contentOffset.x, end.origin.y - heightOfColorVC - 64, width, heightOfColorVC)
            
            UIView.animateWithDuration(0.3) {
                self.colorCollectionVC.collectionView?.frame = frame
                self.colorCollectionVC.collectionView?.alpha = 1
            }
        }
    }
}

// MARK: Collection View Delegate
extension SJCollectionViewController: SJCollectionViewDelegate {
    
    // Text Button
    func collectionView(collectionView: UICollectionView, bottomView: UIView , didPressTextButton button:UIButton) {
        
        showingText = true
        colorCollectionVC.collectionView!.hidden = true
        collectionView.panGestureRecognizer.enabled = false

        let collectionView = collectionView as! SJCollectionView
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
        commonCodeForPhotos(forGrid: false)
    }
    
    // Grid Button
    func collectionView(collectionView: UICollectionView, bottomView: UIView , didPressGridButton button:UIButton) {
        commonCodeForPhotos(forGrid: true)
    }
    
    // Color Wheel
    func collectionView(collectionView: UICollectionView, bottomView: UIView , didPressColorWheelButton button:UIButton){
        
        // Dis-able pan gesture
        collectionView.panGestureRecognizer.enabled = false
        
        // 64 : height of nav bar + status bar
        let height = CGRectGetHeight(UIScreen.mainScreen().bounds) - heightOfApprovalView - heightOfColorVC - 64
        let frame = CGRectMake(collectionView.contentOffset.x, height, width , heightOfColorVC)
        colorCollectionVC.wantFont = false
        colorCollectionVC.collectionView?.reloadData()
        colorCollectionVC.collectionView!.hidden = false
        
        UIView.animateWithDuration(0.3) {
            self.colorCollectionVC.collectionView?.frame = frame
        }
        
        // Show the approval VC
        showApprovalVC(SJBottomViewConstants.Color, forView: nil)
    }
    
    // Smiley Button
    // Not Supported Right Now
    func collectionView(collectionView: UICollectionView, bottomView: UIView , didPressSmileyButton button:UIButton) {
        //showingText = true
        //colorCollectionVC.collectionView!.hidden = true
        //self.collectionView.panGestureRecognizer.enabled = false
    }
    
    // Add To Cart
    func collectionView(collectionView: UICollectionView, didPressAddToCartButton button:UIButton, withSnapShotImage snapshot: UIImage, andTemplate template: Template) {
        
        
        
    }
    
    
    // Restart
    func collectionView(collectionView: UICollectionView, didPressRestartButton button:UIButton) {
        
        // Show an alert
        let collectionView = collectionView as! SJCollectionView
        let alert = UIAlertController(title: "Warning", message: "Are you sure you want to delete your current design and start over?", preferredStyle: .Alert)
        
        // Okay - Restart
        alert.addAction(UIAlertAction(title: "Continue", style: .Default) { action in
            
            // Re enable collection view pan gesture
            self.collectionView.panGestureRecognizer.enabled = true
            
            // Hide the color view
            self.colorCollectionVC.collectionView!.hidden = true
            
            // Text Field
            if let sj_textField = self.sj_textField {
                sj_textField.resignFirstResponder()
                sj_textField.removeFromSuperview()
                self.sj_textField = nil
                self.showingText = false
            }
            
            // Tell the cell to clean Up
            if let cell = collectionView.visibleCell {
                cell.performCleanUp()
            }
            
        })
        
        // Cancel - Do Nothing
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel) { action in
            self.dismissViewControllerAnimated(true, completion: nil)
        })
        
        // Present the Alert
        presentViewController(alert, animated: true, completion: nil)
    }
    
    
    // Share
    func collectionView(collectionView: UICollectionView, didPressShareButton button: UIButton, withSnapShotImage snapshot: UIImage) {
        
        var items = ["Check out the design I created on the silky socks app. http://www.silkysocks.com/app", snapshot]
        let activity = UIActivityViewController(activityItems: items, applicationActivities: nil)
        activity.excludedActivityTypes = [UIActivityTypeAddToReadingList, UIActivityTypeAssignToContact, UIActivityTypePrint, UIActivityTypeSaveToCameraRoll]
        presentViewController(activity, animated: true, completion: nil)
    }
    
    
    func collectionView(collectionView: UICollectionView, touchesBegan point: CGPoint) {
        // Hide the color VC
        hideColorCollectionVC()
        // Check if we should pan
        shouldPan()
    }
    
    func collectionView(collectionView: UICollectionView, didTapSubview view: UIView) {
        if !CGRectEqualToRect(approvalVC.view.frame, showRect) {
            showApprovalVC(nil, forView: view)
        }
    }
}

// MARK: Text Button
extension SJCollectionViewController: UITextFieldDelegate {
    
    // When Done button is pressed
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        // If text field has some text
        if count(textField.text) > 0 {
            if textField.canResignFirstResponder() {
                textField.resignFirstResponder()
                textField.removeFromSuperview()
                colorCollectionVC.collectionView?.hidden = true
                showingText = false
                // Create The label
                collectionView.sj_createTextLabel(textField.text, afont: textField.font, acolor: textField.textColor)
                showApprovalVC(SJBottomViewConstants.Text, forView: nil)
                return true
            }
        }

        textField.resignFirstResponder()
        textField.removeFromSuperview()
        showingText = false

        shouldPan()
        hideColorCollectionVC()
        
        return true
    }
}

// MARK: Camera Button / Grid Button
extension SJCollectionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // Camera and Grid
    func commonCodeForPhotos(#forGrid: Bool) {
        
        // If grid button was pressed
        isGridButtonTapped = forGrid
        
        // Initial
        colorCollectionVC.collectionView!.hidden = true
        collectionView.panGestureRecognizer.enabled = false
        
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
            // If nothing was added to the cell, then enable the pan gesture
            self.shouldPan()
        })
        
        presentViewController(sheet, animated: true, completion: nil)
    }
    
    // Did Cancel
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
        shouldPan()
    }
    
    // Did Pick Image
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
        
        // Show Approval VC
        isGridButtonTapped ? showApprovalVC(SJBottomViewConstants.Grid, forView: nil) : showApprovalVC(SJBottomViewConstants.Image, forView: nil)
    }
}

// MARK: Color Collection View Delegate
extension SJCollectionViewController: SJColorCollectionViewControllerDelegate {
    
    func colorCollectionView<T>(collectionView: UICollectionView, didSelectColorOrFont object: T) {
        
        // UIColor
        if let object = object as? UIColor {
            
            // If pressed text button, then change color of label
            if showingText {
                sj_textField!.textColor = object
                return
            }
            
            // other change color of product
            self.collectionView.sj_addColor(object)
        }
        
        // UIFont
        else if let object = object as? UIFont {
            
            if showingText {
                sj_textField!.font = object
            }            
        }
    }
}

// MARK: Approval View Controller Delegate
extension SJCollectionViewController: SJApprovalViewControllerDelegate {
    
    // Show the Approval VC
    func showApprovalVC(tag: Int?, forView view: UIView?) {
        UIView.animateWithDuration(0.3) {
            self.approvalVC.view.frame = self.showRect
        }
        approvalVC.buttonPressedTag = tag
        approvalVC.approvalViewForView = view
        collectionView.sj_bottomView?.hidden = true
    }
    
    // Pressed check button
    func approvalView(viewController: SJApprovalViewController, didPressCheckButton button: UIButton, forView view: UIView?, withTag tag: Int?) {

        if let tag = tag {
            switch tag {
                case SJBottomViewConstants.Color:
                    hideColorCollectionVC()
                default:
                    break
            }
        }

        // Hide
        hideApprovalVC()
    }
    
    // Pressed X Button
    func approvalView(viewController: SJApprovalViewController, didPressXButton button: UIButton, forView view: UIView?, withTag tag: Int?) {
    
        if let view = view {
            collectionView.sj_undo(view)
        } else {
            if let tag = tag {
                switch tag {
                    // Image
                case SJBottomViewConstants.Image:
                    fallthrough
                    // Text
                case SJBottomViewConstants.Text:
                    collectionView.sj_undo()
                    // Color
                case SJBottomViewConstants.Color:
                    hideColorCollectionVC()
                    collectionView.sj_addColor(UIColor.clearColor())
                    // Grid
                case SJBottomViewConstants.Grid:
                    collectionView.sj_undoGrid()
                default:
                    break
                }
            }
        }
        
        // Hide
        hideApprovalVC()
    }
    
    // Dismiss the Approval VC
    func hideApprovalVC() {
        
        // Check if should pan
        shouldPan()
        
        // Hide
        UIView.animateWithDuration(0.3) {
            self.approvalVC.view.frame = self.hideRect
        }
        
        // Show the bottom view
        collectionView.sj_bottomView?.hidden = false
    }
}

// MARK: Helper Function
extension SJCollectionViewController {
    
    // Hide the color view controller
    private func hideColorCollectionVC() {
        if !colorCollectionVC.collectionView!.hidden  {
            colorCollectionVC.collectionView!.hidden = true
        }
    }
    
    // Asks the cell, if we should pan
    private func shouldPan() {
        
        // Get the currently visible cell
        if let cell = collectionView.visibleCell {
            if cell.shouldPan() {
                collectionView!.panGestureRecognizer.enabled = true
            }
        }
    }
}

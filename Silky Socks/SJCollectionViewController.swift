//
//  SJCollectionViewController.swift
//  Silky Socks
//
//  Created by Saurabh Jain on 4/19/15.
//  Copyright (c) 2015 Saurabh Jain. All rights reserved.
//

import UIKit
import MessageUI
import MobileCoreServices

class SJCollectionViewController: UIViewController {

    // the array containing templates
    lazy private var templateArray = Template.allTemplates()
    
    // Constants
    private struct Constants {
        static let CellReuseIdentifier = "Cell"
        static let HeightOfColorVC: CGFloat = 50
        static let HeightOfApprovalView: CGFloat = 75
        static var width: CGFloat { return CGRectGetWidth(UIScreen.mainScreen().bounds) }
    }
    
    // Collection view
    @IBOutlet weak var collectionView: SJCollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.myDelegate = self
        }
    }
    
    // Color Palette Collection View
    private var colorCollectionVC: SJColorCollectionViewController!

    // Keep Track of Color Palette
    // Either on clicking text or on clicking color wheel
    private var showingText = false
    
    // The text field shown when the text button is pressed
    private var sj_textField: SJTextField?
    
    // Whether Camera button is clicked or grid button
    private var isGridButtonTapped = false

    
    // MARK: - Approval View Controller
    
    // The x and check view
    private var approvalVC: SJApprovalViewController!
    
    // the showing rect of the approval vc
    private var showRect: CGRect {
        return CGRect(x: collectionView.contentOffset.x, y: CGRectGetHeight(UIScreen.mainScreen().bounds) - 64 - Constants.HeightOfApprovalView , width: Constants.width, height: Constants.HeightOfApprovalView)
    }
    
    // the hiding rect of the approval vc
    private var hideRect: CGRect {
        return CGRect(x: collectionView.contentOffset.x, y: CGRectGetHeight(UIScreen.mainScreen().bounds) - 64, width: Constants.width, height: Constants.HeightOfApprovalView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting the Top Silcy Socks Logo
        let nav_barHeight = CGRectGetHeight(navigationController!.navigationBar.bounds)
        let img_view = UIImageView(image: UIImage(named: "topbar_logo"))
        img_view.frame = CGRectMake(0, 0, 150, nav_barHeight - 10)
        img_view.contentMode = .ScaleAspectFit
        navigationItem.titleView = img_view
        
        // Set the layout for the colorVC
        let frame = CGRect(x: 0, y: 0, width: Constants.width, height: Constants.HeightOfColorVC)
        let layout = SJStickyFontHeaderLayout()
        layout.itemSize = CGSize(width: Constants.HeightOfColorVC - 16, height: Constants.HeightOfColorVC)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .Horizontal
        layout.headerReferenceSize = CGSize(width: Constants.HeightOfColorVC, height: Constants.HeightOfColorVC)
        
        // Set up the color View
        // This VC is added as a child view controller
        // Using the same color view controller both for the text and color button
        // will show the font option in the text button by dequeuing a header view
        colorCollectionVC = SJColorCollectionViewController(collectionViewLayout: layout)
        colorCollectionVC.collectionView!.frame = frame
        colorCollectionVC.collectionView!.hidden = true
        colorCollectionVC.delegate = self
        
        // Set Up the approval VC
        // Added as a child VC
        approvalVC = SJApprovalViewController(nibName: "SJApprovalViewController", bundle: nil)
        approvalVC.delegate = self
        approvalVC.view.frame = hideRect
        
        // Right Bar Button item
        let cartView = UIButton(frame: CGRect(origin: .zeroPoint, size: CGSize(width: 30, height: 30)))
        cartView.setImage(UIImage(named: "cart"), forState: .Normal)
        cartView.addTarget(self, action: "cartButtonPressed:", forControlEvents: .TouchUpInside)
        let cartButton = UIBarButtonItem(customView: cartView)
        navigationItem.rightBarButtonItem = cartButton
        
        // Set up the badge
        notificationHub = RKNotificationHub(view: cartView)
        notificationHub.scaleCircleSizeBy(0.5)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        notificationHub.count = UInt(UserCart.sharedCart.numberOfItems)
        
        // Track changes in the keyboard
        // Used to display the color VC appropriately
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleKeyBoard:", name: UIKeyboardDidShowNotification, object: nil)
        
        // When an object is added to the cart, then do something
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "incrementCartCount:", name: kAddToCartNotification, object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Doing this in view did appear
        //  In view did load leads to frame issues
        collectionView.addSubview(colorCollectionVC.collectionView!)
        addChildViewController(colorCollectionVC)
        colorCollectionVC.didMoveToParentViewController(self)
        
        // Add approval VC as a child view controller
        collectionView.addSubview(approvalVC.view)
        addChildViewController(approvalVC)
        approvalVC.didMoveToParentViewController(self)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - Cart Button
    
    // Used to increment the badge count on the cart bar button item
    private var notificationHub: RKNotificationHub!
    
    // Cart Increment Notification SEL
    @objc private func incrementCartCount(notification: NSNotification) {
        notificationHub.increment()
        notificationHub.pop()
        notificationHub.bump()
        notificationHub.bump()
    }
    
    // Storing Constants from the Storyboard
    private struct Storyboard {
        static let CartSegue = "cartSegue"
    }
    
    // Cart button Pressed SEL
    @objc private func cartButtonPressed(button: UIBarButtonItem) {
        // Do Something
        if notificationHub.count > 0 {
            performSegueWithIdentifier(Storyboard.CartSegue, sender: nil)
        }
    }
}

// MARK: Collection View Data Source
extension SJCollectionViewController: UICollectionViewDataSource {

    // Number of templates = number of rows
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return templateArray.count
     }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Constants.CellReuseIdentifier, forIndexPath: indexPath) as! SJCollectionViewCell
        cell.template = templateArray[indexPath.row]
        return cell
    }
    
    // Dequeue the various supplementary view
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
        let end = (notification.userInfo![UIKeyboardFrameEndUserInfoKey]!).CGRectValue
        
        // if text button clicked
        // then display color VC on top of keyboard
        if showingText {
            
            // Tells the color collection vc that we want to give users the option to switch to fonts
            colorCollectionVC.wantFont = true
            
            // Reload to dequeue the header view (FontCollectionReusableViewDelegate)
            colorCollectionVC.collectionView?.reloadData()
            colorCollectionVC.collectionView?.hidden = false
            colorCollectionVC.collectionView?.alpha = 0
            
            // New Frame
            let frame = CGRectMake(collectionView.contentOffset.x, end.origin.y - Constants.HeightOfColorVC - 64, Constants.width, Constants.HeightOfColorVC)
            
            UIView.animateWithDuration(0.3) { [unowned self] in
                self.colorCollectionVC.collectionView?.frame = frame
                self.colorCollectionVC.collectionView?.alpha = 1
            }
        }
    }
}

// MARK: Collection View Delegate
extension SJCollectionViewController: SJCollectionViewDelegate, MFMailComposeViewControllerDelegate {
    
    // Text Button
    func collectionView(collectionView: UICollectionView, bottomView: UIView , didPressTextButton button:UIButton) {
        
        // Basic
        showingText = true
        colorCollectionVC.collectionView!.hidden = true
        collectionView.panGestureRecognizer.enabled = false

        let collectionView = collectionView as! SJCollectionView
        let midY = CGRectGetMidY(collectionView.bounds)
        let height: CGFloat = 60
        
        // Create an instance of Text Field
        let frame = CGRect(x: collectionView.contentOffset.x, y: midY - 50, width: Constants.width, height: height)
        let textField = SJTextField(frame: frame)
        textField.delegate = self
        textField.becomeFirstResponder()
        
        // Add Text Field to collection view
        collectionView.addSubview(textField)
        
        // Make the private var point to this text field
        sj_textField = textField
    }

    // Camera Button
    func collectionView(collectionView: UICollectionView, bottomView: UIView, didPressCameraButton button: UIButton) {
        commonCodeForPhotos(forGrid: false, sender: button)
    }
    
    // Grid Button
    func collectionView(collectionView: UICollectionView, bottomView: UIView , didPressGridButton button:UIButton) {
        commonCodeForPhotos(forGrid: true, sender: button)
    }
    
    // Color Wheel
    func collectionView(collectionView: UICollectionView, bottomView: UIView , didPressColorWheelButton button:UIButton){
        
        // Dis-able pan gesture
        collectionView.panGestureRecognizer.enabled = false
        
        // 64 : height of nav bar + status bar
        let height = CGRectGetHeight(UIScreen.mainScreen().bounds) - Constants.HeightOfApprovalView - Constants.HeightOfColorVC - 64
        let frame = CGRectMake(collectionView.contentOffset.x, height, Constants.width , Constants.HeightOfColorVC)
        
        // Tells the color collection vc that we dont want to 
        // give people the option to switch to fonts
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
    // Right now send a mail to check for correct size
    func collectionView(collectionView: UICollectionView, didPressAddToCartButton button:UIButton, withSnapShotImage snapshot: UIImage, andTemplate template: Template) {
        
        let image = snapshot.renderImageIntoSize(template.productSize)
        let mail = MFMailComposeViewController()
        //mail.addAttachmentData(UIImagePNGRepresentation(image), mimeType: "image/png", fileName: "Design")
        mail.addAttachmentData(UIImageJPEGRepresentation(image, 0.7)!, mimeType: "image/jpeg", fileName: "Design")
        mail.mailComposeDelegate = self
        presentViewController(mail, animated: true, completion: nil)
        
        // Create a cart Product
        //UserCart.sharedCart.addProduct(CartProduct(template: template, withImage: snapshot))
    }
    
    // Dismiss the mail compose view controller
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Restart
    func collectionView(collectionView: UICollectionView, didPressRestartButton button:UIButton) {
        
        // Show an alert
        let collectionView = collectionView as! SJCollectionView
        let title = "Warning"
        let message = "Are you sure you want to delete your current design and start over?"
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        // Okay - Restart
        alert.addAction(UIAlertAction(title: "Continue", style: .Default) { [unowned self] action in
            
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
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel) { [unowned self] action in
            self.dismissViewControllerAnimated(true, completion: nil)
        })
        
        // Present the Alert
        presentViewController(alert, animated: true, completion: nil)
    }
    
    
    // Share
    func collectionView(collectionView: UICollectionView, didPressShareButton button: UIButton, withSnapShotImage snapshot: UIImage) {
        
        // Create Activity Controller on Demand
        let items = ["Check out the design I created on the silky socks app. http://www.silkysocks.com/app", snapshot]
        let activity = UIActivityViewController(activityItems: items, applicationActivities: nil)
        activity.excludedActivityTypes = [UIActivityTypeAddToReadingList, UIActivityTypeAssignToContact, UIActivityTypePrint, UIActivityTypeSaveToCameraRoll]
        presentViewController(activity, animated: true, completion: nil)

    }
    
    
    // Tapped in the collection view cell
    func collectionView(collectionView: UICollectionView, touchesBegan point: CGPoint) {
        // Hide the color VC
        hideColorCollectionVC()
        // Check if we should pan
        shouldPan()
    }
    
    // Tapped on a subview inside the cell
    func collectionView(collectionView: UICollectionView, didTapSubview view: UIView) {
        
        // If approval VC is not already present then show it
        if !CGRectEqualToRect(approvalVC.view.frame, showRect) {
            showApprovalVC(nil, forView: view)
        }
    }
    
    // Tapped at info Button
    func collectionView(collectionView: UICollectionView, didTapInfoButton button: UIButton, withTemplateObject template: Template) {
        
        // Create a TemplateInfoViewController on Demand
        let infoVC = TemplateInfoViewController(nibName: TemplateInfoViewController.NibName(), bundle: nil)
        infoVC.template = template
        infoVC.modalPresentationStyle = .Popover
        
        // Wrap it in a navigation controller
        let navController = UINavigationController(rootViewController: infoVC)
        presentViewController(navController, animated: true, completion: nil)
    }
}

// MARK: Text Button
extension SJCollectionViewController: UITextFieldDelegate {
    
    // When Done button is pressed
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        // If text field has some text
        if textField.text?.characters.count > 0 {
            if textField.canResignFirstResponder() {
                textField.resignFirstResponder()
                textField.removeFromSuperview()
                colorCollectionVC.collectionView?.hidden = true
                showingText = false
                // Create The label
                collectionView.sj_createTextLabel(textField.text!, afont: textField.font!, acolor: textField.textColor!)
                showApprovalVC(SJBottomViewConstants.Text, forView: nil)
                return false
            }
        }

        textField.resignFirstResponder()
        textField.removeFromSuperview()
        showingText = false

        // Check if we should pan && hide the coloe collection vc
        shouldPan()
        hideColorCollectionVC()
        
        return true
    }
}

// MARK: Camera Button / Grid Button
extension SJCollectionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // Camera and Grid
    func commonCodeForPhotos(forGrid forGrid: Bool, sender: UIButton) {
        
        // If grid button was pressed
        isGridButtonTapped = forGrid
        
        // Initial
        colorCollectionVC.collectionView!.hidden = true
        collectionView.panGestureRecognizer.enabled = false
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.mediaTypes = [kUTTypeImage as String]
        picker.sourceType = .PhotoLibrary
        
        // Create On Demand
        let sheet = UIAlertController(title: "Import Photo", message: nil, preferredStyle: .ActionSheet)
        
        let takePhotoAction = UIAlertAction(title: "Take Photo", style: .Default) { [unowned self] _ in
            if UIImagePickerController.isSourceTypeAvailable(.Camera) {
                picker.sourceType = .Camera
            }
            self.presentViewController(picker, animated: true, completion: nil)
        }
        
        let choosePhotoAction = UIAlertAction(title: "Choose Photo", style: .Default) { [unowned self] _ in
            if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
                picker.sourceType = .PhotoLibrary
            }
            self.presentViewController(picker, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { [unowned self] _ in
            self.dismissViewControllerAnimated(true, completion: nil)
            self.shouldPan()
        }
        
        // Add Actions
        sheet.addAction(takePhotoAction)
        sheet.addAction(choosePhotoAction)
        sheet.addAction(cancelAction)
        
        presentViewController(sheet, animated: true, completion: nil)
    }
    
    // Did Cancel
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
        shouldPan()
    }
    
    // Did Pick Image
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        var image = info[UIImagePickerControllerOriginalImage] as! UIImage
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            image = editedImage
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
    func colorCollectionView(collectionView: UICollectionView, didSelectColor color: UIColor) {
        
        // If pressed text button, then change color of label
        if showingText {
            sj_textField?.textColor = color
        } else {
            // other change color of product
            self.collectionView.sj_addColor(color)
        }
    }
    
    func colorCollectionView(collectionView: UICollectionView, didSelectFont font: UIFont) {
        sj_textField?.font = font
    }
}

// MARK: Approval View Controller Delegate
extension SJCollectionViewController: SJApprovalViewControllerDelegate {
    
    // Show the Approval VC
    func showApprovalVC(tag: Int?, forView view: UIView?) {
        
        // Animate from bottom
        UIView.animateWithDuration(0.3) { [unowned self] in
            self.approvalVC.view.frame = self.showRect
        }
        
        approvalVC.buttonPressedTag = tag
        approvalVC.approvalViewForView = view
        
        // Hide the bottom view
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
    
        // If view exists, then remove it
        if let view = view {
            collectionView.sj_undo(view)
        }
        
        // Remove the last added subview
        else {
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
        UIView.animateWithDuration(0.3) { [unowned self] in
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

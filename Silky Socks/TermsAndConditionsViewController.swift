//
//  TermsAndConditionsViewController.swift
//  Silky Socks
//
//  Created by Saurabh Jain on 7/20/15.
//  Copyright © 2015 Full Stak. All rights reserved.
//

import UIKit

// Not used right now
private class TermsAndConditionsViewController: UIViewController {

    override func viewDidLoad() {
        
        let text =
            "Terms and Conditions: The User automatically when making a purchase, sharing a design, or creating a design using the Silky Socks Mobile App enters into the terms and conditions laid out in this page. Silky Socks can alter, edit, or update this agreement at any time.  The User, by using the Silky Socks App, accepts the most recent version of this terms and conditions agreement.\n\n" +
            "Picture Quality: When uploading an image, the output will result in the quality of image submitted.  Silky Socks is not responsible for a low quality image being uploaded, and will not offer refunds or exchanges for pixilated images or low-resolution output as a result of a low-resolution image submitted by the User.\n\n" +
            "User Conduct: In using this App User agrees not to upload, design or share content that is unlawful, harmful, threatening, hateful, prejudice, profane, pornographic, obscene, vulgar, objectionable, or invasive on the rights of another person, party, company, or group.\n\n" +
            "Copyright: Silky Socks request User to upload, share or purchase images and designs that the User has full rights to use only.It is up to the User to verify whether he or she has the right to use any content uploaded by the User, and user takes full responsibility from any 3rd party claims of copyright infringement or trademark violation.  Silky Socks is not responsible in researching, verifying, or answering to any claims of copyright infringement or trademark violation by User uploaded content from using the Silky Socks App.\n\n" +
            "WAIVER AND RELEASE OF LIABILITY: By uploading a design for purchase on socks and t-shirts using the Silky Socks Mobile App (the “Activity”), I (the “User”) assume all risks, copyrights and responsibilities of making this purchase.  Silky Socks assumes no responsibility for the content or image uploaded and submitted for print.\n In consideration of the risk of injury or copyright infringement while participating in the Activity, and as consideration for the right to participate in the Activity, I hereby, for myself, my heirs, executors, administrators, assigns, or personal representatives, knowingly and voluntarily enter into this waiver and release of liability and hereby waive any and all rights, claims or causes of action of any kind whatsoever arising out of my participation in the Activity, and do hereby release and forever discharge Silky Socks, located at info@silkysocks.com, Anaheim, California 92806, their affiliates, managers, members, agents, attorneys, staff, volunteers, heirs, representatives, predecessors, successors and assigns, for any legal, physical or psychological injury, including but not limited to copyright infringement, lawsuit, legal accountability, illness, damages, economical or emotional loss, that I may suffer as a direct result of my participation in the aforementioned Activity.\n I am voluntarily participating in the aforementioned Activity and I am participating in the Activity entirely at my own risk. I am aware of the risks associated with participating in this Activity, and I assume all related risks of my designs submitted for print, both known or unknown to me, of my participation in this Activity.\n I agree to indemnify and hold harmless Silky Socks against any and all claims, suits or actions of any kind whatsoever for liability, damages, compensation or otherwise brought by me or anyone on my behalf, including attorney's fees and any related costs, if litigation arises pursuant to any claims made by me or by anyone else acting on my behalf. If Silky Socks incurs any of these types of expenses, I agree to reimburse Silky Socks.\n I acknowledge that Silky Socks and their directors, officers, volunteers, representatives and agents are not responsible for errors, omissions, acts or failures to act of any party or entity conducting a specific event or activity on behalf of Silky Socks. I acknowledge that I have carefully read this \"waiver and release\" and fully understand that it is a release of liability. I expressly agree to release and discharge Silky Socks and all of its affiliates, managers, members, agents, attorneys, staff, volunteers, heirs, representatives, predecessors, successors and assigns, from any and all claims or causes of action and I agree to voluntarily give up or waive any right that I otherwise have to bring a legal action against Silky Socks for personal injury or property damage.\n To the extent that statute or case law does not prohibit releases for negligence, this release is also for negligence on the part of Silky Socks, its agents, and employees.\nBoth the User and Silky Socks agree that this Agreement is clear and unambiguous as to its terms, and that no other evidence will be used or admitted to alter or explain the terms of this Agreement.  In the event that any provision contained within this Release of Liability shall be deemed to be severable or invalid, or if any term, condition, phrase or portion of this agreement shall be determined to be unlawful or otherwise unenforceable, the remainder of this agreement shall remain in full force and effect, so long as the clause severed does not affect the intent of the parties. If a court should find that any provision of this agreement to be invalid or unenforceable, but that by limiting said provision it would become valid and enforceable, then said provision shall be deemed to be written, construed and enforced as so limited."
        
        // Attribute
        let fontDescriptor = UIFontDescriptor.preferredFontDescriptorWithTextStyle(UIFontTextStyleBody)
        let descriptorWithTrait = fontDescriptor.fontDescriptorWithSymbolicTraits(UIFontDescriptorSymbolicTraits.TraitBold)
        let combinedDescriptorWithTrait = descriptorWithTrait.fontDescriptorWithSymbolicTraits(.TraitItalic)
        let bodyFontSize = combinedDescriptorWithTrait.fontAttributes()[UIFontDescriptorSizeAttribute]! as! CGFloat
        let font = UIFont(descriptor: combinedDescriptorWithTrait, size: bodyFontSize)
        let attrs = [NSFontAttributeName : font]
        let attrString = NSAttributedString(string: text, attributes: attrs)
        
        // Storage & Manager & Container
        let storage = SJTextStorage()
        let rect = CGRectInset(view.bounds, 16, 16)
        let manager = NSLayoutManager()
        let container = NSTextContainer(size: CGSize(width: rect.size.width, height: CGFloat.max))
        storage.addLayoutManager(manager)
        manager.addTextContainer(container)

        // Text View
        let textView = UITextView(frame: rect, textContainer: container)
        textView.attributedText = attrString
        textView.editable = false        
        NSLayoutConstraint.applyAutoLayout(view, target: textView, index: nil, top: 16, left: 16, right: 16, bottom: 16, height: nil, width: nil)
    }
}


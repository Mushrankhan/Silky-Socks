//
//  SJTextStorage.swift
//  Silky Socks
//
//  Created by Saurabh Jain on 7/22/15.
//  Copyright © 2015 Full Stak. All rights reserved.
//

import UIKit

// Not used right now
class SJTextStorage: NSTextStorage {
    
    // Storage
    private var storageString = NSMutableAttributedString()
    
    // Regex
    private let pattern = "\\w+(\\s\\w+)*\\:"
    
    private let attributes: [String:NSObject] = {
        let fontDescriptor = UIFontDescriptor.preferredFontDescriptorWithTextStyle(UIFontTextStyleBody)
        let descriptorWithTrait = fontDescriptor.fontDescriptorWithSymbolicTraits(UIFontDescriptorSymbolicTraits.TraitBold)
        let combinedDescriptorWithTrait = descriptorWithTrait.fontDescriptorWithSymbolicTraits(.TraitItalic)
        let attributes = [NSFontAttributeName: UIFont(descriptor: combinedDescriptorWithTrait, size: 24)]
        return attributes
        }()
    
    // MARK: Override
    
    override var string: String {
        return storageString.string
    }
    
    override func attributesAtIndex(location: Int, effectiveRange range: NSRangePointer) -> [String : AnyObject] {
        return storageString.attributesAtIndex(location, effectiveRange: range)
    }
    
    override func replaceCharactersInRange(range: NSRange, withString str: String) {
        beginEditing()
        storageString.replaceCharactersInRange(range, withString: str)
        edited([.EditedCharacters, .EditedAttributes], range: range, changeInLength: str.characters.count - range.length)
        endEditing()
    }
    
    override func setAttributes(attrs: [String : AnyObject]?, range: NSRange) {
        beginEditing()
        storageString.setAttributes(attrs, range: range)
        edited(.EditedAttributes, range: range, changeInLength: 0)
        endEditing()
    }
    
    
    override func processEditing() {
        performReplacementsForRange(editedRange)
        super.processEditing()
    }
    
    func performReplacementsForRange(range: NSRange) {
        
        let nsString = storageString.string as NSString
        let startOfRange = nsString.lineRangeForRange(NSMakeRange(range.location, 0))
        let endOfRange = nsString.lineRangeForRange(NSMakeRange(NSMaxRange(range), 0))
        
        var extendedRange = NSUnionRange(range, startOfRange)
        extendedRange = NSUnionRange(extendedRange, endOfRange)
        
        var regex: NSRegularExpression?
        do {
            regex = try NSRegularExpression(pattern: pattern, options: .CaseInsensitive)
        } catch _ {
            regex = nil
        }
        
        regex?.enumerateMatchesInString(storageString.string, options: [], range: extendedRange) { (match, falgs, stop) in
            
            // apply the style
            guard let matchRange = match?.range else { return }
            self.addAttributes(self.attributes, range: matchRange)
        }
    }
}


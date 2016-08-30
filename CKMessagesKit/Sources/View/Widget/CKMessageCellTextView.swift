//
//  CKMessageCellTextView.swift
//  CKMessagesViewController
//
//  Created by Chen Kevin on 8/27/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import UIKit

public class CKMessageCellTextView: UITextView {
    
    
    override public init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        configure()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    
    
    private func configure() {
        font = UIFont.preferredFont(forTextStyle: .body)
        textColor = UIColor.white
        isEditable = false
        isSelectable = false
        isUserInteractionEnabled = false
        dataDetectorTypes = [.all]
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        isScrollEnabled = false
        
        backgroundColor = UIColor.clear
        textContainerInset = .zero
        contentInset = .zero
        contentOffset = .zero
        scrollIndicatorInsets = .zero
        textContainer.lineFragmentPadding = 0
        
        
        self.linkTextAttributes = [            
            NSForegroundColorAttributeName : UIColor.white,
            NSUnderlineStyleAttributeName : [NSUnderlineStyle.styleSingle, .patternSolid]
        ]
        
    }

    override open var selectedRange: NSRange {
        get {
            return NSRange(location: NSNotFound, length: 0)
        }
        
        set {
            super.selectedRange = NSRange(location: NSNotFound, length: 0)
        }
    }
    
    override open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let tap = gestureRecognizer as? UITapGestureRecognizer {
            if tap.numberOfTapsRequired == 2 {
                return false
            }
        }
        
        return true
    }
    
    
}

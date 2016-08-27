//
//  CKMessageCellTextView.swift
//  CKMessagesViewController
//
//  Created by Chen Kevin on 8/27/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import UIKit

class CKMessageCellTextView: UITextView {
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    
    
    private func configure() {
        
//        textColor = UIColor.white
        isEditable = false
        isSelectable = false
        isUserInteractionEnabled = false
        dataDetectorTypes = []
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        isScrollEnabled = false
        
        backgroundColor = UIColor.clear
        self.contentInset = .zero;
        self.scrollIndicatorInsets = .zero;
        self.contentOffset = .zero;
        self.textContainerInset = .zero;
        self.textContainer.lineFragmentPadding = 0;
        self.linkTextAttributes = [
//            NSForegroundColorAttributeName : UIColor.white,
            NSUnderlineStyleAttributeName : [NSUnderlineStyle.styleSingle, .patternSolid]
        ]
        
    }

    override var selectedRange: NSRange {
        get {
            return NSRange(location: NSNotFound, length: 0)
        }
        
        set {
            super.selectedRange = NSRange(location: NSNotFound, length: 0)
        }
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let tap = gestureRecognizer as? UITapGestureRecognizer {
            if tap.numberOfTapsRequired == 2 {
                return false
            }
        }
        
        return true
    }
    
    
}

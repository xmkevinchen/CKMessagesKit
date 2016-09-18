//
//  CKTextMessagePresentor.swift
//  CKMessagesKit
//
//  Created by Kevin Chen on 9/16/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import UIKit
import Reusable

public class CKTextMessagePresentor: NSObject, CKMessagePresentor, Reusable {
        
    @IBOutlet public var textView: CKMessageCellTextView!
    public var font = UIFont.preferredFont(forTextStyle: .body) {
        didSet {
            textView.setNeedsDisplay()
        }
    }
    
    override init() {
        super.init()
        let nib = UINib(nibName: String(describing: CKTextMessagePresentor.self), bundle: Bundle(for: CKTextMessagePresentor.self))
        
        guard nib.instantiate(withOwner: self, options: nil).first is CKMessageCellTextView else {
            fatalError()
        }
        
        textView.font = font
        textView.textColor = UIColor.white
        
        
    }
    
    public var messageView: UIView {
        return textView
    }
    
    public var message: CKMessageData? {
        
        didSet {
            textView.text = message?.text
            textView.dataDetectorTypes = .all
        }
    }
    
    public func prepareForReuse() {
        textView.text = nil
    }
    
    public func update(with message: CKMessageData) {
        self.message = message
        
    }
    
    public static func presentor() -> CKMessagePresentor {
        return CKTextMessagePresentor()
    }
    
}


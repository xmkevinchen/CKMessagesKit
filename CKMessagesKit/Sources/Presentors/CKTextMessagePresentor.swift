//
//  CKTextMessagePresentor.swift
//  CKMessagesKit
//
//  Created by Kevin Chen on 9/16/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import UIKit

public class CKTextMessagePresentor: CKMessagePresentor {
        
    @IBOutlet public var textView: CKMessageCellTextView!
    
    init() {
        
        let nib = UINib(nibName: String(describing: CKTextMessagePresentor.self), bundle: Bundle(for: CKTextMessagePresentor.self))
        guard let textView = nib.instantiate(withOwner: self, options: nil).first as? CKMessageCellTextView else {
            fatalError()
        }
        self.textView = textView
        
    }
    
    public var messageView: UIView {
        return textView
    }
    
    public var message: CKMessageData?
    
    public func prepareForReuse() {
        textView.text = nil
    }
    
    public func update(with message: CKMessageData) {
        textView.text = message.text
    }
    
    public static func presentor() -> CKMessagePresentor {
        return CKTextMessagePresentor()
    }
    
}

extension CKTextMessagePresentor: CKMessageEmbeddablePresentor {
    
    public var insets: UIEdgeInsets? {
        return UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
    }
    
}

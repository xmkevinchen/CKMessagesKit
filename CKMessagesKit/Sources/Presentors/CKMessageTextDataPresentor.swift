//
//  CKTextMessagePresentor.swift
//  CKMessagesKit
//
//  Created by Kevin Chen on 9/16/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import UIKit
import Reusable

public class CKMessageTextDataPresentor: UIViewController, CKMessagePresentor, Reusable {
        
    @IBOutlet public var textView: CKMessageCellTextView!
    
    public var font = UIFont.preferredFont(forTextStyle: .body) {
        didSet {
            textView.setNeedsDisplay()
        }
    }
    
    
    
    public var messageView: UIView {
        return view
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.font = font
        textView.textColor = UIColor.white
        textView.text = (message as? CKMessageTextData)?.text
        
    }
    
    public var message: CKMessageData? {
        
        didSet {
            
            guard let textView = textView else {
                return
            }
            
            if let message = message as? CKMessageTextData {
                textView.text = message.text
                textView.dataDetectorTypes = .all
            } else {
                textView.text = nil
                textView.dataDetectorTypes = []
            }
        }
    }
    
    public func prepareForReuse() {
        textView.text = nil
    }
    
    public func update(with message: CKMessageData) {
        self.message = message
        
    }
    
    public static func presentor() -> CKMessagePresentor {
        return CKMessageTextDataPresentor(nibName: String(describing: CKMessageTextDataPresentor.self),
                                          bundle: Bundle(for: CKMessageTextDataPresentor.self))
    }
    
}

extension CKMessageTextDataPresentor: CKMessageEmbeddablePresentor {
    public var insets: UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
    }
}

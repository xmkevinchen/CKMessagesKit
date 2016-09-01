//
//  CKMessagesInputToolbar.swift
//  CKMessagesKit
//
//  Created by Kevin Chen on 8/30/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import UIKit

class CKMessagesInputToolbar: UIToolbar {
    
    var preferredDefaultHeight: CGFloat = 44.0 {
        willSet {
            assert(newValue > 0)
        }
    }
    var maximumHeight = CGFloat.greatestFiniteMagnitude
    private(set) var contentView: CKMessagesToolbarContentView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView = CKMessagesToolbarContentView.viewFromNib()
        contentView.frame = frame
        addSubview(contentView)
        pinSubview(contentView)
        setNeedsUpdateConstraints()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textViewDidChange(_:)),
                                               name: Notification.Name.UITextViewTextDidChange,
                                               object: contentView.textView)
        
        contentView.leftView = nil
        contentView.rightView = nil
        
    }
    
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func textViewDidChange(_ notification: Notification) {
        
    }
    
    

}

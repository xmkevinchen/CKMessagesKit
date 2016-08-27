//
//  CKMessageViewCell.swift
//  CKMessagesViewController
//
//  Created by Chen Kevin on 8/27/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import UIKit

class CKMessageViewCell: CKMessageDataViewCell {
            
    let textView: CKMessageCellTextView = CKMessageCellTextView()

    override init(frame: CGRect) {
        super.init(frame: frame)        
        attach(hostedView: textView)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        attach(hostedView: textView)
    }
        
}

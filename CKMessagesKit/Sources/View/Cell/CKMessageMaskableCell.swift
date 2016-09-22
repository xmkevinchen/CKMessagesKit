//
//  CKMessageMaskCell.swift
//  CKMessagesKit
//
//  Created by Kevin Chen on 9/18/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import UIKit

class CKMessageMaskableCell: CKMessageBasicCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
    
        if let messageView = messageView {
            CKMessagesBubbleImageMasker.apply(to: messageView, orientation: orientation, size: messageSize)
        }
    }
    
    
}

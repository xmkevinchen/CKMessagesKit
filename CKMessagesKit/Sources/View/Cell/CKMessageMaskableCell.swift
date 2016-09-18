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
    
        CKMessagesBubbleImageMasker.apply(to: messageContainerView, orientation: orientation, size: messageSize)
    }
    
    
}

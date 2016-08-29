//
//  CKMessageHostedViewCell.swift
//  CKMessagesViewController
//
//  Created by Kevin Chen on 8/29/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import UIKit

class CKMessageHostedViewCell: CKMessageDataViewCell {
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        if let attributes = layoutAttributes as? CKMessagesCollectionViewLayoutAttributes {
            
            messageContentInsets = attributes.messageContentInsets
            
        }
    }
}

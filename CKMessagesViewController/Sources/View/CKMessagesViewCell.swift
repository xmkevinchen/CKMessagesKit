//
//  CKMessagesViewCell.swift
//  CKCollectionViewForDataCard
//
//  Created by Chen Kevin on 8/24/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import UIKit



open class CKMessagesViewCell: UICollectionViewCell, CKMessageCell {
    
    static open func nib() -> UINib {
        return UINib(nibName: String(describing: CKMessagesViewCell.self),
                     bundle: Bundle(for: CKMessagesViewCell.self))
    }
    
    static open func identifier() -> String {
        return String(describing: CKMessagesViewCell.self)
    }
    
}

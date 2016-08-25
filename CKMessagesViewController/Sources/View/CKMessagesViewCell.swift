//
//  CKMessagesViewCell.swift
//  CKMessagesViewController
//
//  Created by Kevin Chen on 8/24/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import UIKit

open class CKMessagesViewCell: UICollectionViewCell {
    
    var messageView: UIView? {
        
        willSet {
            
            if newValue == nil {
                messageView?.removeFromSuperview()
            }
        }
        
        didSet {
            
            if let view = messageView {
                view.translatesAutoresizingMaskIntoConstraints = false
                contentView.addSubview(view)
                contentView.clipsToBounds = true
                
                view.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
                view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
                view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
                view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
            }
        }
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        messageView = nil
    }
        
    
}

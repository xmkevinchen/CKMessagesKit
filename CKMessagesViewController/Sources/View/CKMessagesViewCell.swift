//
//  CKMessagesViewCell.swift
//  CKMessagesViewController
//
//  Created by Kevin Chen on 8/24/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import UIKit


class CKMessagePresentingView: UIView {
    
}


open class CKMessagesViewCell: UICollectionViewCell {
    
    private var hostedView: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        contentView.clipsToBounds = true
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        hostedView = nil
        
        
    }
    
    func attach(hostedView: UIView) {
        self.hostedView = hostedView
        
        contentView.addSubview(hostedView)
        
        hostedView.translatesAutoresizingMaskIntoConstraints = false
        hostedView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        hostedView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        hostedView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        hostedView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true

    }
    
    
}

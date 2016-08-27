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
        
    private var messagesView: CKMessagesView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
                
    }
    
    private func configure() {
        messagesView = CKMessagesView(frame: frame)
        contentView.clipsToBounds = true
        contentView.addSubview(messagesView)
        messagesView.translatesAutoresizingMaskIntoConstraints = false
        messagesView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        messagesView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        messagesView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        messagesView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true

        
    }
    
    public func attach(hostedView: UIView) {
                
        messagesView.contentView.addSubview(hostedView)
        
        hostedView.translatesAutoresizingMaskIntoConstraints = false
        hostedView.topAnchor.constraint(equalTo: messagesView.contentView.topAnchor).isActive = true
        hostedView.bottomAnchor.constraint(equalTo: messagesView.contentView.bottomAnchor).isActive = true
        hostedView.leadingAnchor.constraint(equalTo: messagesView.contentView.leadingAnchor).isActive = true
        hostedView.trailingAnchor.constraint(equalTo: messagesView.contentView.trailingAnchor).isActive = true
        
        contentView.updateConstraints()
        contentView.setNeedsLayout()
        contentView.layoutIfNeeded()
        
    }
    
    public var topLabel: CKInsetsLabel {
        return messagesView.topLabel
    }
    
    public var messageTopLabel: CKInsetsLabel {
        return messagesView.messageTopLabel
    }
    
    public var bottomLabel: CKInsetsLabel {
        return messagesView.bottomLabel
    }
    
    
    var avatarSize: CGSize {
        
        get {
            return messagesView.avatarSize
        }
        
        set {
            messagesView.avatarSize = avatarSize
        }
    }
    
    public var avatarView: UIImageView {
        return messagesView.avatarView
    }
    
    public var accessoryView: UIView? {
        get {
            return messagesView.accessoryView
        }
        
        set {
            messagesView.accessoryView = newValue
        }
    }
    
}

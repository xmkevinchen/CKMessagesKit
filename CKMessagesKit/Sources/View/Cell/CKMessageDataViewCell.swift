//
//  CKMessagesViewCell.swift
//  CKMessagesViewController
//
//  Created by Kevin Chen on 8/24/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import UIKit
import Reusable

class CKMessagePresentingView: UIView {
  
    
}


open class CKMessageDataViewCell: UICollectionViewCell, Reusable {
                
    private weak var messageView: CKMessageView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
    required public init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        configure()
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        messageView.prepareForReuse()
                
    }
    
    open override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        if let attributes = layoutAttributes as? CKMessagesViewLayoutAttributes {
                                    
            if attributes.avatarPosition == .left {
                messageView.avatarSize = attributes.incomingAvatarSize
            } else {
                messageView.avatarSize = attributes.outgoingAvatarSize
            }
            
            messageView.updateContentLayout(with: attributes.messageContentInsets,
                                            size: attributes.messageContentSize)
            
        }
        
    }
    
    
    
    
    private func configure() {
        
        messageView = UINib(nibName: String(describing:CKMessageView.self),
                            bundle: Bundle(for: CKMessageView.self))
            .instantiate(withOwner: nil, options: nil).last as? CKMessageView
        
        assert(messageView != nil)        
        
        messageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(messageView)
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[m]-0-|", options: [], metrics: nil, views: ["m": messageView]))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[m]-0-|", options: [], metrics: nil, views: ["m": messageView]))
        
        
        
    }
    
    


    
    public func attach(hostedView: UIView) {
        messageView.attach(hostedView: hostedView)
    }
    
    
    
    public var avatarSize: CGSize {
        get {
            return messageView.avatarSize
        }
        
        set {
            messageView.avatarSize = newValue
        }
    }
    
    public var avatarImageView: UIImageView {
        return messageView.avatarImageView
    }
    
    public var topLabel: UILabel {
        return messageView.topLabel
    }
    
    public var messageTopLabel: CKInsetsLabel {
        return messageView.messageTopLabel
    }
    
    public var bottomLabel: UILabel {
        return messageView.bottomLabel
    }
    
    public var messageBubbleImageView: UIImageView {
        return messageView.messageBubbleImageView
    }
    
    public var accessoryView: UIView? {
        get {
            return messageView.accessoryView
        }
        
        set {
            messageView.accessoryView = newValue
        }
    }
    
    public var direction: CKMessageDirection {
        get {
            return messageView.direction
        }
        
        set {
            messageView.direction = newValue
        }
    }
    
    
}

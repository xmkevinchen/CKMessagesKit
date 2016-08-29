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


open class CKMessageDataViewCell: UICollectionViewCell {
                
    private weak var messageView: CKMessageView!
    private weak var hostedView: UIView?
    
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
        hostedView = nil
        messageView.prepareForReuse()
                
    }
    
    open override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        if let attributes = layoutAttributes as? CKMessagesCollectionViewLayoutAttributes {
            
            messageView.contentInsets = attributes.contentViewInsets
            
            if messageView.direction == .incoming {
                messageView.avatarSize = attributes.incomingAvatarSize
            } else {
                messageView.avatarSize = attributes.outgoingAvatarSize
            }
            
            messageContainerViewWidthConstraint.constant = attributes.messageContainerWidth
        }
        
    }
    
    public var messageContainerViewWidthConstraint: NSLayoutConstraint {
        return messageView.messageContainerViewWidthConstraint
    }
    
    private func configure() {
        
        messageView = UINib(nibName: String(describing:CKMessageView.self),
                            bundle: Bundle(for: CKMessageView.self))
            .instantiate(withOwner: nil, options: nil).last as? CKMessageView
        
        assert(messageView != nil)
        messageView.prepareForReuse()
        
        messageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(messageView)
        
        if #available(iOS 9, *) {
            
            messageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
            messageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
            messageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
            messageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
            
        } else {
                        
            contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[m]-0-|", options: [], metrics: nil, views: ["m": messageView]))
            contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[m]-0-|", options: [], metrics: nil, views: ["m": messageView]))
            
        }
        
    }
    
    
    var messageContentInsets: UIEdgeInsets = .zero {
        didSet {
            guard messageContentInsets != oldValue else {
                return
            }
            
            if let hostedView = self.hostedView {
                
                let metrics = [
                    "t" : messageContentInsets.top,
                    "l" : messageContentInsets.left,
                    "b" : messageContentInsets.bottom,
                    "r" : messageContentInsets.right
                ]
                
                messageView.contentView.removeConstraints(messageView.contentView.constraints)
                
                messageView.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-l-[v]-r-|", options: [], metrics: metrics, views: ["v": hostedView]))
                messageView.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-t-[v]-b-|", options: [], metrics: metrics, views: ["v": hostedView]))
            }

        }
    }
    
    public func attach(hostedView: UIView) {
        self.hostedView = hostedView
        messageView.contentView.addSubview(hostedView)
        
        hostedView.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        let metrics = [
            "t" : messageContentInsets.top,
            "l" : messageContentInsets.left,
            "b" : messageContentInsets.bottom,
            "r" : messageContentInsets.right
        ]
        
        
        messageView.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-l-[v]-r-|", options: [], metrics: metrics, views: ["v": hostedView]))
        messageView.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-t-[v]-b-|", options: [], metrics: metrics, views: ["v": hostedView]))
        
        
        
    }
    
    public var avatarSize: CGSize {
        get {
            return messageView.avatarSize
        }
        
        set {
            messageView.avatarSize = newValue
        }
    }
    
    public var topLabel: UILabel {
        return messageView.topLabel
    }
    
    public var messageTopLabel: UILabel {
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

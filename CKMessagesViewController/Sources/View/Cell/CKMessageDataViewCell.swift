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
    
    private func configure() {
        
        messageView = UINib(nibName: String(describing:CKMessageView.self),
                            bundle: Bundle(for: CKMessageView.self))
            .instantiate(withOwner: nil, options: nil).last as? CKMessageView
        
        assert(messageView != nil)
        messageView.prepareForReuse()
        
        contentView.addSubview(messageView)
        messageView.translatesAutoresizingMaskIntoConstraints = false
        
        if #available(iOS 9, *) {
            
            messageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
            messageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
            messageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
            messageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
            
        } else {
                        
            contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[m]|", options: [], metrics: nil, views: ["m": messageView]))
            contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[m]|", options: [], metrics: nil, views: ["m": messageView]))
            
        }
        
        avatarSize = .zero
        
    }
    
    public func attach(hostedView: UIView) {
        
        messageView.contentView.addSubview(hostedView)
        
        hostedView.translatesAutoresizingMaskIntoConstraints = false
        
        if #available(iOS 9, *) {
            
            hostedView.topAnchor.constraint(equalTo: messageView.contentView.topAnchor).isActive = true
            hostedView.bottomAnchor.constraint(equalTo: messageView.contentView.bottomAnchor).isActive = true
            hostedView.leadingAnchor.constraint(equalTo: messageView.contentView.leadingAnchor).isActive = true
            hostedView.trailingAnchor.constraint(equalTo: messageView.contentView.trailingAnchor).isActive = true
            
        } else {
            
            messageView.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v]|", options: [], metrics: nil, views: ["v": hostedView]))
            messageView.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v]|", options: [], metrics: nil, views: ["v": hostedView]))
            
        }
        
        
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

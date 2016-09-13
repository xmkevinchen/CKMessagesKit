//
//  CKMessageBasicCell.swift
//  CKMessagesKit
//
//  Created by Kevin Chen on 9/10/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import UIKit
import Reusable

class CKMessageBubbleContainerView: UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

class CKMessageContainerView: UIView {
    
}


open class CKMessageBasicCell: UICollectionViewCell, Reusable {
    
    public enum MessageOrientation {
        case incoming
        case outgoing
    }
    
    
    
    /// Public outlets
    @IBOutlet public weak var topLabel: CKMessageInsetsLabel!
    @IBOutlet public weak var bubbleTopLabel: CKMessageInsetsLabel!
    @IBOutlet public weak var bottomLabel: CKMessageInsetsLabel!
    @IBOutlet public weak var avatarImageView: UIImageView!
    @IBOutlet public weak var bubbleImageView: UIImageView!
    
    
    /// Internal outlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var avatarContainerView: UIView!
    @IBOutlet weak var messageBubbleContainerView: CKMessageBubbleContainerView!
    @IBOutlet weak var messageContainerView: CKMessageContainerView!
    
    @IBOutlet weak var accessoryContainerView: UIView!
    
    /// MARK: - Constraints
    
    @IBOutlet weak var topLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bubbleTopLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomLabelHeightConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var avatarImageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var avatarImageViewHeightConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var accessoryContainerViewWidthConstraint: NSLayoutConstraint!
    
    private var messageViewConstraints: MessageViewConstraints?
    private var containerViewConstraints: ContainerViewConstraints!
    
    /// MARK: - Overrides
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        pinSubview(contentView)
        
        let nib = UINib(nibName: String(describing: CKMessageBasicCell.self), bundle: Bundle(for: CKMessageBasicCell.self))
        if let proxyView = nib.instantiate(withOwner: self, options: nil).first as? UIView {
            proxyView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(proxyView)
            contentView.pinSubview(proxyView)
            containerViewConstraints = ContainerViewConstraints(avatar: avatarContainerView,
                                                                message: messageBubbleContainerView,
                                                                accessory: accessoryContainerView)
            NSLayoutConstraint.activate(containerViewConstraints.incoming)
            
            
        } else {
            fatalError("====> Unable to instantiate CKMessageBasicCell outlets from nib: \(nib)")
        }
        
        configure()
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        configure()
        
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    override open func prepareForReuse() {
        super.prepareForReuse()
        
        topLabel.text = nil
        bubbleTopLabel.text = nil
        bottomLabel.text = nil
        avatarImageView.image = nil
        avatarImageView.highlightedImage = nil
        bubbleImageView.image = nil
        bubbleImageView.highlightedImage = nil
    }
    
    open override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        if let attributes = layoutAttributes as? CKMessagesViewLayoutAttributes {
            
            guard attributes.representedElementCategory == .cell else {
                return
            }
            
            topLabelHeightConstraint.constant = attributes.topLabelHeight
            bubbleTopLabelHeightConstraint.constant = attributes.bubbleTopLabelHeight
            bottomLabelHeightConstraint.constant = attributes.bottomLabelHeight
            
            self.orientation = attributes.avatarPosition == .left ? .incoming : .outgoing
            self.avatarSize = (orientation == .incoming) ? attributes.incomingAvatarSize : attributes.outgoingAvatarSize
            self.messageSize = attributes.messageSize
            self.messageInsets = attributes.messageInsets
            
            layout()
            setNeedsLayout()
        }
        
    }
    
    private func layout() {
        
        // Avatar
        if avatarSize.width != avatarImageViewWidthConstraint.constant {
            avatarImageViewWidthConstraint.constant = avatarSize.width
        }
        
        if avatarSize.height != avatarImageViewHeightConstraint.constant {
            avatarImageViewHeightConstraint.constant = avatarSize.height
        }
        
        
        // Message
        
        if let messageView = messageView {
            if messageView.superview === messageContainerView {
                
//                var constraints: MessageViewConstraints! = messageViewConstraints
//                if constraints == nil {
//                    constraints = MessageViewConstraints(target: messageView, superview: messageContainerView, insets: messageInsets, size: messageSize)
//                    messageViewConstraints = constraints
//                } else {
//                    NSLayoutConstraint.deactivate(constraints.constraints)
//                }
//                
//                messageContainerView.removeConstraints(messageContainerView.constraints)
//                
//                if constraints.size != messageSize {
//                    constraints.width.constant = messageSize.width
//                    constraints.height.constant = messageSize.height
//                    constraints.size = messageSize
//                }
//                
//                if constraints.insets != messageInsets || containerViewConstraints.actived != orientation {
//                    
//                    constraints.top.constant = messageInsets.top
//                    constraints.bottom.constant = messageInsets.bottom
//                    
//                    var leading = messageInsets.left
//                    var trailing = messageInsets.right
//                    
//                    switch orientation {
//                    case .incoming:
//                        leading += bubbleTailHorizontalSpace
//                        
//                    case .outgoing:
//                        trailing += bubbleTailHorizontalSpace
//                    }
//                    
//                    
//                    constraints.leading.constant = leading
//                    constraints.trailing.constant = trailing
//                    
//                    constraints.insets = messageInsets
//                }
//                
//                NSLayoutConstraint.activate(constraints.constraints)
                
                
                // TODO: - Figure out why the code above doesn't work
                
                
                let metrics = [
                    "t" : messageInsets.top,
                    "b" : messageInsets.bottom,
                    "l" : messageInsets.left,
                    "r" : messageInsets.right,
                    "width": messageSize.width,
                    "height": messageSize.height
                ]
                
                messageContainerView.removeConstraints(messageContainerView.constraints)
                
                messageContainerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-l-[v(width@999)]-r-|",
                                                                          options: [],
                                                                          metrics: metrics,
                                                                          views: ["v": messageView]))
                messageContainerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-t-[v(height@999)]-b@999-|",
                                                                          options: [],
                                                                          metrics: metrics,
                                                                          views: ["v": messageView]))

                
            }
        }
        
        
        if containerViewConstraints.actived != orientation {
            
            // Orientation
            switch orientation {
            case .incoming:
                NSLayoutConstraint.deactivate(containerViewConstraints.outgoing)
                NSLayoutConstraint.activate(containerViewConstraints.incoming)
                containerViewConstraints.actived = .incoming
                
            case .outgoing:
                NSLayoutConstraint.deactivate(containerViewConstraints.incoming)
                NSLayoutConstraint.activate(containerViewConstraints.outgoing)
                containerViewConstraints.actived = .outgoing
                
            }
        }
        
    }
    
    
    open override func updateConstraints() {
        
        super.updateConstraints()
    }
    
    public weak var messageView: UIView? {
        
        
        didSet {
            
            if let messageView = messageView {
                messageContainerView.addSubview(messageView)
                messageView.translatesAutoresizingMaskIntoConstraints = false
                layout()
            }
            
        }
        
    }
    
    public var accessoryView: UIView?
    
    
    // MARK: - Adjustable Layout properties
    
    
    /// The orientation of message, Default is incoming
    public var orientation: MessageOrientation = .incoming
    
    
    /// The size of avatar, Default is CGSize.zero
    public var avatarSize: CGSize = .zero
        
    /// The insets of message inside of the message bubble, besides the `bubbleTailWidth`
    ///
    /// So when message orientatin is
    ///
    /// * incoming -- The total insets.left = `messageInsets.left + bubbleTailWidth`
    /// * outgoing -- The total insets.right = `messageInset.right + bubbleTailWidth`
    public var messageInsets: UIEdgeInsets = .zero
    
    
    /// The size of message to `messageView`
    public var messageSize: CGSize = .zero
    
    private func configure() {
        
        
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        avatarContainerView.translatesAutoresizingMaskIntoConstraints = false
        messageBubbleContainerView.translatesAutoresizingMaskIntoConstraints = false
        accessoryContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        topLabel.text = nil
        topLabel.attributedText = nil
        topLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        topLabel.textAlignment = .center
        topLabel.textColor = UIColor.lightGray
        topLabel.numberOfLines = 0
        
        bubbleTopLabel.text = nil
        bubbleTopLabel.attributedText = nil
        bubbleTopLabel.font = UIFont.preferredFont(forTextStyle: .caption2)
        bubbleTopLabel.textAlignment = .left
        bubbleTopLabel.textColor = UIColor.lightGray
        bubbleTopLabel.numberOfLines = 0
        
        bottomLabel.text = nil
        bottomLabel.attributedText = nil
        bottomLabel.font = UIFont.preferredFont(forTextStyle: .caption2)
        bottomLabel.textAlignment = .left
        bottomLabel.textColor = UIColor.lightGray
        bottomLabel.numberOfLines = 0
        
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        containerView.backgroundColor = UIColor.clear
        avatarContainerView.backgroundColor = UIColor.clear
        accessoryContainerView.backgroundColor = UIColor.clear
        
        contentView.clipsToBounds = true
        messageBubbleContainerView.clipsToBounds = true
        
        updateConstraints()
    }
    
    
    
    // MARK:- Layout Convenience Holder
    
    
    /// A convenience data struct to hold two groups of `containerView` layout constraints
    private class ContainerViewConstraints {
        
        var avatar: UIView
        var message: UIView
        var accessory: UIView
        
        var actived: MessageOrientation?
        
        lazy var incoming: [NSLayoutConstraint] = {
            
            return NSLayoutConstraint.constraints(withVisualFormat: "H:|[avatar][message][accessory]-(>=0)-|",
                                                  options: [],
                                                  metrics: nil,
                                                  views: ["avatar": self.avatar,
                                                          "message": self.message,
                                                          "accessory": self.accessory])
            
        }()
        
        lazy var outgoing: [NSLayoutConstraint] = {
            return NSLayoutConstraint.constraints(withVisualFormat: "H:|-(>=0)-[accessory][message][avatar]|",
                                                  options: [],
                                                  metrics: nil,
                                                  views: ["avatar": self.avatar,
                                                          "message": self.message,
                                                          "accessory": self.accessory])
        }()
        
        init(avatar: UIView, message: UIView, accessory: UIView) {
            self.avatar = avatar
            self.message = message
            self.accessory = accessory
        }
        
    }
    
    
    
    /// Convenience constraints class for holding all constraints of messageView
    private class MessageViewConstraints {
        
        var width: NSLayoutConstraint
        var height: NSLayoutConstraint
        var leading: NSLayoutConstraint
        var trailing: NSLayoutConstraint
        var top: NSLayoutConstraint
        var bottom: NSLayoutConstraint
        
        var size: CGSize
        var insets: UIEdgeInsets
        
        
        init(target: UIView, superview: UIView, insets: UIEdgeInsets = .zero, size: CGSize = .zero) {
            
            self.size = size
            self.insets = insets
            
            width = NSLayoutConstraint(item: target, attribute: .width,
                                       relatedBy: .equal,
                                       toItem: nil, attribute: .notAnAttribute,
                                       multiplier: 1.0, constant: size.width)
            width.priority = 999
            
            height = NSLayoutConstraint(item: target, attribute: .height,
                                        relatedBy: .equal,
                                        toItem: nil, attribute: .notAnAttribute,
                                        multiplier: 1.0, constant: size.height)
            height.priority = 999
            
            
            top = NSLayoutConstraint(item: target, attribute: .top,
                                     relatedBy: .equal,
                                     toItem: superview, attribute: .top,
                                     multiplier: 1.0, constant: insets.top)
            
            bottom = NSLayoutConstraint(item: target, attribute: .bottom,
                                        relatedBy: .equal,
                                        toItem: superview, attribute: .bottom,
                                        multiplier: 1.0, constant: insets.bottom)
            
            leading = NSLayoutConstraint(item: target, attribute: .leading,
                                         relatedBy: .equal,
                                         toItem: superview, attribute: .leading,
                                         multiplier: 1.0, constant: insets.left)
            
            trailing = NSLayoutConstraint(item: target, attribute: .trailing,
                                          relatedBy: .equal,
                                          toItem: superview, attribute: .trailing,
                                          multiplier: 1.0, constant: insets.right)
            trailing.priority = 999
        }
        
        
        /// All assigned value constraints, ignore nil value properties
        var constraints: [NSLayoutConstraint]  {
            
            return [top, leading, bottom, trailing, width, height]
        }
    }
    
}

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
    @IBOutlet weak var accessoryContainerView: UIView!
    
    /// MARK: - Constraints
    
    @IBOutlet weak var topLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bubbleTopLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomLabelHeightConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var avatarImageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var avatarImageViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var accessoryContainerViewWidthConstraint: NSLayoutConstraint!
    
    private var messageViewConstraints: MessageViewConstraints?
    
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
            
            layout(with: attributes)
        }
        
    }
    
    open func layout(with attributes: CKMessagesViewLayoutAttributes) {
        
        topLabelHeightConstraint.constant = attributes.topLabelHeight
        bubbleTopLabelHeightConstraint.constant = attributes.bubbleTopLabelHeight
        bottomLabelHeightConstraint.constant = attributes.bottomLabelHeight
        
        let orientation: MessageOrientation = attributes.avatarPosition == .left ? .incoming : .outgoing
        let messageSize = attributes.messageSize
        let messageInsets = attributes.messageInsets
        
        let avatarSize = orientation == .incoming ? attributes.incomingAvatarSize : attributes.outgoingAvatarSize
        
        avatarImageViewWidthConstraint.constant = avatarSize.width
        avatarImageViewHeightConstraint.constant = avatarSize.height
        
        
        if orientation != self.orientation {
            layout(with: orientation)
        }
        
        guard let messageView = messageView else {
            return
        }
        
        messageBubbleContainerView.removeConstraints(
            messageBubbleContainerView.constraints
                .filter { $0.firstItem === messageView || $0.secondItem === messageView })
        
        var leading = messageInsets.left
        var trailing = messageInsets.right
        switch orientation {
        case .incoming:
            leading += bubbleTailHorizontalSpace
            
        case .outgoing:
            trailing += bubbleTailHorizontalSpace
        }
        
        let metrics = [
            "t" : messageInsets.top,
            "b" : messageInsets.bottom,
            "l" : leading,
            "r" : trailing,
            "width": messageSize.width,
            "height": messageSize.height
        ]
        
        messageBubbleContainerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-l-[v(width@999)]-r-|",
                                                                  options: [],
                                                                  metrics: metrics,
                                                                  views: ["v": messageView]))
        messageBubbleContainerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-t-[v(height@999)]-b@999-|",
                                                                  options: [],
                                                                  metrics: metrics,
                                                                  views: ["v": messageView]))
        
        setNeedsUpdateConstraints()
        setNeedsLayout()
        
        
    }
    
    public var avatarSize: CGSize = .zero {
        didSet {
            
            guard avatarSize != oldValue else {
                return
            }
            
            
            avatarImageViewWidthConstraint.constant = avatarSize.width
            avatarImageViewHeightConstraint.constant = avatarSize.height
            
            setNeedsLayout()
        }
    }
    
    
    
    public var orientation: MessageOrientation = .incoming
    {
        
        didSet {
            guard orientation != oldValue else {
                return
            }
            
            layout(with: orientation)
        }
    }
    
    
    
    /// The bubble tail to its body horizontal space, Default value is 6.0
    public var bubbleTailHorizontalSpace: CGFloat = 6.0
//    {
//        
//        didSet {
//            
//            guard bubbleTailHorizontalSpace != oldValue && messageView != nil && messageViewConstraints != nil else {
//                return
//            }
//            
//            
//            switch orientation {
//            case .incoming:
//                
//                messageViewConstraints?.leading?.constant = (bubbleTailHorizontalSpace + messageInsets.left)
//                
//            case .outgoing:
//                
//                messageViewConstraints?.trailing?.constant = (bubbleTailHorizontalSpace + messageInsets.right)
//            }
//            
//            
//            messageBubbleContainerView.setNeedsLayout()
//            setNeedsLayout()
//            
//        }
//    }
    
    public var messageView: UIView? {
        
        
        didSet {
            
            if let messageView = messageView {
                
                messageBubbleContainerView.addSubview(messageView)
                messageView.translatesAutoresizingMaskIntoConstraints = false
                
                
//                let constraints = MessageViewConstraints()
//                
//                constraints.width = NSLayoutConstraint(item: messageView,
//                                                       attribute: .width,
//                                                       relatedBy: .equal,
//                                                       toItem: nil,
//                                                       attribute: .notAnAttribute,
//                                                       multiplier: 1.0,
//                                                       constant: messageSize.width)
//
//                
//                constraints.height = NSLayoutConstraint(item: messageView,
//                                                        attribute: .height,
//                                                        relatedBy: .equal,
//                                                        toItem: nil,
//                                                        attribute: .notAnAttribute,
//                                                        multiplier: 1.0,
//                                                        constant: messageSize.height)
//                constraints.height?.priority = 999
//                
//                
//                constraints.top = NSLayoutConstraint(item: messageView,
//                                                     attribute: .top,
//                                                     relatedBy: .equal,
//                                                     toItem: messageBubbleContainerView,
//                                                     attribute: .top,
//                                                     multiplier: 1.0,
//                                                     constant: messageInsets.top)
//                
//                constraints.bottom = NSLayoutConstraint(item: messageView,
//                                                        attribute: .bottom,
//                                                        relatedBy: .equal,
//                                                        toItem: messageBubbleContainerView,
//                                                        attribute: .bottom,
//                                                        multiplier: 1.0,
//                                                        constant: messageInsets.bottom)
//                
//                
//                var leadingConstant = messageInsets.left
//                var trailingConstant = messageInsets.right
//                
//                switch orientation {
//                case .incoming:
//                    leadingConstant += bubbleTailHorizontalSpace
//                    
//                case .outgoing:
//                    trailingConstant += bubbleTailHorizontalSpace
//                    
//                }
//                
//                constraints.leading = NSLayoutConstraint(item: messageView,
//                                                         attribute: .leading,
//                                                         relatedBy: .equal,
//                                                         toItem: messageBubbleContainerView,
//                                                         attribute: .leading,
//                                                         multiplier: 1.0,
//                                                         constant: leadingConstant)
//                constraints.trailing = NSLayoutConstraint(item: messageView,
//                                                          attribute: .trailing,
//                                                          relatedBy: .equal,
//                                                          toItem: messageBubbleContainerView,
//                                                          attribute: .trailing,
//                                                          multiplier: 1.0,
//                                                          constant: trailingConstant)
//                
//                messageViewConstraints = constraints
//                
//                NSLayoutConstraint.activate(constraints.constraints)
//                setNeedsLayout()
                
            } else {
//                if messageViewConstraints != nil {
//                    NSLayoutConstraint.deactivate(messageViewConstraints!.constraints)
//                    messageViewConstraints = nil
//                    setNeedsLayout()
//                }
            }
            
        }
        
    }
    
    
    /// The insets of message inside of the message bubble, besides the `bubbleTailWidth`
    ///
    /// So when message orientatin is
    ///
    /// * incoming -- The total insets.left = `messageInsets.left + bubbleTailWidth`
    /// * outgoing -- The total insets.right = `messageInset.right + bubbleTailWidth`
    public var messageInsets: UIEdgeInsets = .zero
//    {
//        
//        didSet {
//            
//            guard messageView != nil && messageInsets != oldValue else {
//                return
//            }
//            
////            if let constraints = messageViewConstraints {
////                
////                constraints.top?.constant = messageInsets.top
////                constraints.bottom?.constant = messageInsets.bottom
////                constraints.leading?.constant = messageInsets.left
////                constraints.trailing?.constant = messageInsets.right
////                
////                switch orientation {
////                case .incoming:
////                    constraints.leading?.constant += bubbleTailHorizontalSpace
////                case .outgoing:
////                    constraints.trailing?.constant += bubbleTailHorizontalSpace
////                }
////                
////                
////                messageBubbleContainerView.setNeedsUpdateConstraints()
////                setNeedsUpdateConstraints()
////            }
//            let removingConstraints = messageBubbleContainerView.constraints.filter {
//                $0.firstItem === messageView || $0.secondItem === messageView
//            }
//            
//            messageBubbleContainerView.removeConstraints(removingConstraints)
//            messageView?.removeConstraints(messageView!.constraints)
//            
//            let constraints
//                = MessageViewConstraints(target: messageView!,
//                                         superview: messageBubbleContainerView,
//                                         insets: messageInsets,
//                                         size: messageSize,
//                                         orientation: orientation,
//                                         bubbleTailHorizontalSpace: bubbleTailHorizontalSpace)
//            
//            NSLayoutConstraint.activate(constraints.constraints)
//            setNeedsUpdateConstraints()
//            setNeedsLayout()
//            
//            
//        }
//    }
    
    public var messageSize: CGSize = .zero
//    {
//        didSet {
//            
//            guard messageSize != oldValue && messageView != nil else {
//                return
//            }
//            
////            messageViewConstraints?.width?.constant = messageSize.width
////            messageViewConstraints?.height?.constant = messageSize.height
////            
////            messageBubbleContainerView.setNeedsUpdateConstraints()
////            setNeedsUpdateConstraints()
//            
//            let removingConstraints = messageBubbleContainerView.constraints.filter {
//                $0.firstItem === messageView || $0.secondItem === messageView
//            }
//            
//            messageBubbleContainerView.removeConstraints(removingConstraints)
//            messageView?.removeConstraints(messageView!.constraints)
//            
//            let constraints
//                = MessageViewConstraints(target: messageView!,
//                                         superview: messageBubbleContainerView,
//                                         insets: messageInsets,
//                                         size: messageSize,
//                                         orientation: orientation,
//                                         bubbleTailHorizontalSpace: bubbleTailHorizontalSpace)
//            
//            NSLayoutConstraint.activate(constraints.constraints)
//            setNeedsUpdateConstraints()
//            setNeedsLayout()
//            
//            
//        }
//    }
    
    public var accessoryView: UIView?
    
    
    private func configure() {
        
        contentView.backgroundColor = UIColor.clear
        
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
        
        containerView.backgroundColor = UIColor.clear
        avatarContainerView.backgroundColor = UIColor.clear
        accessoryContainerView.backgroundColor = UIColor.clear
        
        contentView.clipsToBounds = true
        messageBubbleContainerView.clipsToBounds = true
        
        
        layout(with: orientation)
        
        
    }
    
    
    private func layout(with orientation: MessageOrientation) {
        
        let removingAttributes: [NSLayoutAttribute] = [.leading, .trailing]
        containerView.removeConstraints(
            containerView.constraints.filter { constraint in
                
                return (removingAttributes.contains(constraint.firstAttribute)
                    || removingAttributes.contains(constraint.secondAttribute))
            }
        )
        
        switch orientation {
        case .incoming:
            
            containerView.addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:|[avatar][message][accessory]-(>=0)-|",
                                               options: [],
                                               metrics: nil,
                                               views: [
                                                "avatar": avatarContainerView,
                                                "message": messageBubbleContainerView,
                                                "accessory": accessoryContainerView]))
            
            if let constraints = messageViewConstraints {
                constraints.leading?.constant = (bubbleTailHorizontalSpace + messageInsets.left)
                constraints.trailing?.constant = messageInsets.right
            }
            
            
            
        case .outgoing:
            
            containerView.addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:|-(>=0)-[accessory][message][avatar]|",
                                               options: [],
                                               metrics: nil,
                                               views: [
                                                "avatar": avatarContainerView,
                                                "message": messageBubbleContainerView,
                                                "accessory": accessoryContainerView]))

            
            if let constraints = messageViewConstraints {
                constraints.leading?.constant = messageInsets.left
                constraints.trailing?.constant = (bubbleTailHorizontalSpace + messageInsets.right)
            }
            
            
        }
        
        setNeedsUpdateConstraints()
        
        
    }
    
    
    /// Convenience constraints class for holding all constraints of messageView
    private class MessageViewConstraints: NSObject {
        
        var width: NSLayoutConstraint?
        var height: NSLayoutConstraint?
        var leading: NSLayoutConstraint?
        var trailing: NSLayoutConstraint?
        var top: NSLayoutConstraint?
        var bottom: NSLayoutConstraint?
        
        override init() {}
        
        init(target: UIView, superview: UIView, insets: UIEdgeInsets, size: CGSize, orientation: MessageOrientation, bubbleTailHorizontalSpace: CGFloat) {
            width = NSLayoutConstraint(item: target,
                                       attribute: .width,
                                       relatedBy: .equal,
                                       toItem: nil,
                                       attribute: .notAnAttribute,
                                       multiplier: 1.0,
                                       constant: size.width)
            
            
            height = NSLayoutConstraint(item: target,
                                        attribute: .height,
                                        relatedBy: .equal,
                                        toItem: nil,
                                        attribute: .notAnAttribute,
                                        multiplier: 1.0,
                                        constant: size.height)
            height?.priority = 999
            
            
            top = NSLayoutConstraint(item: target,
                                     attribute: .top,
                                     relatedBy: .equal,
                                     toItem: superview,
                                     attribute: .top,
                                     multiplier: 1.0,
                                     constant: insets.top)
            
            bottom = NSLayoutConstraint(item: target,
                                        attribute: .bottom,
                                        relatedBy: .equal,
                                        toItem: superview,
                                        attribute: .bottom,
                                        multiplier: 1.0,
                                        constant: insets.bottom)
            
            
            var leadingConstant = insets.left
            var trailingConstant = insets.right
            
            switch orientation {
            case .incoming:
                leadingConstant += bubbleTailHorizontalSpace
                
            case .outgoing:
                trailingConstant += bubbleTailHorizontalSpace
                
            }
            
            leading = NSLayoutConstraint(item: target,
                                         attribute: .leading,
                                         relatedBy: .equal,
                                         toItem: superview,
                                         attribute: .leading,
                                         multiplier: 1.0,
                                         constant: leadingConstant)
            trailing = NSLayoutConstraint(item: target,
                                          attribute: .trailing,
                                          relatedBy: .equal,
                                          toItem: superview,
                                          attribute: .trailing,
                                          multiplier: 1.0,
                                          constant: trailingConstant)
        }
        
        
        /// All assigned value constraints, ignore nil value properties
        var constraints: [NSLayoutConstraint]  {
            
            let mirror = Mirror(reflecting: self)
            
            var elements = [NSLayoutConstraint]()
            
            for (_, value) in mirror.children {
                if let value = value as? NSLayoutConstraint {
                    elements.append(value)
                }
            }
            
            return elements
        }
    }
    
}

//
//  CKMessageView.swift
//  CKMessagesViewController
//
//  Created by Kevin Chen on 8/26/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

public enum CKMessageDirection: String {
    case incoming
    case outgoing
}

//@IBDesignable
class CKMessageView: UIView {
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var messageTopLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var avatarContainerView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var messageContainerView: UIView!
    @IBOutlet weak var messageBubbleImageView: UIImageView!
    @IBOutlet weak var contentView: CKMessagePresentingView!
    
    @IBOutlet weak var accessoryContainerView: UIView!
    
    
    @IBOutlet weak var messageContainerViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentViewBottomConstraint: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        avatarContainerView.translatesAutoresizingMaskIntoConstraints = false
        messageContainerView.translatesAutoresizingMaskIntoConstraints = false
        accessoryContainerView.translatesAutoresizingMaskIntoConstraints = false
                        
        topLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        topLabel.textAlignment = .center
        topLabel.textColor = UIColor.lightGray
        topLabel.numberOfLines = 0
        
        messageTopLabel.font = UIFont.preferredFont(forTextStyle: .caption2)
        messageTopLabel.textAlignment = .center
        messageTopLabel.textColor = UIColor.lightGray
        messageTopLabel.numberOfLines = 0
        
        bottomLabel.font = UIFont.preferredFont(forTextStyle: .caption2)
        bottomLabel.textAlignment = .center
        bottomLabel.textColor = UIColor.lightGray
        bottomLabel.numberOfLines = 0
        
        
    }
    
//    @IBInspectable
    var direction: CKMessageDirection = .incoming {
        
        didSet {
            guard direction != oldValue else {
                return
            }
            
            let removingAttributes: [NSLayoutAttribute] = [.leading, .trailing]
            containerView.removeConstraints(
                containerView.constraints.filter { constraint in
                    
                    return (removingAttributes.contains(constraint.firstAttribute) || removingAttributes.contains(constraint.secondAttribute))
                }
            )
            
            switch direction {
            case .incoming:
                
                if #available(iOS 9, *) {
                    
                    avatarContainerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
                    avatarContainerView.trailingAnchor.constraint(equalTo: messageContainerView.leadingAnchor).isActive = true
                    
                    accessoryContainerView.leadingAnchor.constraint(equalTo: messageContainerView.trailingAnchor).isActive = true
                    accessoryContainerView.trailingAnchor.constraint(greaterThanOrEqualTo: containerView.trailingAnchor).isActive = true

                    
                } else {
                    
                    containerView.addConstraints(
                        NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[avatar][message(\(messageContainerViewWidthConstraint.constant))][accessory]-(>=0)-|",
                                                       options: [],
                                                       metrics: nil,
                                                       views: [
                                                        "avatar": avatarContainerView,
                                                        "message": messageContainerView,
                                                        "accessory": accessoryContainerView]))
                    
                }
                
            case .outgoing:
                
                if #available(iOS 9, *) {
                    
                    avatarContainerView.leadingAnchor.constraint(equalTo: messageContainerView.trailingAnchor).isActive = true
                    avatarContainerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
                    
                    accessoryContainerView.leadingAnchor.constraint(greaterThanOrEqualTo: containerView.leadingAnchor).isActive = true
                    accessoryContainerView.trailingAnchor.constraint(equalTo: messageContainerView.leadingAnchor).isActive = true

                    
                } else {
                    
                    containerView.addConstraints(
                        NSLayoutConstraint.constraints(withVisualFormat: "H:|-(>=0)-[accessory][message(\(messageContainerViewWidthConstraint.constant))][avatar]|",
                                                       options: [],
                                                       metrics: nil,
                                                       views: [
                                                        "avatar": avatarContainerView,
                                                        "message": messageContainerView,
                                                        "accessory": accessoryContainerView]))
                }
            }
            
            setNeedsLayout()
        }
    }
    
    var accessoryView: UIView? = nil {
        
        didSet {
            
            if let accessoryView = self.accessoryView {
                
                accessoryContainerView.addSubview(accessoryView)
                accessoryView.translatesAutoresizingMaskIntoConstraints = false
                
                if #available(iOS 9, *) {
                    
                    accessoryView.centerXAnchor.constraint(equalTo: accessoryContainerView.centerXAnchor).isActive = true
                    accessoryView.centerYAnchor.constraint(equalTo: accessoryContainerView.centerYAnchor).isActive = true
                    accessoryContainerView.widthAnchor.constraint(equalTo: accessoryView.widthAnchor)
                    
                    
                } else {
                    
                    accessoryContainerView.addConstraint(
                        NSLayoutConstraint(item: accessoryView,
                                           attribute: .centerX,
                                           relatedBy: .equal,
                                           toItem: accessoryContainerView,
                                           attribute: .centerX,
                                           multiplier: 1,
                                           constant: 1))
                    
                    accessoryContainerView.addConstraint(
                        NSLayoutConstraint(item: accessoryView,
                                           attribute: .centerY,
                                           relatedBy: .equal,
                                           toItem: accessoryContainerView,
                                           attribute: .centerY,
                                           multiplier: 1,
                                           constant: 1))
                    
                    accessoryContainerView.addConstraint(
                        NSLayoutConstraint(item: accessoryContainerView,
                        attribute: .width,
                        relatedBy: .equal,
                        toItem: accessoryView,
                        attribute: .width,
                        multiplier: 1,
                        constant: 1))
                    
                }
                
                
                
                
            } else {
                
                for view in accessoryContainerView.subviews {
                    view.removeFromSuperview()
                }
                
                accessoryContainerView.removeConstraints(accessoryContainerView.constraints)
                
                accessoryContainerView.addConstraint(
                    NSLayoutConstraint(item: accessoryView,
                                       attribute: .width,
                                       relatedBy: .equal,
                                       toItem: nil,
                                       attribute: .notAnAttribute,
                                       multiplier: 1.0,
                                       constant: 0.0))
                
                
                
            }
            
            setNeedsLayout()
            
            
            
        }
    }
    
    @IBInspectable
    var avatarSize: CGSize = CGSize(width: 36, height: 36) {
        
        didSet {
            
            guard avatarSize != oldValue else {
                return
            }
            
            let removingAttributes: [NSLayoutAttribute] = [.width, .height]
            avatarContainerView.removeConstraints(
                avatarContainerView.constraints.filter {
                    removingAttributes.contains($0.firstAttribute)
                }
            )
            
            if #available(iOS 9, *) {
                
                
                avatarImageView.widthAnchor.constraint(equalToConstant: avatarSize.width).isActive = true
                avatarImageView.heightAnchor.constraint(equalToConstant: avatarSize.width).isActive = true
                
            } else {
                
                avatarContainerView.addConstraint(
                    NSLayoutConstraint(item: avatarContainerView,
                                       attribute: .width,
                                       relatedBy: .equal,
                                       toItem: nil,
                                       attribute: .notAnAttribute,
                                       multiplier: 1.0,
                                       constant: avatarSize.width))
                
                avatarContainerView.addConstraint(
                    NSLayoutConstraint(item: avatarContainerView,
                                       attribute: .height,
                                       relatedBy: .equal,
                                       toItem: nil,
                                       attribute: .notAnAttribute,
                                       multiplier: 1.0,
                                       constant: avatarSize.height))
                
            }
        }
    }
    
    var contentInsets: UIEdgeInsets = .zero {
        didSet {
            guard contentInsets != oldValue else {
                return
            }
            
            contentViewTopConstraint.constant = contentInsets.top
            contentViewLeadingConstraint.constant = contentInsets.left
            contentViewTrailingConstraint.constant = contentInsets.right
            contentViewBottomConstraint.constant = contentInsets.bottom
            
            setNeedsLayout()
            
        }
    }
    
    func prepareForReuse() {
        topLabel.text = nil
        messageTopLabel.text = nil
        bottomLabel.text = nil
        avatarImageView.image = nil
        avatarImageView.highlightedImage = nil
    }
}

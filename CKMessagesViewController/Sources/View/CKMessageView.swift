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
    
    @IBOutlet weak var avatarWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var avatarHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var messageContainerViewWidthConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var contentViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentViewBottomConstraint: NSLayoutConstraint!
    
    private weak var hostedView: UIView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        translatesAutoresizingMaskIntoConstraints = false
        
                        
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
        
        backgroundColor = UIColor.clear
        containerView.backgroundColor = UIColor.clear
        avatarContainerView.backgroundColor = UIColor.clear
        messageContainerView.backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        accessoryContainerView.backgroundColor = UIColor.clear
        
        contentView.clipsToBounds = true
        
    }
    
    var messageContainerSize: CGSize {
        get {
            return messageContainerView.bounds.size
        }
        
        set {
            if newValue.width != messageContainerViewWidthConstraint.constant {
                messageContainerViewWidthConstraint.constant = newValue.width
            }
            
        }
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
                
                containerView.addConstraints(
                    NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[avatar][message][accessory]-(>=0)-|",
                                                   options: [],
                                                   metrics: nil,
                                                   views: [
                                                    "avatar": avatarContainerView,
                                                    "message": messageContainerView,
                                                    "accessory": accessoryContainerView]))
                
            case .outgoing:
                
                containerView.addConstraints(
                    NSLayoutConstraint.constraints(withVisualFormat: "H:|-(>=0)-[accessory][message][avatar]|",
                                                   options: [],
                                                   metrics: nil,
                                                   views: [
                                                    "avatar": avatarContainerView,
                                                    "message": messageContainerView,
                                                    "accessory": accessoryContainerView]))
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
    
//    @IBInspectable
    var avatarSize: CGSize = CGSize(width: 36, height: 36) {
        
        didSet {
            
            guard avatarSize != oldValue else {
                return
            }
            
            avatarWidthConstraint.constant = avatarSize.width
            avatarHeightConstraint.constant = avatarSize.height
        }
    }
    
    var contentInsets: UIEdgeInsets = .zero {
        didSet {
            guard contentInsets != oldValue else {
                return
            }
            
            contentViewTopConstraint.constant = contentInsets.top
            contentViewBottomConstraint.constant = contentInsets.bottom
//            contentViewLeadingConstraint.constant = contentInsets.left
//            contentViewTrailingConstraint.constant = contentInsets.right
            contentViewLeadingConstraint.constant = direction == .incoming ? contentInsets.left : 0
            contentViewTrailingConstraint.constant = direction == .outgoing ? contentInsets.right : 0
            
            
            
            setNeedsLayout()
            
        }
    }
    
    var messageContentInsets: UIEdgeInsets = .zero {
        
        didSet {
            guard messageContentInsets != oldValue && hostedView != nil else {
                return
            }
            
            let metrics = [
                "t" : messageContentInsets.top,
                "l" : messageContentInsets.left,
                "b" : messageContentInsets.bottom,
                "r" : messageContentInsets.right,
                "width": messageContentSize.width,
                "height": messageContentSize.height
            ]
            
            contentView.removeConstraints(contentView.constraints)
            
            contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-l-[v(width)]-r-|", options: [], metrics: metrics, views: ["v": hostedView!]))
            contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-t-[v(height)]-b-|", options: [], metrics: metrics, views: ["v": hostedView!]))
            
            
        }

    }
    
    var messageContentSize: CGSize = .zero {
        didSet {
            
            guard messageContentSize != oldValue && hostedView != nil else {
                return
            }
            
            let metrics = [
                "t" : messageContentInsets.top,
                "l" : messageContentInsets.left,
                "b" : messageContentInsets.bottom,
                "r" : messageContentInsets.right,
                "width": messageContentSize.width,
                "height": messageContentSize.height
            ]
            
            contentView.removeConstraints(contentView.constraints)
            
            contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-l-[v(width)]-r-|", options: [], metrics: metrics, views: ["v": hostedView!]))
            contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-t-[v(height)]-b-|", options: [], metrics: metrics, views: ["v": hostedView!]))

            
        }
    }
    

    
    func prepareForReuse() {
        topLabel.text = nil
        messageTopLabel.text = nil
        bottomLabel.text = nil
        avatarImageView.image = nil
        avatarImageView.highlightedImage = nil
        messageBubbleImageView.image = nil
        messageBubbleImageView.highlightedImage = nil
    }
    
    func attach(hostedView: UIView) {
        self.hostedView = hostedView
        hostedView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(hostedView)
        
        let metrics = [
            "t" : messageContentInsets.top,
            "l" : messageContentInsets.left,
            "b" : messageContentInsets.bottom,
            "r" : messageContentInsets.right,
        ]
        
        contentView.removeConstraints(contentView.constraints)
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-l-[v]-r-|", options: [], metrics: metrics, views: ["v": hostedView]))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-t-[v]-b-|", options: [], metrics: metrics, views: ["v": hostedView]))
        
    }
}

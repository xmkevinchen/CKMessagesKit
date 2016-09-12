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
    
    @IBOutlet weak var topLabel: CKMessageInsetsLabel!
    @IBOutlet weak var topLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageTopLabel: CKMessageInsetsLabel!
    @IBOutlet weak var messageTopLabelConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomLabel: CKMessageInsetsLabel!
    @IBOutlet weak var bottomLabelHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var avatarContainerView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var messageContainerView: UIView!
    @IBOutlet weak var messageBubbleImageView: UIImageView!
    @IBOutlet weak var contentView: CKMessagePresentingView!
    
    @IBOutlet weak var accessoryContainerView: UIView!
    
    @IBOutlet weak var avatarWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var avatarHeightConstraint: NSLayoutConstraint!
    
//    @IBOutlet weak var messageContainerViewWidthConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var contentViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentViewBottomConstraint: NSLayoutConstraint!
    
    private weak var hostedView: UIView?
    private var bubbleTrailWidth: CGFloat = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        avatarContainerView.translatesAutoresizingMaskIntoConstraints = false
        messageContainerView.translatesAutoresizingMaskIntoConstraints = false
        accessoryContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        topLabel.text = nil
        topLabel.attributedText = nil
        topLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        topLabel.textAlignment = .center
        topLabel.textColor = UIColor.lightGray
        topLabel.numberOfLines = 0
        topLabel.textInsets = UIEdgeInsets(top: 2.5, left: 0, bottom: 2.5, right: 0)
        
        messageTopLabel.text = nil
        messageTopLabel.attributedText = nil
        messageTopLabel.font = UIFont.preferredFont(forTextStyle: .caption2)
        messageTopLabel.textAlignment = .left
        messageTopLabel.textColor = UIColor.lightGray
        messageTopLabel.numberOfLines = 0
        messageTopLabel.textInsets = UIEdgeInsets(top: 2.5, left: 0, bottom: 2.5, right: 0)
        
        bottomLabel.text = nil
        bottomLabel.attributedText = nil
        bottomLabel.font = UIFont.preferredFont(forTextStyle: .caption2)
        bottomLabel.textAlignment = .left
        bottomLabel.textColor = UIColor.lightGray
        bottomLabel.numberOfLines = 0
        bottomLabel.textInsets = UIEdgeInsets(top: 2.5, left: 0, bottom: 2.5, right: 0)
        
        backgroundColor = UIColor.clear
        containerView.backgroundColor = UIColor.clear
        avatarContainerView.backgroundColor = UIColor.clear
        messageContainerView.backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        accessoryContainerView.backgroundColor = UIColor.clear
        
        contentView.clipsToBounds = true
        
        bubbleTrailWidth = contentViewLeadingConstraint.constant
        
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
                    NSLayoutConstraint.constraints(withVisualFormat: "H:|[avatar][message][accessory]-(>=0)-|",
                                                   options: [],
                                                   metrics: nil,
                                                   views: [
                                                    "avatar": avatarContainerView,
                                                    "message": messageContainerView,
                                                    "accessory": accessoryContainerView]))
                
                contentViewLeadingConstraint.constant = bubbleTrailWidth
                contentViewTrailingConstraint.constant = 0
                
            case .outgoing:
                
                containerView.addConstraints(
                    NSLayoutConstraint.constraints(withVisualFormat: "H:|-(>=0)-[accessory][message][avatar]|",
                                                   options: [],
                                                   metrics: nil,
                                                   views: [
                                                    "avatar": avatarContainerView,
                                                    "message": messageContainerView,
                                                    "accessory": accessoryContainerView]))
                
                contentViewLeadingConstraint.constant = 0
                contentViewTrailingConstraint.constant = bubbleTrailWidth
                
            }
            setNeedsUpdateConstraints()
            setNeedsLayout()
        }
    }
    
    var accessoryView: UIView? = nil {
        
        willSet {
            if accessoryView != nil {
                accessoryView?.removeFromSuperview()
            }
        }
        
        didSet {
            
            if let accessoryView = self.accessoryView {
                
                accessoryContainerView.addSubview(accessoryView)
                accessoryView.translatesAutoresizingMaskIntoConstraints = false
                
                
                
                accessoryContainerView.addConstraint(
                    NSLayoutConstraint(item: accessoryView,
                                       attribute: .centerX,
                                       relatedBy: .equal,
                                       toItem: accessoryContainerView,
                                       attribute: .centerX,
                                       multiplier: 1,
                                       constant: 0))
                
                accessoryContainerView.addConstraint(
                    NSLayoutConstraint(item: accessoryView,
                                       attribute: .centerY,
                                       relatedBy: .equal,
                                       toItem: accessoryContainerView,
                                       attribute: .centerY,
                                       multiplier: 1,
                                       constant: 0))
                
                accessoryContainerView.addConstraint(
                    NSLayoutConstraint(item: accessoryContainerView,
                                       attribute: .width,
                                       relatedBy: .equal,
                                       toItem: accessoryView,
                                       attribute: .width,
                                       multiplier: 1,
                                       constant: 0))
                
                
                
                
                
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
    var avatarSize: CGSize = CGSize(width: 30, height: 30) {
        
        didSet {
            
            guard avatarSize != oldValue else {
                return
            }
            
            avatarWidthConstraint.constant = avatarSize.width
            avatarHeightConstraint.constant = avatarSize.height
            setNeedsUpdateConstraints()
            setNeedsLayout()
        }
    }
    
    private var messageContentInsets: UIEdgeInsets = .zero
    private var messageContentSize: CGSize = .zero
    
    func updateContentLayout(insets: UIEdgeInsets, size: CGSize) {
        
        guard (insets != messageContentInsets || size != messageContentSize) else {
            return
        }
        
        messageContentInsets = insets
        messageContentSize = size
        
        layoutContentView()
        
    }
    
    func layoutContentView() {
        guard hostedView != nil && hostedView?.superview == contentView else {
            return
        }
                               
        let metrics = [
            "t" : messageContentInsets.top,
            "b" : messageContentInsets.bottom,
            "l" : messageContentInsets.left,
            "r" : messageContentInsets.right,
            "width": messageContentSize.width,
            "height": messageContentSize.height
        ]
        
        contentView.removeConstraints(contentView.constraints)
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-l-[v(width@999)]-r-|",
                                                                  options: [],
                                                                  metrics: metrics,
                                                                  views: ["v": hostedView!]))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-t-[v(height@999)]-b@999-|",
                                                                  options: [],
                                                                  metrics: metrics,
                                                                  views: ["v": hostedView!]))
        
        setNeedsUpdateConstraints()
        setNeedsLayout()
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
        
        layoutContentView()
        
        
    }
}

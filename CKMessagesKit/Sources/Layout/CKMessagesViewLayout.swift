//
//  CKMessagesViewLayout.swift
//  CKCollectionViewForDataCard
//
//  Created by Kevin Chen on 8/24/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import UIKit

public class CKMessagesViewLayout: UICollectionViewFlowLayout {
    
    public var messagesView: CKMessagesView {
        return collectionView! as! CKMessagesView
    }
    
    private let defaultAvatarSize: CGSize = CGSize(width: 30, height: 30)
    
    public var messageFont: UIFont = UIFont.preferredFont(forTextStyle: .body)
        {
        didSet {
            if messageFont != oldValue {
                invalidateLayout(with: CKMessagesViewLayoutInvalidationContext.context())
            }
        }
        
    }
    
    public var incomingAvatarSize: CGSize = .zero {
        didSet {
            if incomingAvatarSize != oldValue {
                resetLayout()
            }
        }
    }
    public var outgoingAvatarSize: CGSize = .zero {
        didSet {
            if outgoingAvatarSize != oldValue {
                resetLayout()
            }
        }
    }
    
    public var messageInsets: UIEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16) {
        didSet {
            if messageInsets != oldValue {
                resetLayout()
            }
        }
    }
    
    public var messageBubbleContainerMaximumWidth: CGFloat = 0.0 {
        
        didSet {
            if messageBubbleContainerMaximumWidth != oldValue {
                resetLayout()
            }
        }
    
    }

    
    public var messageSizeCalculator: CKMessageSizeCalculating = CKMessageSizeCalculator()
    
    
    
    // MARK: - Override
    override public class var layoutAttributesClass: Swift.AnyClass {
        return CKMessagesViewLayoutAttributes.self
    }
    
    override public class var invalidationContextClass: Swift.AnyClass {
        return CKMessagesViewLayoutInvalidationContext.self
    }
    
    override init() {
        super.init()
        configure()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init()
        configure()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    
    override public func prepare() {
        super.prepare()
        messageBubbleContainerMaximumWidth = reasonablemessageBubbleContainerMaximumWidth()
    }
    
    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        if let attributesForElements = super.layoutAttributesForElements(in: rect) as? [CKMessagesViewLayoutAttributes] {
            
            attributesForElements.forEach { attributes in
                
                if attributes.representedElementCategory == .cell {
                    configure(attributes: attributes)
                }
                
            }
            
            return attributesForElements
            
        } else {
            return nil
        }
        
    }
    
    override public func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if let attributes = super.layoutAttributesForItem(at: indexPath)?.copy() as? CKMessagesViewLayoutAttributes {
            if attributes.representedElementCategory == .cell {
                configure(attributes: attributes)
            }
            
            return attributes
        } else {
            return nil
        }
    }
    
    public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        
        if collectionView?.bounds != newBounds {
            return true
        }
        
        return false
    }
    
    public override func invalidateLayout(with context: UICollectionViewLayoutInvalidationContext) {
        
        super.invalidateLayout(with: context)
    }
    
    // MARK:- Public
    
    public func sizeForItem(at indexPath: IndexPath) -> CGSize {
        
        let message = messagesView.messenger?.messageForItem(at: indexPath, of: messagesView)
        let messageSize = size(of: message, at: indexPath)
                
        var height = messageSize.height + messageInsets.top + messageInsets.bottom
        
        if let attributes = layoutAttributesForItem(at: indexPath) as? CKMessagesViewLayoutAttributes {
            
            height += attributes.topLabelHeight
            height += attributes.bubbleTopLabelHeight
            height += attributes.bottomLabelHeight
            
        }
        
        return CGSize(width: itemWidth, height: ceil(height))
        
    }
    
    private func size(of message:CKMessageData?, at indexPath: IndexPath) -> CGSize {
        
        if let message = message {
            return messageSizeCalculator.size(of: message, at: indexPath, with: self)
        }
        
        return .zero
        
    }
    
    public var itemWidth: CGFloat {
        guard collectionView != nil else {
            return 0
        }
        
        return collectionView!.frame.width
            - collectionView!.contentInset.left - collectionView!.contentInset.right
            - sectionInset.left - sectionInset.right
    }
    

    
    // MARK:- Private
    private func configure() {
        scrollDirection = .vertical
        sectionInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        minimumLineSpacing = 5
                                
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didReceiveApplicationMemoryWarningNotification(_:)),
                                               name: Notification.Name.UIApplicationDidReceiveMemoryWarning,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didReceiveDeviceOrientationDidChangeNotification(_:)),
                                               name: Notification.Name.UIDeviceOrientationDidChange,
                                               object: nil)
        
    }
    
    private func reasonablemessageBubbleContainerMaximumWidth() -> CGFloat {
        
        var width: CGFloat = 0
        
        let trait = messagesView.traitCollection
        
        switch (trait.horizontalSizeClass, trait.verticalSizeClass) {
        case (.compact, .compact):  // iPhone landscape
            width = UIScreen.main.bounds.height
            
        case (.compact, .regular):  // iPhone / iPhone Plus portrait
            width = UIScreen.main.bounds.width
            
        case (.regular, .compact):  // iPhone Plus landscape
            width = UIScreen.main.bounds.height
            
        case (.regular, .regular):  // iPad
            if UIDevice.current.orientation == .portrait {
                width = UIScreen.main.bounds.width
            } else {
                width = UIScreen.main.bounds.height
            }
            
        default:
            width = UIScreen.main.bounds.width
        }
        
        return width * 0.75
    }
    
    
    @objc private func didReceiveApplicationMemoryWarningNotification(_ notification: Notification) {
        invalidateLayout(with: CKMessagesViewLayoutInvalidationContext.context())
    }
    
    @objc private func didReceiveDeviceOrientationDidChangeNotification(_ notification: Notification) {
        resetLayout()
    }
    
    private func configure(attributes: CKMessagesViewLayoutAttributes) {
        let indexPath = attributes.indexPath
        let message = messagesView.messenger?.messageForItem(at: indexPath, of: messagesView)
        
        let messageSize = size(of: message, at: indexPath)
                
        attributes.messageInsets = messageInsets
        attributes.messageSize = messageSize
        attributes.messageFont = messageFont
        attributes.incomingAvatarSize = incomingAvatarSize
        attributes.outgoingAvatarSize = outgoingAvatarSize
        
        if message?.senderId == messagesView.messenger?.senderId {
            attributes.avatarPosition = .right
        } else {
            attributes.avatarPosition = .left
        }
        
        
        if let decorator = messagesView.decorator {
            if let height = decorator.messagesView(messagesView, layout: self, heightForTopLabelAt: indexPath) {
                attributes.topLabelHeight = height
            } else if let attributedText = decorator.messagesView(messagesView, layout: self, attributedTextForTopLabelAt: indexPath) {
                attributes.topLabelHeight = size(of: attributedText).height
            } else if let text = decorator.messagesView(messagesView, layout: self, textForTopLabelAt: indexPath) {
                attributes.topLabelHeight = size(of: text, attributes: [NSFontAttributeName: UIFont.preferredFont(forTextStyle: .caption1)]).height
            } else {
                attributes.topLabelHeight = 0
            }
            
            if let height = decorator.messagesView(messagesView, layout: self, heightForBubbleTopLabelAt: indexPath) {
                attributes.bubbleTopLabelHeight = height
            } else if let attributedText = decorator.messagesView(messagesView, layout: self, attributedTextForBubbleTopLabelAt: indexPath) {
                attributes.bubbleTopLabelHeight = size(of: attributedText).height
            } else if let text = decorator.messagesView(messagesView, layout: self, textForBubbleTopLabelAt: indexPath) {
                attributes.bubbleTopLabelHeight = size(of: text, attributes: [NSFontAttributeName: UIFont.preferredFont(forTextStyle: .caption1)]).height
            } else {
                attributes.bubbleTopLabelHeight = 0
            }
            
            if let height = decorator.messagesView(messagesView, layout: self, heightForBottomLabelAt: indexPath) {
                attributes.bottomLabelHeight = height
            } else if let attributedText = decorator.messagesView(messagesView, layout: self, attributedTextForBottomLabelAt: indexPath) {
                attributes.bottomLabelHeight = size(of: attributedText).height
            } else if let text = decorator.messagesView(messagesView, layout: self, textForBottomLabelAt: indexPath) {
                attributes.bottomLabelHeight = size(of: text, attributes: [NSFontAttributeName: UIFont.preferredFont(forTextStyle: .caption1)]).height
            } else {
                attributes.bottomLabelHeight = 0
            }
            
        }
        
        
    }
    
    
    
    
    
    private func resetLayout() {
        messageBubbleContainerMaximumWidth = reasonablemessageBubbleContainerMaximumWidth()
        messageSizeCalculator.prepareForResetting(layout: self)
        invalidateLayout(with: CKMessagesViewLayoutInvalidationContext.context())
    }
    
    private func size(of text: NSAttributedString) -> CGSize {
        let rect = text.boundingRect(with: CGSize(width: itemWidth, height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        return rect.integral.size
    }
    
    private func size(of text: String, attributes: [String: Any]?) -> CGSize {
        let rect = NSString(string: text)
            .boundingRect(with: CGSize(width: itemWidth, height: CGFloat.greatestFiniteMagnitude),
                          options: [.usesLineFragmentOrigin, .usesFontLeading],
                          attributes: attributes,
                          context: nil)
        return rect.integral.size
    }
    
}

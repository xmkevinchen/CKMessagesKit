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
        
        guard let messagesView = collectionView as? CKMessagesView else {
            fatalError("CKMessagesViewLayout should have an associated CKMessagesView instance")
        }
        
        return messagesView
    }
    
    
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
    
    public var messageBubbleMarginWidth: CGFloat = 0.0 {
        didSet {
            if messageBubbleMarginWidth != oldValue {
                resetLayout()
            }
        }
    }
    
    public var messageBubbleTailHorizonalSpace: CGFloat = 6.0 {
        didSet {
            if messageBubbleTailHorizonalSpace != oldValue {
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
        messageBubbleMarginWidth = readableMessageBubbleMarginWidth()
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
        
        guard let message = messagesView.messenger?.messageForItem(at: indexPath, of: messagesView) else {
            return CGSize(width: itemWidth, height: 0)
        }
        
        let size = messageSizeCalculator.size(of: message, at: indexPath, with: self)
        
        let height = size.topLabel.height
            + size.bubbleTopLabel.height
            + size.messageInsets.top
            + size.messageSize.height
            + size.messageInsets.bottom
            + size.bottomLabel.height
        
        return CGSize(width: itemWidth, height: ceil(height))
        
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
    
    private func readableMessageBubbleMarginWidth() -> CGFloat {
        
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
        
        return width * 0.2
    }
    
    
    @objc private func didReceiveApplicationMemoryWarningNotification(_ notification: Notification) {
        invalidateLayout(with: CKMessagesViewLayoutInvalidationContext.context())
    }
    
    @objc private func didReceiveDeviceOrientationDidChangeNotification(_ notification: Notification) {
        resetLayout()
    }
    
    private func configure(attributes: CKMessagesViewLayoutAttributes) {
        let indexPath = attributes.indexPath
        guard let message = messagesView.messenger?.messageForItem(at: indexPath, of: messagesView) else {
            return
        }
        
        let size = messageSizeCalculator.size(of: message, at: indexPath, with: self)
        let isOutgoing = (message.senderId == messagesView.messenger?.senderId)
        
        let messageSize = size.messageSize
        var messageInsets = size.messageInsets
        
        
        let bubbleTailWidth
            = messagesView.decorator?.messagesView(messagesView,
                                                   layout: self,
                                                   bubbleTailHorizontalSpaceAt: indexPath) ?? messageBubbleTailHorizonalSpace
        if isOutgoing {
            attributes.avatarPosition = .right
            messageInsets.right += bubbleTailWidth
        } else {
            attributes.avatarPosition = .left
            messageInsets.left += bubbleTailWidth
        }
        
        attributes.messageInsets = messageInsets
        attributes.messageSize = messageSize
        attributes.messageFont = messageFont
        attributes.incomingAvatarSize = incomingAvatarSize
        attributes.outgoingAvatarSize = outgoingAvatarSize
        attributes.topLabelHeight = size.topLabel.height
        attributes.bubbleTopLabelHeight = size.bubbleTopLabel.height
        attributes.bottomLabelHeight = size.bottomLabel.height
        
        attributes.isConfigured = true
        
        
    }
    
    private func resetLayout() {
        messageBubbleMarginWidth = readableMessageBubbleMarginWidth()
        messageSizeCalculator.prepareForResetting(layout: self)
        invalidateLayout(with: CKMessagesViewLayoutInvalidationContext.context())
    }
}

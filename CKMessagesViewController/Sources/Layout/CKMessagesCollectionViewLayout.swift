//
//  CKMessagesCollectionViewLayout.swift
//  CKCollectionViewForDataCard
//
//  Created by Kevin Chen on 8/24/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import UIKit

public class CKMessagesCollectionViewLayout: UICollectionViewFlowLayout {

    private let defaultAvatarSize: CGSize = CGSize(width: 30, height: 30)
    
    public var messageFont: UIFont = UIFont.preferredFont(forTextStyle: .body)
    public var incomingAvatarSize: CGSize = .zero
    public var outgoingAvatarSize: CGSize = .zero
    public var contentInsets: UIEdgeInsets = .zero
    public var messageTextViewContainerInsets: UIEdgeInsets = .zero
    public var messageContainerMargin: CGFloat = 0.0
    
    public var messageSizeCalculator: CKMessageContentSizeCalculating = CKMessageContentSizeCalculator()
    
    
    
    // MARK: - Override
    override public class var layoutAttributesClass: Swift.AnyClass {
        return CKMessagesCollectionViewLayoutAttributes.self
    }
    
    override public class var invalidationContextClass: Swift.AnyClass {
        return CKMessagesCollectionViewLayoutInvalidationContext.self
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
    }
    
    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        if let attributesForElements = super.layoutAttributesForElements(in: rect) as? [CKMessagesCollectionViewLayoutAttributes] {
            
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
        if let attributes = super.layoutAttributesForItem(at: indexPath)?.copy() as? CKMessagesCollectionViewLayoutAttributes {
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
        
        if let context = context as? CKMessagesCollectionViewLayoutInvalidationContext {
            if context.invalidateDataSourceCounts {
                context.invalidateFlowLayoutAttributes = true
                context.invalidateFlowLayoutDelegateMetrics = true
            }
            
            if context.invalidateFlowLayoutAttributes || context.invalidateFlowLayoutDelegateMetrics {
                
            }
            
            if context.invalidateLayoutMessagesCache {
                reset()
            }
        }
        
        super.invalidateLayout(with: context)
    }
    
    // MARK:- Public
    
    func sizeForItem(at indexPath: IndexPath) -> CGSize {
        
        let messageSize = messageSizeForItem(at: indexPath)
        
        if let attributes = layoutAttributesForItem(at: indexPath) as? CKMessagesCollectionViewLayoutAttributes {
            
            var height = messageSize.height
            height += attributes.topLabelHeight
            height += attributes.messageTopLabelHeight
            height += attributes.bottomLabelHeight
            
            
            return CGSize(width: itemWidth, height: ceil(height))
        }
        
        return .zero
        
    }
    
    private func messageSizeForItem(at indexPath: IndexPath) -> CGSize {
        
        if let messagesView = collectionView as? CKMessagesCollectionView,
            let dataSource = collectionView?.dataSource as? CKMessagesViewDataSource {
            let message = dataSource.messageView(messagesView, messageForItemAt: indexPath)
            
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
        
        incomingAvatarSize = defaultAvatarSize
        outgoingAvatarSize = defaultAvatarSize
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            messageContainerMargin = 240
        } else {
            messageContainerMargin = 50
        }
        
        contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 6.0)
        messageTextViewContainerInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didReceiveApplicationMemoryWarningNotification(_:)),
                                               name: Notification.Name.UIApplicationDidReceiveMemoryWarning,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didReceiveDeviceOrientationDidChangeNotification(_:)),
                                               name: Notification.Name.UIDeviceOrientationDidChange,
                                               object: nil)
        
    }
    
    
    
    @objc private func didReceiveApplicationMemoryWarningNotification(_ notification: Notification) {
        let context = CKMessagesCollectionViewLayoutInvalidationContext.context()
        context.invalidateLayoutMessagesCache = true
        invalidateLayout(with: context)
    }
    
    @objc private func didReceiveDeviceOrientationDidChangeNotification(_ notification: Notification) {
        invalidateLayout(with: CKMessagesCollectionViewLayoutInvalidationContext.context())
    }
    
    private func configure(attributes: CKMessagesCollectionViewLayoutAttributes) {
        let indexPath = attributes.indexPath
        let messageSize = messageSizeForItem(at: indexPath)
        attributes.messageContainerWidth = messageSize.width
        attributes.contentViewInsets = contentInsets
        attributes.messageTextViewContainerInsetes = messageTextViewContainerInsets
        attributes.messageFont = messageFont
        attributes.incomingAvatarSize = incomingAvatarSize
        attributes.outgoingAvatarSize = outgoingAvatarSize
        
        if let messageView = collectionView as? CKMessagesCollectionView,
            let delegate = collectionView?.delegate as? CKMessagesViewDelegate {
            
            // Top Label
            if let attributedText = delegate.messageView?(messageView, attributedTextForTopAt: indexPath) {
                
                attributes.topLabelHeight = size(of: attributedText).height
                
            } else if let text = delegate.messageView?(messageView, textForTopAt: indexPath) {
                attributes.topLabelHeight = size(of: text, attributes: [NSFontAttributeName: UIFont.preferredFont(forTextStyle: .caption1)]).height
            }
            
            // Message Top Label
            if let attributedText = delegate.messageView?(messageView, attributedTextForMessageTopAt: indexPath) {
                
                attributes.messageTopLabelHeight = size(of: attributedText).height
                
            } else if let text = delegate.messageView?(messageView, textForMessageTopAt: indexPath) {
                attributes.topLabelHeight = size(of: text,attributes: [NSFontAttributeName: UIFont.preferredFont(forTextStyle: .caption2)]).height
            }
            
            // Top Label
            if let attributedText = delegate.messageView?(messageView, attributedTextForBottom: indexPath) {
                
                attributes.topLabelHeight = size(of: attributedText).height
                
            } else if let text = delegate.messageView?(messageView, textForBottomAt: indexPath) {
                attributes.topLabelHeight = size(of: text,attributes: [NSFontAttributeName: UIFont.preferredFont(forTextStyle: .caption2)]).height
            }
            
        }
    }
    
    
    
    
    
    private func reset() {
        messageSizeCalculator.prepareForResetting(layout: self)
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

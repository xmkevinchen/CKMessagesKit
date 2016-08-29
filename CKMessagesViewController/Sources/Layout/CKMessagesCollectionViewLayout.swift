//
//  CKMessagesCollectionViewLayout.swift
//  CKCollectionViewForDataCard
//
//  Created by Kevin Chen on 8/24/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import UIKit

public class CKMessagesCollectionViewLayout: UICollectionViewFlowLayout {
    
    public var messagesView: CKMessagesCollectionView {
        return collectionView! as! CKMessagesCollectionView
    }
    
    private let defaultAvatarSize: CGSize = CGSize(width: 30, height: 30)
    
    public var messageFont: UIFont = UIFont.preferredFont(forTextStyle: .body)
        {
        didSet {
            if messageFont != oldValue {
                invalidateLayout(with: CKMessagesCollectionViewLayoutInvalidationContext.context())
            }
        }
        
    }
    
    public var incomingAvatarSize: CGSize = .zero {
        didSet {
            if incomingAvatarSize != oldValue {
                invalidateLayout(with: CKMessagesCollectionViewLayoutInvalidationContext.context())
            }
        }
    }
    public var outgoingAvatarSize: CGSize = .zero {
        didSet {
            if outgoingAvatarSize != oldValue {
                invalidateLayout(with: CKMessagesCollectionViewLayoutInvalidationContext.context())
            }
        }
    }
    
    public var contentInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8) {
        didSet {
            if contentInsets != oldValue {
                invalidateLayout(with: CKMessagesCollectionViewLayoutInvalidationContext.context())
            }
            
        }
    }
    
    public var messageContentInsets: UIEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8) {
        didSet {
            if messageContentInsets != oldValue {
                invalidateLayout(with: CKMessagesCollectionViewLayoutInvalidationContext.context())
            }
        }
    }
    public var messageContainerMargin: CGFloat = 0.0 {
        didSet {
            if messageContainerMargin != oldValue {
                invalidateLayout(with: CKMessagesCollectionViewLayoutInvalidationContext.context())
            }
        }
    }
    
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
            
            
            if context.invalidateLayoutMessagesCache {
                reset()
            }
        }
        
        super.invalidateLayout(with: context)
    }
    
    // MARK:- Public
    
    public func sizeForItem(at indexPath: IndexPath) -> CGSize {
        
        
        let messageSize = messageSizeForItem(at: indexPath)
        var height = messageSize.height
        
        if let attributes = layoutAttributesForItem(at: indexPath) as? CKMessagesCollectionViewLayoutAttributes {
            
            height += attributes.topLabelHeight
            height += attributes.messageTopLabelHeight
            height += attributes.bottomLabelHeight
            
        }
        
        return CGSize(width: itemWidth, height: ceil(height))
        
    }
    
    private func messageSizeForItem(at indexPath: IndexPath) -> CGSize {
        
        if let message = messagesView.messenger?.messageForItem(at: indexPath, of: messagesView) {
            
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
        attributes.messageContentInsets = messageContentInsets
        attributes.messageFont = messageFont
        attributes.incomingAvatarSize = incomingAvatarSize
        attributes.outgoingAvatarSize = outgoingAvatarSize
        
        
        
        if let decorator = messagesView.decorator {
            
            if let attributedText = decorator.attributedTextForTop(at: indexPath, of: messagesView) {
                attributes.topLabelHeight = size(of: attributedText).height
            } else if let text = decorator.textForTop(at: indexPath, of:messagesView) {
                attributes.topLabelHeight = size(of: text, attributes: [NSFontAttributeName: UIFont.preferredFont(forTextStyle: .caption1)]).height
            }
            
            if let attributedText = decorator.attributedTextForMessageTop(at: indexPath, of: messagesView) {
                attributes.messageTopLabelHeight = size(of: attributedText).height
            } else if let text = decorator.textForMessageTop(at: indexPath, of: messagesView) {
                attributes.messageTopLabelHeight = size(of: text, attributes: [NSFontAttributeName: UIFont.preferredFont(forTextStyle: .caption1)]).height
            }
            
            if let attributedText = decorator.attributedTextForBottom(at: indexPath, of: messagesView) {
                attributes.topLabelHeight = size(of: attributedText).height
            } else if let text = decorator.textForBottom(at: indexPath, of: messagesView) {
                attributes.topLabelHeight = size(of: text, attributes: [NSFontAttributeName: UIFont.preferredFont(forTextStyle: .caption1)]).height
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

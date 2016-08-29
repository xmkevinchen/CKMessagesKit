//
//  CKMessagesCollectionViewLayoutAttributes.swift
//  CKCollectionViewForDataCard
//
//  Created by Kevin Chen on 8/24/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import UIKit

public class CKMessagesCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {
    
    public var messageFont: UIFont
    public var contentViewInsets: UIEdgeInsets
    public var incomingAvatarSize: CGSize
    public var outgoingAvatarSize: CGSize
    public var messageContainerWidth: CGFloat
    public var messageTextViewContainerInsetes: UIEdgeInsets
    public var topLabelHeight: CGFloat
    public var messageTopLabelHeight: CGFloat
    public var bottomLabelHeight: CGFloat
    
    override init() {
        messageFont = UIFont.preferredFont(forTextStyle: .body)
        contentViewInsets = .zero
        incomingAvatarSize = .zero
        outgoingAvatarSize = .zero
        messageContainerWidth = 320.0
        messageTextViewContainerInsetes = .zero
        topLabelHeight = 0.0
        messageTopLabelHeight = 0.0
        bottomLabelHeight = 0.0
        super.init()
    }

    override public func copy() -> Any {
        let copy = super.copy() as! CKMessagesCollectionViewLayoutAttributes
        
        copy.messageFont = messageFont
        copy.contentViewInsets = contentViewInsets
        copy.incomingAvatarSize = incomingAvatarSize
        copy.outgoingAvatarSize = outgoingAvatarSize
        copy.messageContainerWidth = messageContainerWidth
        copy.messageTextViewContainerInsetes = messageTextViewContainerInsetes
        
        return copy
    }
    
    override public func isEqual(_ object: Any?) -> Bool {
        if let attributes = object as? CKMessagesCollectionViewLayoutAttributes {
            
            if attributes.representedElementCategory == .cell {
                return messageFont == attributes.messageFont
                    && contentViewInsets == attributes.contentViewInsets
                    && incomingAvatarSize == attributes.incomingAvatarSize
                    && outgoingAvatarSize == attributes.outgoingAvatarSize
                    && messageContainerWidth == attributes.messageContainerWidth
                    && messageTextViewContainerInsetes == attributes.messageTextViewContainerInsetes
                    && super.isEqual(attributes)
            } else {
                return super.isEqual(attributes)
            }
            
        }
        
        return super.isEqual(object)
    }
}

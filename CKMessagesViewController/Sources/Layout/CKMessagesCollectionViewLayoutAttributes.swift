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
    public var incomingAvatarSize: CGSize
    public var outgoingAvatarSize: CGSize
    public var messageContentInsets: UIEdgeInsets
    public var messageContentSize: CGSize
    public var topLabelHeight: CGFloat
    public var messageTopLabelHeight: CGFloat
    public var bottomLabelHeight: CGFloat
    
    override init() {
        messageFont = UIFont.preferredFont(forTextStyle: .body)
        incomingAvatarSize = .zero
        outgoingAvatarSize = .zero
        messageContentInsets = .zero
        messageContentSize = .zero
        topLabelHeight = 0.0
        messageTopLabelHeight = 0.0
        bottomLabelHeight = 0.0
        super.init()
    }

    override public func copy() -> Any {
        let copy = super.copy() as! CKMessagesCollectionViewLayoutAttributes
        
        copy.messageFont = messageFont
        copy.incomingAvatarSize = incomingAvatarSize
        copy.outgoingAvatarSize = outgoingAvatarSize
        copy.messageContentInsets = messageContentInsets
        copy.messageContentSize = messageContentSize
        copy.topLabelHeight = topLabelHeight
        copy.messageTopLabelHeight = messageTopLabelHeight
        copy.bottomLabelHeight = bottomLabelHeight
        
        return copy
    }
    
    override public func isEqual(_ object: Any?) -> Bool {
        if let attributes = object as? CKMessagesCollectionViewLayoutAttributes {
            
            if attributes.representedElementCategory == .cell {
                return messageFont == attributes.messageFont                    
                    && incomingAvatarSize == attributes.incomingAvatarSize
                    && outgoingAvatarSize == attributes.outgoingAvatarSize
                    && messageContentInsets == attributes.messageContentInsets                    
                    && messageContentSize == attributes.messageContentSize
                    && topLabelHeight == attributes.topLabelHeight
                    && messageTopLabelHeight == attributes.messageTopLabelHeight
                    && bottomLabelHeight == attributes.bottomLabelHeight
                    && super.isEqual(attributes)
            } else {
                return super.isEqual(attributes)
            }
            
        }
        
        return super.isEqual(object)
    }
}

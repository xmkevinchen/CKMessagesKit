//
//  CKMessagesViewLayoutAttributes.swift
//  CKCollectionViewForDataCard
//
//  Created by Kevin Chen on 8/24/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import UIKit

public class CKMessagesViewLayoutAttributes: UICollectionViewLayoutAttributes {
    
    
    public enum CKMessagesViewAvatarPosition {
        case left
        case right
    }
    
    
    
    public var avatarPosition: CKMessagesViewAvatarPosition
    public var incomingAvatarSize: CGSize
    public var outgoingAvatarSize: CGSize
    
    public var messageFont: UIFont
    public var messageBubbleContainerSize: CGSize
    public var messageSize: CGSize
    public var messageInsets: UIEdgeInsets
    
    public var topLabelHeight: CGFloat
    public var bubbleTopLabelHeight: CGFloat
    public var bottomLabelHeight: CGFloat
    
    
    
    override init() {
        messageFont = UIFont.preferredFont(forTextStyle: .body)
        incomingAvatarSize = .zero
        outgoingAvatarSize = .zero
        messageInsets = .zero
        messageSize = .zero
        messageBubbleContainerSize = .zero
        topLabelHeight = 0.0
        bubbleTopLabelHeight = 0.0
        bottomLabelHeight = 0.0
        avatarPosition = .left
        super.init()
    }

    override public func copy() -> Any {
        let copy = super.copy() as! CKMessagesViewLayoutAttributes
        
        copy.messageFont = messageFont
        copy.incomingAvatarSize = incomingAvatarSize
        copy.outgoingAvatarSize = outgoingAvatarSize
        copy.messageInsets = messageInsets
        copy.messageSize = messageSize
        copy.messageBubbleContainerSize = messageBubbleContainerSize
        copy.topLabelHeight = topLabelHeight
        copy.bubbleTopLabelHeight = bubbleTopLabelHeight
        copy.bottomLabelHeight = bottomLabelHeight
        copy.avatarPosition = avatarPosition
        
        return copy
    }
    
    override public func isEqual(_ object: Any?) -> Bool {
        if let attributes = object as? CKMessagesViewLayoutAttributes {
            
            if attributes.representedElementCategory == .cell {
                return messageFont == attributes.messageFont                    
                    && incomingAvatarSize == attributes.incomingAvatarSize
                    && outgoingAvatarSize == attributes.outgoingAvatarSize
                    && messageInsets == attributes.messageInsets                    
                    && messageSize == attributes.messageSize
                    && messageBubbleContainerSize == attributes.messageBubbleContainerSize
                    && topLabelHeight == attributes.topLabelHeight
                    && bubbleTopLabelHeight == attributes.bubbleTopLabelHeight
                    && bottomLabelHeight == attributes.bottomLabelHeight
                    && avatarPosition == attributes.avatarPosition                    
                    && super.isEqual(attributes)
            } else {
                return super.isEqual(attributes)
            }
            
        }
        
        return super.isEqual(object)
    }
}

//
//  CKMessageContentSizeCalculator.swift
//  CKMessagesViewController
//
//  Created by Kevin Chen on 8/27/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import UIKit


class CKMessageSizeCalculator: CKMessageSizeCalculating {
    
    private var cache: NSCache<AnyObject, AnyObject>
    private var minimumWidth: CGFloat
    private var additionalInsets : CGFloat = 2
    
    init(cache: NSCache<AnyObject, AnyObject>, minimumWidth: CGFloat) {
        self.cache = cache
        self.minimumWidth = minimumWidth
    }
    
    convenience init() {
        let cache = NSCache<AnyObject, AnyObject>()
        let minimumWidth = UIImage.bubbleCompat.size.width
        
        cache.countLimit = 200
        cache.name = "CKMessagesContainerSizeCalculator.cache"
        
        self.init(cache: cache, minimumWidth: minimumWidth)
    }
    
    func size(of message: CKMessageData, at indexPath: IndexPath, with layout: CKMessagesViewLayout) -> CKMessageCalculatingSize {
        
        let key = message.hash as AnyObject
        if let cachedSize = cache.object(forKey: key) as? CKMessageCalculatingSize {
            return cachedSize
        }
        
        var size: CKMessageCalculatedSize = .zero
        let messagesView = layout.messagesView

        // Avatar size
        size.avatar = self.avatarSize(of: message, with: layout)
        
        // Message insets
        let presentor = messagesView.presentor(at: indexPath)
        if let presentor = presentor as? CKMessageEmbeddablePresentor {
            size.messageInsets = presentor.insets
        } else {
            size.messageInsets = layout.messageInsets
        }
        
        
        size.topLabel = labelSize(of: .top, with: layout, at: indexPath)
        size.bubbleTopLabel = labelSize(of: .bubbleTop, with: layout, at: indexPath)
        size.bottomLabel = labelSize(of: .bottom, with: layout, at: indexPath)
                
        size.avatar = avatarSize(of: message, with: layout)
        
        // Message itself size
        if let presentor = presentor as? CKMessageResizablePresentor {
            size.messageSize = presentor.size
        } else {
            
            var horizontalSpace = size.messageInsets.left + size.messageInsets.right
            let bubbleTailWidth = layout.messageBubbleTailHorizonalSpace
            horizontalSpace += bubbleTailWidth
            
            let maximumWidth = layout.itemWidth - size.avatar.width - horizontalSpace - layout.messageBubbleMarginWidth
            let textView = CKMessageCellTextView()
            textView.text = message.text
            textView.font = layout.messageFont
            var messageSize = textView.sizeThatFits(CGSize(width: maximumWidth, height: CGFloat.greatestFiniteMagnitude))
            
            /// Because we use the insets to layout messageView inside of the message bubble image
            /// So the minimuWidth should subtract the horizontal insets as well
            messageSize.width = max(messageSize.width, minimumWidth - horizontalSpace)
            size.messageSize = messageSize
        }
        
        cache.setObject(size as AnyObject, forKey: key)
        
        return size
    }
    
    func prepareForResetting(layout: CKMessagesViewLayout) {
        cache.removeAllObjects()
    }
    
    private func avatarSize(of message: CKMessageData, with layout: CKMessagesViewLayout) -> CGSize {
        
        if let senderId = layout.messagesView.messenger?.senderId {
            
            if message.senderId == senderId {
                return layout.outgoingAvatarSize
            } else {
                return layout.incomingAvatarSize
            }
            
        } else {
            
            return .zero
        }
        
    }
    
    private enum CKMessageLabelPosition {
        case top
        case bubbleTop
        case bottom
    }
    
    private func labelSize(of position: CKMessageLabelPosition, with layout: CKMessagesViewLayout, at indexPath: IndexPath) -> CGSize {
        
        let messagesView = layout.messagesView
        let decoractor = messagesView.decorator
        
        let label = CKMessageInsetsLabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        switch position {
        case .top:
            
            if let attributedText = decoractor?.messagesView(messagesView, layout: layout, attributedTextForTopLabelAt: indexPath) {
                label.attributedText = attributedText
            } else if let text = decoractor?.messagesView(messagesView, layout: layout, textForTopLabelAt: indexPath) {
                label.text = text
                label.font = UIFont.preferredFont(forTextStyle: .caption1)
            }
            
        case .bubbleTop:
            
            if let attributedText = decoractor?.messagesView(messagesView, layout: layout, attributedTextForBubbleTopLabelAt: indexPath) {
                label.attributedText = attributedText
            } else if let text = decoractor?.messagesView(messagesView, layout: layout, textForBubbleTopLabelAt: indexPath) {
                label.text = text
                label.font = UIFont.preferredFont(forTextStyle: .caption2)
            }
            
        case .bottom:
            if let attributedText = decoractor?.messagesView(messagesView, layout: layout, attributedTextForBottomLabelAt: indexPath) {
                label.attributedText = attributedText
            } else if let text = decoractor?.messagesView(messagesView, layout: layout, textForBottomLabelAt: indexPath) {
                label.text = text
                label.font = UIFont.preferredFont(forTextStyle: .caption2)
            }
        }
        
        let size = label.sizeThatFits(CGSize(width: layout.itemWidth, height: CGFloat.greatestFiniteMagnitude))
        
        return size
    }
    
}

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
    
    func size(of message: CKMessageData, at indexPath: IndexPath, with layout: CKMessagesViewLayout) -> CGSize {
        
        let key = message.hash as AnyObject
        
        if let cachedSize = cache.object(forKey: key) as? CGSize {
            return cachedSize
        }
        
        let avatarSize: CGSize = self.avatarSize(of: message, with: layout)
        let messageInsets = layout.messageInsets
        let horizontalSpace = messageInsets.left + messageInsets.right
        let bubbleTailWidth = layout.messagesView.decorator?.messagesView(layout.messagesView, layout: layout, bubbleTailHorizontalSpaceAt: indexPath) ?? layout.messageBubbleTailHorizonalSpace
        let maximumWidth = layout.itemWidth - avatarSize.width - horizontalSpace - layout.messageBubbleMarginWidth - bubbleTailWidth
        
        /// If decorator returns contentSize of message, just use it without caching it
        if var contentSize = layout.messagesView.decorator?.messagesView(layout.messagesView, layout: layout, contentSizeAt: indexPath) {
            contentSize.width = min(maximumWidth, contentSize.width)
            cache.setObject(contentSize as AnyObject, forKey: key)
            return contentSize
        }
        
                                        
        //         let textView = CKMessageCellTextView()
        //         textView.text = message.text
        //         let referenceSize = textView.sizeThatFits(CGSize(width: maximumWidth, height: CGFloat.greatestFiniteMagnitude))
        
        let stringRect = NSString(string: message.text)
            .boundingRect(with: CGSize(width: maximumWidth, height: CGFloat.greatestFiniteMagnitude),
                          options: [.usesLineFragmentOrigin, .usesFontLeading],
                          attributes: [NSFontAttributeName: layout.messageFont],
                          context: nil)
        
        var stringSize = stringRect.integral.size
        
        // The stringSize calculated here is 2 pixels less than the one calculated by UIText.sizeThatFits(_:) method
        // as the comment above the stringRect calculation.
        // In order to keep this code without UI components, we still use the additional insets
        
        stringSize.height += additionalInsets
        
        var contentSize = stringSize
        
        /// Because we use the insets to layout messageView inside of the message bubble image
        /// So the minimuWidth should subtract the horizontal insets as well
        
        contentSize.width = max(contentSize.width, minimumWidth - messageInsets.left - messageInsets.right - bubbleTailWidth)
        
        cache.setObject(contentSize as AnyObject, forKey: key)
        
        return contentSize
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
    
    
    
}

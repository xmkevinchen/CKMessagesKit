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
    
    func size(of message: CKMessageData, at indexPath: IndexPath, with layout: CKMessagesViewLayout) -> CKMessageSize {
        
        let key = message.hash as AnyObject
        
        if let cachedSize = cache.object(forKey: key) as? CKMessageSize {
            return cachedSize
        }
        
        let avatarSize: CGSize = self.avatarSize(of: message, with: layout)
        
        let messagenContentInsets = layout.messageContentInsets
        
        let hInsets = messagenContentInsets.left + messagenContentInsets.right
        let vInsets = messagenContentInsets.top + messagenContentInsets.bottom
        
        var contentSize = layout.messagesView.decorator?.messagesView(layout.messagesView, layout: layout, contentSizeAt: indexPath)        
        
        var width: CGFloat = 0
        var height: CGFloat = 0
        
        let maximumWidth = layout.itemWidth - avatarSize.width - layout.messageContainerMargin - hInsets
        
        if contentSize != nil {
            
            if contentSize!.width > maximumWidth {
                contentSize!.width = maximumWidth
            }
            
            width = contentSize!.width + hInsets
            height = contentSize!.height + vInsets
            
            
        } else {
            
            
//            let textView = CKMessageCellTextView()
//            textView.text = message.text
//            let stringSize = textView.sizeThatFits(CGSize(width: maximumWidth, height: CGFloat.greatestFiniteMagnitude))
            
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
            
            contentSize = stringSize
            
            width = contentSize!.width + hInsets
            height = contentSize!.height + vInsets
        }
        
        
        let containerSize = CGSize(width: max(width, minimumWidth), height: height)
        
        let size = CKMessageSize(container: containerSize, content: contentSize!)
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
    
    
    
}

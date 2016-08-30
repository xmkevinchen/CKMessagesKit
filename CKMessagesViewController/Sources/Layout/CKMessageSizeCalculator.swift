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
        let minimumWidth = UIImage.bubbleCompatImage.size.width
        
        cache.countLimit = 200
        cache.name = "CKMessagesContainerSizeCalculator.cache"
        
        self.init(cache: cache, minimumWidth: minimumWidth)
    }
    
    func size(of message: CKMessageData, at indexPath: IndexPath, with layout: CKMessagesCollectionViewLayout) -> CKMessageSize {
        
        let key = String(message.hash) as NSString
        
        if let cachedSize = cache.object(forKey: key) as? CKMessageSize {
            return cachedSize
        }
        
        let avatarSize: CGSize = self.avatarSize(of: message, with: layout)
        
        let messagenContentInsets = layout.messageContentInsets
        let contentInsets = layout.contentInsets
        
        let hInsets = messagenContentInsets.left + messagenContentInsets.right + contentInsets.left + contentInsets.right
        let vInsets = messagenContentInsets.top + messagenContentInsets.bottom + contentInsets.top + contentInsets.bottom
        
        var contentSize = layout.messagesView.decorator?.contentSize(at: indexPath, of: layout.messagesView)
        
        var width: CGFloat = 0
        var height: CGFloat = 0
        
        if contentSize != nil && contentSize! != .zero {
            
            width = contentSize!.width + hInsets
            height = contentSize!.height + vInsets
            
        } else {
            
            let maximumTextWidth = layout.itemWidth - avatarSize.width - layout.messageContainerMargin - hInsets
            
            let stringRect = NSString(string: message.text)
                .boundingRect(with: CGSize(width: maximumTextWidth, height: CGFloat.greatestFiniteMagnitude),
                              options: [.usesLineFragmentOrigin, .usesFontLeading],
                              attributes: [NSFontAttributeName: layout.messageFont],
                              context: nil)
            
            let stringSize = stringRect.integral.size
            contentSize = stringSize
                                    
            width = stringSize.width + hInsets
            height = stringSize.height + vInsets + additionalInsets
        }
        
        
        
        
        let containerSize = CGSize(width: max(width, minimumWidth), height: height)
        
        let size = CKMessageSize(container: containerSize, content: contentSize!)
        cache.setObject(size as AnyObject, forKey: key)
        
        return size
    }
    
    func prepareForResetting(layout: CKMessagesCollectionViewLayout) {
        cache.removeAllObjects()
    }
    
    private func avatarSize(of message: CKMessageData, with layout: CKMessagesCollectionViewLayout) -> CGSize {
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

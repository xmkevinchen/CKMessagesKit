//
//  CKMessageContentSizeCalculator.swift
//  CKMessagesViewController
//
//  Created by Kevin Chen on 8/27/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import UIKit


class CKMessageContentSizeCalculator: CKMessageContentSizeCalculating {
    
    private var cache: NSCache<AnyObject, AnyObject>
    private var minimumWidth: CGFloat
    
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
    
    func size(of message: CKMessageData, at indexPath: IndexPath, with layout: CKMessagesCollectionViewLayout) -> CGSize {
        
        if let cachedSize = cache.object(forKey: message.hash as AnyObject) as? CGSize {
            return cachedSize
        }
        
        let avatarSize: CGSize = self.avatarSize(of: message, with: layout)
        
        let textContainerInsets = layout.messageTextViewContainerInsets
        let contentInsets = layout.contentInsets
        
        let hInsets = textContainerInsets.left + textContainerInsets.right + contentInsets.left + contentInsets.right
        
        let maximumTextWidth = layout.itemWidth - avatarSize.width - layout.messageContainerMargin - hInsets
        
        let stringRect = NSString(string: message.text)
            .boundingRect(with: CGSize(width: maximumTextWidth, height: CGFloat.greatestFiniteMagnitude),
                          options: [.usesLineFragmentOrigin, .usesFontLeading],
                          attributes: [NSFontAttributeName: layout.messageFont],
                          context: nil)
        
        let stringSize = stringRect.integral.size
                
        let vInsets = textContainerInsets.top + textContainerInsets.bottom + contentInsets.top + contentInsets.bottom
        
        let width = stringSize.width + hInsets
        let height = stringSize.height + vInsets
        
        let size = CGSize(width: max(width, minimumWidth), height: height)
        
        cache.setObject(size as AnyObject, forKey: message.hash as AnyObject)
        return size
    }
    
    func prepareForResetting(layout: CKMessagesCollectionViewLayout) {
        cache.removeAllObjects()
    }
    
    private func avatarSize(of message: CKMessageData, with layout: CKMessagesCollectionViewLayout) -> CGSize {
        if let dataSource = layout.collectionView?.dataSource as? CKMessagesViewDataSource {
            
            if message.senderId == dataSource.senderId {
                return layout.outgoingAvatarSize
            } else {
                return layout.incomingAvatarSize
            }
            
        } else {
            return .zero
        }
        
    }
    
    
    
}

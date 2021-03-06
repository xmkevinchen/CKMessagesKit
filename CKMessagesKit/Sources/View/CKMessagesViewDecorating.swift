//
//  CKMessagesViewDecorating.swift
//  CKMessagesKit
//
//  Created by Kevin Chen on 9/14/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import UIKit

public protocol CKMessagesViewDecorating: class {
    
    
    /// Asks the decorator for the text of the `topLabel` for the item at the specified indexPath
    ///
    /// - parameter messagesView: The messages view object displaying the flow layout
    /// - parameter layout:       The layout object requesting the information
    /// - parameter at:           The index path of the item
    ///
    /// - returns: The text of the `topLabel` for the item at indexPath
    ///
    func messagesView(_ messagesView: CKMessagesView, layout: CKMessagesViewLayout, textForTopLabelAt indexPath: IndexPath) -> String?
    
    
    /// Asks the decorator for the attributed text of the `topLabel` for the item at the specified indexPath
    ///
    /// - parameter messagesView: The messages view object displaying the flow layout
    /// - parameter layout:       The layout object requesting the information
    /// - parameter at:           The index path of the item
    ///
    /// - returns: The attributed text of the `topLabel` for the item at indexPath
    ///
    func messagesView(_ messagesView: CKMessagesView, layout: CKMessagesViewLayout, attributedTextForTopLabelAt indexPath: IndexPath) -> NSAttributedString?
    
    /// Asks the decorator for the height of the `topLabel` for the item at the specified indexPath
    ///
    /// If return `nil` from this method, `CKMessagesViewLayout` will use the text of `CKMessageData` to calculate the height
    ///
    /// - parameter messagesView: The messages view object displaying the flow layout
    /// - parameter layout:       The layout object requesting the information
    /// - parameter at:           The index path of the item
    ///
    /// - returns: The height of the `topLabel` for the item at indexPath
    ///
    func messagesView(_ messagesView: CKMessagesView, layout: CKMessagesViewLayout, heightForTopLabelAt indexPath: IndexPath) -> CGFloat?
    
    
    /// Asks the decorator for the text of the `bubbleTopLabel` for the item at the specified indexPath
    ///
    /// - parameter messagesView: The messages view object displaying the flow layout
    /// - parameter layout:       The layout object requesting the information
    /// - parameter at:           The index path of the item
    ///
    /// - returns: The text of the `messageTopLabel` for the item at indexPath
    ///
    func messagesView(_ messagesView: CKMessagesView, layout: CKMessagesViewLayout, textForBubbleTopLabelAt indexPath: IndexPath) -> String?
    
    /// Asks the decorator for the attributed text of the `messageTopLabel` for the item at the specified indexPath
    ///
    /// - parameter messagesView: The messages view object displaying the flow layout
    /// - parameter layout:       The layout object requesting the information
    /// - parameter at:           The index path of the item
    ///
    /// - returns: The attributed text of the `messageTopLabel` for the item at indexPath
    ///
    func messagesView(_ messagesView: CKMessagesView, layout: CKMessagesViewLayout, attributedTextForBubbleTopLabelAt indexPath: IndexPath) -> NSAttributedString?
    
    /// Asks the decorator for the height of the `messageTopLabel` for the item at the specified indexPath
    ///
    /// - parameter messagesView: The messages view object displaying the flow layout
    /// - parameter layout:       The layout object requesting the information
    /// - parameter at:           The index path of the item
    ///
    /// - returns: The height of the `messageTopLabel` for the item at indexPath
    ///
    func messagesView(_ messagesView: CKMessagesView, layout: CKMessagesViewLayout, heightForBubbleTopLabelAt indexPath: IndexPath) -> CGFloat?
    
    /// Asks the decorator for the text of the `bottomLabel` for the item at the specified indexPath
    ///
    /// - parameter messagesView: The messages view object displaying the flow layout
    /// - parameter layout:       The layout object requesting the information
    /// - parameter at:           The index path of the item
    ///
    /// - returns: The text of the `bottomLabel` for the item at indexPath
    ///
    func messagesView(_ messagesView: CKMessagesView, layout: CKMessagesViewLayout, textForBottomLabelAt indexPath: IndexPath) -> String?
    
    /// Asks the decorator for the attributed text of the `bottomLabel` for the item at the specified indexPath
    ///
    /// - parameter messagesView: The messages view object displaying the flow layout
    /// - parameter layout:       The layout object requesting the information
    /// - parameter at:           The index path of the item
    ///
    /// - returns: The attributed text of the `bottomLabel` for the item at indexPath
    ///
    func messagesView(_ messagesView: CKMessagesView, layout: CKMessagesViewLayout, attributedTextForBottomLabelAt indexPath: IndexPath) -> NSAttributedString?
    
    /// Asks the decorator for the height of the `bottomLabel` for the item at the specified indexPath
    ///
    /// - parameter messagesView: The messages view object displaying the flow layout
    /// - parameter layout:       The layout object requesting the information
    /// - parameter at:           The index path of the item
    ///
    /// - returns: The height of the `bottomLabel` for the item at indexPath
    ///
    func messagesView(_ messagesView: CKMessagesView, layout: CKMessagesViewLayout, heightForBottomLabelAt indexPath: IndexPath) -> CGFloat?
    
    /// Asks the decorator for the bubble image data that corresponds to the message at the specified indexPath
    ///
    /// - parameter messagesView: The messages view object displaying the flow layout
    /// - parameter layout:       The layout object requesting the information
    /// - parameter at:           The index path of the item
    ///
    /// - returns: The bubble image data of the message at the specified indexPath
    ///
    func messagesView(_ messagesView: CKMessagesView, layout: CKMessagesViewLayout, messageBubbleAt indexPath: IndexPath) -> CKMessageBubbleImageData?
    
    /// Asks the decorator for the avatar image data that corresponds to the message at the specified indexPath
    ///
    /// - parameter messagesView: The messages view object displaying the flow layout
    /// - parameter layout:       The layout object requesting the information
    /// - parameter at:           The index path of the item
    ///
    /// - returns: The avatar image data of the message at the specified indexPath
    ///
    func messagesView(_ messagesView: CKMessagesView, layout: CKMessagesViewLayout, avatarAt indexPath: IndexPath) -> CKMessagesAvatarImageData?
    
    /// Asks the decorator for the content size that corresponds to the message at the specified indexPath
    ///
    /// If return `nil` from this method, `CKMessagesViewLayout` will use the text of `CKMessageData` to calculate the size,
    /// otherwise, `CKMessagesViewLayout` will just use the return value from this method.
    ///
    /// The content size is just for message content itself, it doesn't include the size of such as
    /// * `topLabel`
    /// * `messageLabel`
    /// * `bottomLabel`
    /// * `avatarImageView`
    /// * `accessoryView`
    ///
    /// These size above will retrieve for their corresponding delegate method,
    /// and `CKMessagesViewLayout` will use them to calculate the finalize size of the whole message cell
    ///
    /// - parameter messagesView: The messages view object displaying the flow layout
    /// - parameter layout:       The layout object requesting the information
    /// - parameter at:           The layout object requesting the information
    ///
    /// - returns: The content size of the message at the specified indexPath
    ///
    func messagesView(_ messagesView: CKMessagesView, layout: CKMessagesViewLayout, messageSizeAt indexPath: IndexPath) -> CGSize?
    
    /// Asks the decorator for the message insets that corresponds to the message at the specified indexPath
    ///
    /// If return `nil` from this method, `CKMessagesViewLayout` will use the value of its property `messageInsets`,
    /// otherwise, `CKMessagesViewLayout` will just use the return value from this method.
    ///
    ///
    /// These size above will retrieve for their corresponding delegate method,
    /// and `CKMessagesViewLayout` will use them to calculate the finalize size of the whole message cell
    ///
    /// - parameter messagesView: The messages view object displaying the flow layout
    /// - parameter layout:       The layout object requesting the information
    /// - parameter at:           The layout object requesting the information
    ///
    /// - returns: The insets of the message at the specified indexPath
    ///
    func messagesView(_ messagesView: CKMessagesView, layout: CKMessagesViewLayout, messageInsetsAt indexPath: IndexPath) -> UIEdgeInsets?
    
    
    /// Asks the decorator for the bubble tail horizonal space till its body that corresponds to the message at the specified indexPath
    ///
    /// - parameter messagesView: The messages view object displaying the flow layout
    /// - parameter layout:       The layout object requesting the information
    /// - parameter indexPath:    The layout object requesting the information
    ///
    /// - returns: The bubble tail horizontal space at the specified indexPath
    func messagesView(_ messagesView: CKMessagesView, layout: CKMessagesViewLayout, bubbleTailHorizontalSpaceAt indexPath: IndexPath) -> CGFloat?
    
}

public extension CKMessagesViewDecorating {
    
    
    /// Asks the decorator for the text of the `topLabel` for the item at the specified indexPath
    ///
    /// - parameter messagesView: The messages view object displaying the flow layout
    /// - parameter layout:       The layout object requesting the information
    /// - parameter at:           The index path of the item
    ///
    /// - returns: The text of the `topLabel` for the item at indexPath
    ///
    func messagesView(_ messagesView: CKMessagesView, layout: CKMessagesViewLayout, textForTopLabelAt indexPath: IndexPath) -> String? {
        return nil
    }
    
    
    /// Asks the decorator for the attributed text of the `topLabel` for the item at the specified indexPath
    ///
    /// - parameter messagesView: The messages view object displaying the flow layout
    /// - parameter layout:       The layout object requesting the information
    /// - parameter at:           The index path of the item
    ///
    /// - returns: The attributed text of the `topLabel` for the item at indexPath
    ///
    func messagesView(_ messagesView: CKMessagesView, layout: CKMessagesViewLayout, attributedTextForTopLabelAt indexPath: IndexPath) -> NSAttributedString? {
        return nil
    }
    
    /// Asks the decorator for the height of the `topLabel` for the item at the specified indexPath
    ///
    /// If return `nil` from this method, `CKMessagesViewLayout` will use the text of `CKMessageData` to calculate the height
    ///
    /// - parameter messagesView: The messages view object displaying the flow layout
    /// - parameter layout:       The layout object requesting the information
    /// - parameter at:           The index path of the item
    ///
    /// - returns: The height of the `topLabel` for the item at indexPath
    ///
    func messagesView(_ messagesView: CKMessagesView, layout: CKMessagesViewLayout, heightForTopLabelAt indexPath: IndexPath) -> CGFloat? {
        return nil
    }
    
    
    /// Asks the decorator for the text of the `bubbleTopLabel` for the item at the specified indexPath
    ///
    /// - parameter messagesView: The messages view object displaying the flow layout
    /// - parameter layout:       The layout object requesting the information
    /// - parameter at:           The index path of the item
    ///
    /// - returns: The text of the `messageTopLabel` for the item at indexPath
    ///
    func messagesView(_ messagesView: CKMessagesView, layout: CKMessagesViewLayout, textForBubbleTopLabelAt indexPath: IndexPath) -> String? {
        return nil
    }
    
    /// Asks the decorator for the attributed text of the `bubbleTopLabel` for the item at the specified indexPath
    ///
    /// - parameter messagesView: The messages view object displaying the flow layout
    /// - parameter layout:       The layout object requesting the information
    /// - parameter at:           The index path of the item
    ///
    /// - returns: The attributed text of the `messageTopLabel` for the item at indexPath
    ///
    func messagesView(_ messagesView: CKMessagesView, layout: CKMessagesViewLayout, attributedTextForBubbleTopLabelAt indexPath: IndexPath) -> NSAttributedString? {
        return nil
    }
    
    /// Asks the decorator for the height of the `bubbleTopLabel` for the item at the specified indexPath
    ///
    /// - parameter messagesView: The messages view object displaying the flow layout
    /// - parameter layout:       The layout object requesting the information
    /// - parameter at:           The index path of the item
    ///
    /// - returns: The height of the `messageTopLabel` for the item at indexPath
    ///
    func messagesView(_ messagesView: CKMessagesView, layout: CKMessagesViewLayout, heightForBubbleTopLabelAt indexPath: IndexPath) -> CGFloat? {
        return nil
    }
    
    /// Asks the decorator for the text of the `bottomLabel` for the item at the specified indexPath
    ///
    /// - parameter messagesView: The messages view object displaying the flow layout
    /// - parameter layout:       The layout object requesting the information
    /// - parameter at:           The index path of the item
    ///
    /// - returns: The text of the `bottomLabel` for the item at indexPath
    ///
    func messagesView(_ messagesView: CKMessagesView, layout: CKMessagesViewLayout, textForBottomLabelAt indexPath: IndexPath) -> String? {
        return nil
    }
    
    /// Asks the decorator for the attributed text of the `bottomLabel` for the item at the specified indexPath
    ///
    /// - parameter messagesView: The messages view object displaying the flow layout
    /// - parameter layout:       The layout object requesting the information
    /// - parameter at:           The index path of the item
    ///
    /// - returns: The attributed text of the `bottomLabel` for the item at indexPath
    ///
    func messagesView(_ messagesView: CKMessagesView, layout: CKMessagesViewLayout, attributedTextForBottomLabelAt indexPath: IndexPath) -> NSAttributedString? {
        return nil
    }
    
    /// Asks the decorator for the height of the `bottomLabel` for the item at the specified indexPath
    ///
    /// - parameter messagesView: The messages view object displaying the flow layout
    /// - parameter layout:       The layout object requesting the information
    /// - parameter at:           The index path of the item
    ///
    /// - returns: The height of the `bottomLabel` for the item at indexPath
    ///
    func messagesView(_ messagesView: CKMessagesView, layout: CKMessagesViewLayout, heightForBottomLabelAt indexPath: IndexPath) -> CGFloat? {
        return nil
    }
    
    /// Asks the decorator for the bubble image data that corresponds to the message at the specified indexPath
    ///
    /// - parameter messagesView: The messages view object displaying the flow layout
    /// - parameter layout:       The layout object requesting the information
    /// - parameter at:           The index path of the item
    ///
    /// - returns: The bubble image data of the message at the specified indexPath
    ///
    func messagesView(_ messagesView: CKMessagesView, layout: CKMessagesViewLayout, messageBubbleAt indexPath: IndexPath) -> CKMessageBubbleImageData? {
        
        if let message = messagesView.messenger?.messageForItem(at: indexPath, of: messagesView),
            let senderId = messagesView.messenger?.senderId {
            
            if message.senderId == senderId  {
                
                return CKMessagesBubbleImageFactory.defaultOutgoingBubbleImage
                
            } else {
                return CKMessagesBubbleImageFactory.defaultIncomingBubbleImage
            }
            
        }
        
        return nil
    }
    
    /// Asks the decorator for the avatar image data that corresponds to the message at the specified indexPath
    ///
    /// - parameter messagesView: The messages view object displaying the flow layout
    /// - parameter layout:       The layout object requesting the information
    /// - parameter at:           The index path of the item
    ///
    /// - returns: The avatar image data of the message at the specified indexPath
    ///
    func messagesView(_ messagesView: CKMessagesView, layout: CKMessagesViewLayout, avatarAt indexPath: IndexPath) -> CKMessagesAvatarImageData? {
        return nil
    }
    
    /// Asks the decorator for the content size that corresponds to the message at the specified indexPath
    ///
    /// If return `nil` from this method, `CKMessagesViewLayout` will use the text of `CKMessageData` to calculate the size,
    /// otherwise, `CKMessagesViewLayout` will just use the return value from this method.
    ///
    /// The content size is just for message content itself, it doesn't include the size of such as
    /// * `topLabel`
    /// * `messageLabel`
    /// * `bottomLabel`
    /// * `avatarImageView`
    /// * `accessoryView`
    ///
    /// These size above will retrieve for their corresponding delegate method,
    /// and `CKMessagesViewLayout` will use them to calculate the finalize size of the whole message cell
    ///
    /// - parameter messagesView: The messages view object displaying the flow layout
    /// - parameter layout:       The layout object requesting the information
    /// - parameter at:           The index path of the item
    ///
    /// - returns: The content size of the message at the specified indexPath
    ///
    func messagesView(_ messagesView: CKMessagesView, layout: CKMessagesViewLayout, messageSizeAt indexPath: IndexPath) -> CGSize? {
        return nil
    }
    
    /// Asks the decorator for the message insets that corresponds to the message at the specified indexPath
    ///
    /// If return `nil` from this method, `CKMessagesViewLayout` will use the value of its property `messageInsets`,
    /// otherwise, `CKMessagesViewLayout` will just use the return value from this method.
    ///
    ///
    /// These size above will retrieve for their corresponding delegate method,
    /// and `CKMessagesViewLayout` will use them to calculate the finalize size of the whole message cell
    ///
    /// - parameter messagesView: The messages view object displaying the flow layout
    /// - parameter layout:       The layout object requesting the information
    /// - parameter at:           The layout object requesting the information
    ///
    /// - returns: The insets of the message at the specified indexPath
    ///
    func messagesView(_ messagesView: CKMessagesView, layout: CKMessagesViewLayout, messageInsetsAt indexPath: IndexPath) -> UIEdgeInsets? {
        return nil
    }
    
    /// Asks the decorator for the bubble tail horizonal space till its body that corresponds to the message at the specified indexPath
    ///
    /// - parameter messagesView: The messages view object displaying the flow layout
    /// - parameter layout:       The layout object requesting the information
    /// - parameter indexPath:    The layout object requesting the information
    ///
    /// - returns: The bubble tail horizontal space at the specified indexPath
    func messagesView(_ messagesView: CKMessagesView, layout: CKMessagesViewLayout, bubbleTailHorizontalSpaceAt indexPath: IndexPath) -> CGFloat? {
        return nil
    }
    
    
    
}

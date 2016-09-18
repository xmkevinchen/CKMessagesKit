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
    func messagesView(_ messagesView: CKMessagesView, layout: CKMessagesViewLayout, messageBubbleAt indexPath: IndexPath) -> CKMessagesBubbleImageData?
    
    /// Asks the decorator for the avatar image data that corresponds to the message at the specified indexPath
    ///
    /// - parameter messagesView: The messages view object displaying the flow layout
    /// - parameter layout:       The layout object requesting the information
    /// - parameter at:           The index path of the item
    ///
    /// - returns: The avatar image data of the message at the specified indexPath
    ///
    func messagesView(_ messagesView: CKMessagesView, layout: CKMessagesViewLayout, avatarAt indexPath: IndexPath) -> CKMessagesAvatarImageData?
    
    
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
    func messagesView(_ messagesView: CKMessagesView, layout: CKMessagesViewLayout, messageBubbleAt indexPath: IndexPath) -> CKMessagesBubbleImageData? {
               
        
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
    

    
}

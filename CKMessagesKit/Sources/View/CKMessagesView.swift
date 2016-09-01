//
//  CKMessagesView.swift
//  CKCollectionViewForDataCard
//
//  Created by Kevin Chen on 8/24/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import UIKit

public protocol CKMessagesViewMessaging: class {
    
    var senderId: String { get }
    var sender: String { get }
    
    func messageForItem(at indexPath: IndexPath, of messagesView: CKMessagesView) -> CKMessageData
    
}


public protocol CKMessagesViewDecorating: NSObjectProtocol {
    
    func textForTop(at indexPath: IndexPath, of messagesView: CKMessagesView) -> String?
    func attributedTextForTop(at indexPath: IndexPath, of messagesView: CKMessagesView) -> NSAttributedString?
    
    func textForMessageTop(at indexPath: IndexPath, of messagesView: CKMessagesView) -> String?
    func attributedTextForMessageTop(at indexPath: IndexPath, of messagesView: CKMessagesView) -> NSAttributedString?
    
    func textForBottom(at indexPath: IndexPath, of messagesView: CKMessagesView) -> String?
    func attributedTextForBottom(at indexPath: IndexPath, of messagesView: CKMessagesView) -> NSAttributedString?
    
    func messageBubbleImage(at indexPath: IndexPath, of messagesView: CKMessagesView) -> CKMessageBubbleImageData?
    
    func contentSize(at indexPath: IndexPath, of messagesView: CKMessagesView) -> CGSize
    
}




open class CKMessagesView: UICollectionView {
    
    open weak var decorator: CKMessagesViewDecorating?
    open weak var messenger: CKMessagesViewMessaging?
    
    var messagesViewLayout: CKMessagesViewLayout {
        guard let layout = collectionViewLayout as? CKMessagesViewLayout else {
            fatalError("The layout of messagesView must be \(CKMessagesViewLayout.self)")
        }
        
        return layout
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        configure()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    
    
    private func configure() {
        
        translatesAutoresizingMaskIntoConstraints = false
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        keyboardDismissMode = .interactive
        alwaysBounceVertical = true
        bounces = true
        
        if #available(iOS 10, *) {
            isPrefetchingEnabled = true
        }
    }
    
}


public extension CKMessagesViewDecorating {
    
    
    func textForTop(at indexPath: IndexPath, of messagesView: CKMessagesView) -> String? {
        return nil
    }
    
    func attributedTextForTop(at indexPath: IndexPath, of messagesView: CKMessagesView) -> NSAttributedString? {
        return nil
    }
    
    func textForMessageTop(at indexPath: IndexPath, of messagesView: CKMessagesView) -> String? {
        return nil
    }
    
    func attributedTextForMessageTop(at indexPath: IndexPath, of messagesView: CKMessagesView) -> NSAttributedString? {
        return nil
    }
    
    func textForBottom(at indexPath: IndexPath, of messagesView: CKMessagesView) -> String? {
        return nil
    }
    
    func attributedTextForBottom(at indexPath: IndexPath, of messagesView: CKMessagesView) -> NSAttributedString? {
        return nil
    }
    
    func messageBubbleImage(at indexPath: IndexPath, of messagesView: CKMessagesView) -> CKMessageBubbleImageData? {
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
    
    func contentSize(at indexPath: IndexPath, of messagesView: CKMessagesView) -> CGSize {
        return .zero
    }
    
    
    
    
}

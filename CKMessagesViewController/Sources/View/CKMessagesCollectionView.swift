//
//  CKMessagesCollectionView.swift
//  CKCollectionViewForDataCard
//
//  Created by Kevin Chen on 8/24/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import UIKit

public protocol CKMessagesViewDataSource: UICollectionViewDataSource {
    
    var senderId: String { get }
    var sender: String { get }
    
    func messageView(_ messageView: CKMessagesCollectionView, messageForItemAt indexPath: IndexPath) -> CKMessageData
    
    func messageView(_ messageView: CKMessagesCollectionView, messageBubbleImageAt indexPath: IndexPath) -> CKMessageBubbleImageData?
}

@objc public protocol CKMessagesViewDelegate: UICollectionViewDelegateFlowLayout {
    
    @objc optional func messageView(_ messageView: CKMessagesCollectionView, textForTopAt indexPath: IndexPath) -> String?
    @objc optional func messageView(_ messageView: CKMessagesCollectionView, attributedTextForTopAt indexPath: IndexPath) -> NSAttributedString?
    
    @objc optional func messageView(_ messageView: CKMessagesCollectionView, textForMessageTopAt indexPath: IndexPath) -> String?
    @objc optional func messageView(_ messageView: CKMessagesCollectionView, attributedTextForMessageTopAt indexPath: IndexPath) -> NSAttributedString?
    
    @objc optional func messageView(_ messageView: CKMessagesCollectionView, textForBottomAt indexPath: IndexPath) -> String?
    @objc optional func messageView(_ messageView: CKMessagesCollectionView, attributedTextForBottom indexPath: IndexPath) -> NSAttributedString?
        
    @objc optional func messageView(_ messageView: CKMessagesCollectionView, sizeForMessageContainerAt indexPath: IndexPath) -> CGSize
}


open class CKMessagesCollectionView: UICollectionView {
    
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


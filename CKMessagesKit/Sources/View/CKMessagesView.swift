//
//  CKMessagesView.swift
//  CKCollectionViewForDataCard
//
//  Created by Kevin Chen on 8/24/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import UIKit

open class CKMessagesView: UICollectionView {
    
    open weak var decorator: CKMessagesViewDecorating?
    open weak var messenger: CKMessagesViewMessaging?
    
    public var messagesViewLayout: CKMessagesViewLayout {
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



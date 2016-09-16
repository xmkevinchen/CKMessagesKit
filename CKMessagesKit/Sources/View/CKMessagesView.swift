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
    
    var registeredPresentors = [String: CKRegisteredPresentor]()
    
    var presentorsQueue = [CKMessagePresentor]()
    
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
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        
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
        
        register(for: CKMessageBasicCell.self)
        register(for: CKMessageBasicCell.self)
        register(for: CKMessageTextCell.self)
        register(forSupplementaryView: UICollectionElementKindSectionFooter, for: CKMessagesIndicatorFooterView.self)

    }
    
    
    /// Register a presentor class / struct for specified message type
    ///
    /// - parameter presentor:  The concrete type of CKMessagePresentor
    /// - parameter identifier: The identifier of the registering CKMessagePresentor
    /// - parameter message:       The concrete type of CKMessageData
    public func register(presentor: CKMessagePresentor.Type,
                         with identifier: String,
                         for message: CKMessageData.Type) {
        
        let registration = CKRegisteredPresentor(identifier: identifier, presentor: presentor, message: message)
        registeredPresentors[identifier] = registration
    }
    
    
    /// Dequeue or create a presentor for current presenting cell
    ///
    /// - parameter identifier: presentor identifier
    /// - parameter message:    The concrete messages type
    /// - parameter indexPath:  indexPath of cell
    ///
    /// - returns: instance of CKMessagePresentor if found match registered presentor metadata, otherwise return nil
    public func dequeueReusablePresentor(with identifier: String,
                                         for message: CKMessageData.Type,
                                         at indexPath: IndexPath) -> CKMessagePresentor? {
        
        return nil
        
    }
    
    struct CKRegisteredPresentor {
        
        let identifier: String
        let presentor: CKMessagePresentor.Type
        let message: CKMessageData.Type
        
    }
    
    struct CKReusablePresentor {
        let identifier: String
        let presentor: CKMessagePresentor
        let message: CKMessageData.Type
    }
    
    
}



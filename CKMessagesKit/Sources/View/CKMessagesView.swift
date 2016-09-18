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
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
//        print("===> using: \(presentorQueue.using)")
//        print("===> reusable: \(presentorQueue.reusable)")
        
        
    }
    
    
    private func configure() {
        
        translatesAutoresizingMaskIntoConstraints = false
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        keyboardDismissMode = .interactive
        alwaysBounceVertical = true
        bounces = true
        
        if #available(iOS 10, *) {
            // TODO: Need to figure out how to fix the miss-attaching presentor to wrong indexPath cell
            isPrefetchingEnabled = false
        }
        
        register(for: CKMessageBasicCell.self)
        register(forSupplementaryView: UICollectionElementKindSectionFooter, for: CKMessagesIndicatorFooterView.self)
        

    }
    
    var registeredPresentors = [String: CKRegisteredPresentor]()
    var presentorQueue = CKMessagePresentorQueue()
    
    /// Register a presentor class / struct for specified message type
    ///
    /// - parameter presentor:  The concrete type of CKMessagePresentor
    /// - parameter message:       The concrete type of CKMessageData
    public func register(presentor: CKMessagePresentor.Type,
                         of message: CKMessageData.Type) {
        
        let registration = CKRegisteredPresentor(presentor: presentor, message: message)
        registeredPresentors[String(describing: message)] = registration
    }
    
    
    /// Dequeue or create a presentor for current presenting cell
    ///
    /// - parameter message:    The concrete messages type
    /// - parameter indexPath:  indexPath of cell
    ///
    /// - returns: instance of CKMessagePresentor if found match registered presentor metadata, otherwise throw fatalError()
    public func dequeueReusablePresentor(of message: CKMessageData.Type,
                                         at indexPath: IndexPath) -> CKMessagePresentor {
        
        if let presentor = presentorQueue.using[indexPath] {
            
            if presentor.message != nil && type(of: presentor.message!) == message {
                return presentor
            }
            
            presentorQueue.using.removeValue(forKey: indexPath)
            presentorQueue.reusable.append(presentor)
        }
        
        if let registered = registeredPresentors[String(describing: message)] {
            
            var presentor: CKMessagePresentor
            
            var selectedIndex: Int?
            for (index, presentor) in presentorQueue.reusable.enumerated() {
                if presentor.message != nil && type(of: presentor.message) == message {
                    selectedIndex = index
                    break
                }
            }
            
            if selectedIndex != nil {
                presentor = presentorQueue.reusable.remove(at: selectedIndex!)
                presentor.prepareForReuse()
            } else {
                presentor = registered.presentor.presentor()
            }

            presentorQueue.using[indexPath] = presentor            
            return presentor
            
        } else {
            fatalError()
        }
        
    }
    
    public func recycleReusablePresentor(at indexPath: IndexPath) {
        
        if let presentor = presentorQueue.using[indexPath] {
            presentorQueue.using.removeValue(forKey: indexPath)
            presentorQueue.reusable.append(presentor)
            presentor.messageView.removeFromSuperview()
        }
    
    }
    
    public func prefetchPresentors(at indexPaths: [IndexPath]) {
        
        indexPaths.forEach { indexPath in
            if let message = self.messenger?.messageForItem(at: indexPath, of: self) {
                _ = dequeueReusablePresentor(of: type(of: message), at: indexPath)
            }
        }
        
    }
    
    
    /// Presentor is being used for the cell at indexPath
    ///
    /// - returns: if the cell at indexPath return its associated presentor, otherwise return nil
    
    public func presentor(at indexPath: IndexPath) -> CKMessagePresentor? {
        
        if let message = messenger?.messageForItem(at: indexPath, of: self) {
            return dequeueReusablePresentor(of: type(of:message), at: indexPath)
        }
        
        return nil
        
    }
    
    struct CKRegisteredPresentor {
        
        let presentor: CKMessagePresentor.Type
        let message: CKMessageData.Type
        
    }
    
    class CKMessagePresentorQueue {
        var using: [IndexPath: CKMessagePresentor] = [:]
        var reusable: [CKMessagePresentor] = []
    }
    
    
}



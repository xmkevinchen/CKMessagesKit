//
//  CKMessagePresentor.swift
//  CKMessagesKit
//
//  Created by Kevin Chen on 9/16/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import UIKit
import QuartzCore

/// Protocol where defines the basic requirement for presenting a message in the `CKMessagesView` with its cells
public protocol CKMessagePresentor: class {
    
    var identifier: String { get }
    var messageView: UIView { get }
    var message: CKMessageData? { get set }
    
    static func presentor() -> CKMessagePresentor
    
    func prepareForReuse()
    func update(with message: CKMessageData)
}

public extension CKMessagePresentor {
    
    var identifier: String {
        return String(describing: type(of: self))
    }
}

public extension CKMessagePresentor where Self: UIViewController {
    
    var messagesViewController: CKMessagesViewController? {
        
        var parentVC: UIViewController? = parent
        
        while parentVC != nil && !(parentVC! is CKMessagesViewController) {
            parentVC = parentVC?.parent
        }
        
        return parentVC as? CKMessagesViewController
        
    }
    
}

/// Embeddable presentor
public protocol CKMessageEmbeddablePresentor: CKMessagePresentor {
    
    
    /// The insets of the message view inside the message bubble
    var insets: UIEdgeInsets { get }
}


/// A protocol inherits from `CKMessagePresentor`
/// where gives presentor a capability to resize its message view
/// when message content changed
public protocol CKMessageSizablePresentor: CKMessagePresentor {
    
    /// The size of message content
    func size(of trait: UITraitCollection) -> CGSize
            
}

/// A protocol inherits from `CKMessagePresentor` protocol, indicates it's maskable presentor

public protocol CKMessageMaskablePresentor: CKMessageSizablePresentor {

    var isMessageBubbleHidden: Bool { get }
}



/// A protocol inherits from `CKMessagePresentor`
/// gives the presentor could define its processing message response view
/// where the processing message has restricted response requirement
/// The `responseView` could be treat as `inputView` of `CKMessagesViewController`
/// The `accessoryView` could be used as `inputAccessoryView` of `CKMessagesViewController`
public protocol CKMessageResponsiblePresentor: CKMessagePresentor {
    
    
    var responseView: UIView? { get }
    
    var accessoryView: UIView? { get }
    
}

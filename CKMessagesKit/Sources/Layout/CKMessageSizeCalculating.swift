//
//  CKMessageSizeCalculating.swift
//  CKMessagesViewController
//
//  Created by Kevin Chen on 8/27/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import Foundation

/// Message size holder of all configurable components of built-in cells
public protocol CKMessageCalculatingSize {
    /// The size of message content itself
    var messageSize: CGSize { get }
    
    /// The insets of message
    var messageInsets: UIEdgeInsets { get }
    
    /// The size of top label
    var topLabel: CGSize { get }
    
    /// The size of bubble top label
    var bubbleTopLabel: CGSize { get }
    
    /// The size of bottom label
    var bottomLabel: CGSize { get }
    
    /// The size of avatar image
    var avatar: CGSize { get }
    
    /// The size of accessory view
    var accessory: CGSize { get }
}


public struct CKMessageCalculatedSize: CKMessageCalculatingSize {
    
    /// The size of message content itself
    public var messageSize: CGSize = .zero
    
    /// The insets of message
    public var messageInsets: UIEdgeInsets = .zero
    
    /// The size of top label
    public var topLabel: CGSize = .zero
    
    /// The size of bubble top label
    public var bubbleTopLabel: CGSize = .zero
    
    /// The size of bottom label
    public var bottomLabel: CGSize = .zero
    
    /// The size of avatar image
    public var avatar: CGSize = .zero
    
    /// The size of accessory view
    public var accessory: CGSize = .zero
    
    
    public static var zero: CKMessageCalculatedSize {
        return CKMessageCalculatedSize(messageSize: .zero, messageInsets: .zero, topLabel: .zero, bubbleTopLabel: .zero, bottomLabel: .zero, avatar: .zero, accessory: .zero)
    }
}

public protocol CKMessageSizeCalculating {
    
    func size(of message: CKMessageData, at indexPath: IndexPath, with layout: CKMessagesViewLayout) -> CKMessageCalculatingSize
    
    func prepareForResetting(layout: CKMessagesViewLayout)
    
}

//
//  CKMessageLayout.swift
//  CKMessagesViewController
//
//  Created by Kevin Chen on 8/26/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import CoreGraphics

/// A type that can layout itself and its contents
public protocol CKViewLayout {
    
    /// The type of the leaf content elements in this layout.
    associatedtype Content
    
    /// Lay out this layout and all of its contained layouts within `rect`.
    func layout(in rect: CGRect)
            
    /// Return all of the leaf content elements contained in this layout and its descendants.
    var contents: [Content] { get }
}




//
//  CKMessageSizeCalculating.swift
//  CKMessagesViewController
//
//  Created by Kevin Chen on 8/27/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import Foundation

public struct CKMessageSize {
    let container: CGSize
    let content: CGSize
    
    public static var zero: CKMessageSize {
        return CKMessageSize(container: .zero, content: .zero)
    }
}

public protocol CKMessageSizeCalculating {
    
    func size(of message: CKMessageData, at indexPath: IndexPath, with layout: CKMessagesViewLayout) -> CGSize
    
    func prepareForResetting(layout: CKMessagesViewLayout)
    
}

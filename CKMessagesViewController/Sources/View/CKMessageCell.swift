//
//  CKMessageCell.swift
//  CKMessagesViewController
//
//  Created by Chen Kevin on 8/24/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//


public protocol CKMessageCell {
    
    static func nib() -> UINib
    static func identifier() -> String
}


public protocol CKMessagePresenting {
    
    var presentingView: UIView { get }
    
    // Prepare for reuse
    func prepareForReuse()
    
}

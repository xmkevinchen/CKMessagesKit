//
//  CKMessagePresenting.swift
//  CKMessagesViewController
//
//  Created by Kevin Chen on 8/24/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//



public protocol CKMessagePresenting {
    
    associatedtype Message: CKMessageData
    
    static func presentor(with message: Message) -> Self
    
    var messageView: UIView { get }
    
    func refresh(with message: Message)
    
    
    
}

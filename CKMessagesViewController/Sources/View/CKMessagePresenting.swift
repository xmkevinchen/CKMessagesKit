//
//  CKMessagePresenting.swift
//  CKMessagesViewController
//
//  Created by Kevin Chen on 8/24/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//



public protocol CKMessagePresenting {
    
                
    static func presentor(with message: CKMessageData) -> CKMessagePresenting
    
    var messageView: UIView { get }
    var messageType: CKMessageData.Type { get }        
    var message: CKMessageData? { get set }
    
    
    func renderPresenting(with message: CKMessageData)
}

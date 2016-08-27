//
//  CKMessagePresenting.swift
//  CKMessagesViewController
//
//  Created by Kevin Chen on 8/24/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//



public protocol CKMessagePresenting {
                            
    var messageView: UIView { get }
    var messageType: CKMessageData.Type { get }        
    var message: CKMessageData? { get set }
    
    static func presentor() -> CKMessagePresenting
    func renderPresenting(with message: CKMessageData)
}

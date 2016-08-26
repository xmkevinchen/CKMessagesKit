//
//  CKTextMessage.swift
//  CKMessagesViewController
//
//  Created by Kevin Chen on 8/24/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import Foundation

public struct CKTextMessage: CKMessageData {
        
    public var senderId: String
    public var sender: String
    public var message: String
    public var timestamp: Date
    
    public init(senderId: String, sender: String, message: String, timestamp: Date = Date()) {
        self.senderId = sender
        self.sender = sender
        self.message = message
        self.timestamp = timestamp
    }
    

}

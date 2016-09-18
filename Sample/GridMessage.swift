//
//  CollectionMessage.swift
//  CKMessagesViewController
//
//  Created by Chen Kevin on 8/27/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import Foundation
import CKMessagesKit

struct GridMessage: CKMessageData, Hashable {
    
    public var senderId: String
    public var sender: String
    public var text: String
    public var timestamp: Date
    
    public init(senderId: String, sender: String, text: String, timestamp: Date = Date()) {
        self.senderId = senderId
        self.sender = sender
        self.text = text
        self.timestamp = timestamp
    }
        
}

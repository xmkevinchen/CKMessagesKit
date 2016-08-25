//
//  CKMessageData.swift
//  CKMessagesViewController
//
//  Created by Kevin Chen on 8/24/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import Foundation

public protocol CKMessageData {
    
    var senderId: String { get }
    var sender: String { get }
    var text: String { get }
    var timestamp: Date { get }
    
    init(senderId: String, sender: String, text: String, timestamp: Date)
    
}

extension CKMessageData {
    
    public static func == (lhs:Self, rhs: Self) -> Bool {
        return lhs.senderId == rhs.senderId
            && lhs.sender == rhs.sender
            && lhs.text == rhs.text
            && lhs.timestamp == rhs.timestamp

    }
}




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
    var timestamp: Date { get }
    
    
    /// Hash value of message
    /// The default implementation of `CKMessageSizeCalculating` protocol strongly depends on its value's differentiate
    /// If different messages have same hash value the wrong cached message size would be used inproperly
    var hash: Int { get }
    
}


extension CKMessageData where Self: Hashable {
    
    public var hash: Int {
        return hashValue
    }
        
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.senderId == rhs.senderId
            && lhs.timestamp == rhs.timestamp
    }

}






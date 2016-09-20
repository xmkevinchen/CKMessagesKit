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






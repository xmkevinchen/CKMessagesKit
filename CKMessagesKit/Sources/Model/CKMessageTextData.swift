//
//  CKMessageTextData.swift
//  CKMessagesKit
//
//  Created by Kevin Chen on 9/19/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import Foundation

public protocol CKMessageTextData: CKMessageData {
    
    var text: String { get }
}

public extension CKMessageTextData where Self: Hashable {
    
    public var hashValue: Int {
        return "\(senderId).\(text).\(timestamp)".hashValue
    }
    
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.senderId == rhs.senderId
            && lhs.timestamp == rhs.timestamp
            && lhs.text == rhs.text
    }
}

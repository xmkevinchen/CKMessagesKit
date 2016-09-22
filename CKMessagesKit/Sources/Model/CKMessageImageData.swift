//
//  CKMessageImageData.swift
//  CKMessagesKit
//
//  Created by Kevin Chen on 9/19/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import Foundation

public protocol CKMessageImageData: CKMessageData {
    
    var imageURL: URL { get }
    var image: UIImage? { get }
    
}

extension CKMessageImageData where Self: Hashable {
    
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        
        return lhs.senderId == rhs.senderId
            && lhs.timestamp == rhs.timestamp
            && lhs.imageURL == rhs.imageURL        
    }
    
    public var hashValue: Int {
         return "\(senderId).\(timestamp).\(imageURL)".hashValue        
    }
    
}

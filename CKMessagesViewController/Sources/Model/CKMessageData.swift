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

}







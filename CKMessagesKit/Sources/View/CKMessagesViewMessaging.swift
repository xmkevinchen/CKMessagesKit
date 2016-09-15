//
//  CKMessagesViewMessaging.swift
//  CKMessagesKit
//
//  Created by Kevin Chen on 9/14/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import UIKit

public protocol CKMessagesViewMessaging: class {
    
    var senderId: String { get }
    var sender: String { get }
    
    func messageForItem(at indexPath: IndexPath, of messagesView: CKMessagesView) -> CKMessageData
    
}

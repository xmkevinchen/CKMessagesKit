//
//  CKExtendMessageData.swift
//  CKMessagesViewController
//
//  Created by Chen Kevin on 8/27/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import Foundation

public protocol CKExtendMessageData: CKMessageData {
    
    var metadata: [String: Any] { get }
    
    
}

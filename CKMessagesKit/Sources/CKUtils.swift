//
//  CKUtils.swift
//  CKMessagesViewController
//
//  Created by Kevin Chen on 8/25/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import Foundation

public func address(of value: NSObject?) -> String {
    
    if value == nil {
        return "<nil>"
    }
    
    
    return String(format: "%p", value!)
}

//
//  Bundle+CKMessagesAssets.swift
//  CKMessagesViewController
//
//  Created by Kevin Chen on 8/28/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import Foundation

extension Bundle {
    
    static var messages: Bundle {
        return Bundle(for: CKMessagesViewController.self)
    }
        
    
}

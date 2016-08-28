//
//  CKMessageSizeCalculating.swift
//  CKMessagesViewController
//
//  Created by Kevin Chen on 8/27/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import Foundation

public protocol CKMessageContentSizeCalculating {
    
    func size(of message: CKMessageData, at indexPath: IndexPath, with layout: CKMessagesCollectionViewLayout) -> CGSize
    
    func prepareForResetting(layout: CKMessagesCollectionViewLayout)
    
}

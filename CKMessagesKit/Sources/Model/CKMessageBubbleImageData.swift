//
//  CKMessageBubbleImageData.swift
//  CKMessagesViewController
//
//  Created by Kevin Chen on 8/28/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import Foundation

public protocol CKMessageBubbleImageData {
    var image: UIImage { get }
    var highlightedImage: UIImage { get }
}

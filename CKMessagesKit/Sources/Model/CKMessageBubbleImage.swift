//
//  CKMessageBubbleImage.swift
//  CKMessagesViewController
//
//  Created by Kevin Chen on 8/28/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import Foundation

public struct CKMessageBubbleImage: CKMessageBubbleImageData {
    
    public let image: UIImage
    
    public let highlightedImage: UIImage
    
    public init(image: UIImage, highlightedImage: UIImage) {
        self.image = image
        self.highlightedImage = highlightedImage
    }
    
}

//
//  CKMessagesBubbleImageFactory.swift
//  CKMessagesViewController
//
//  Created by Kevin Chen on 8/28/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import Foundation

public class CKMessagesBubbleImageFactory {
    
    public var direction: UIUserInterfaceLayoutDirection
    
    public let bubbleImage: UIImage
    public let capInsets: UIEdgeInsets
    
    public init(bubbleImage: UIImage, capInsets: UIEdgeInsets, direction: UIUserInterfaceLayoutDirection) {
        self.bubbleImage = bubbleImage
        if capInsets == .zero {
            self.capInsets = bubbleImage.size.centerInsets()
        } else {
            self.capInsets = capInsets
        }
        self.direction = direction
    }
    
    public convenience init() {
        
        self.init(bubbleImage: UIImage.bubbleCompat,
                  capInsets: .zero,
                  direction: UIApplication.shared.userInterfaceLayoutDirection)
    }
    
    public func outgoingBubbleImage(with color: UIColor) -> CKMessageBubbleImage {
        return bubbleImage(with: color, flipped: false ^ isRTL)
    }
    
    public func incomingBubbleImage(with color: UIColor) -> CKMessageBubbleImage {
        return bubbleImage(with: color, flipped: true ^ isRTL)
    }
    
    var isRTL: Bool {
        return direction == .rightToLeft
    }
    
    private func bubbleImage(with color: UIColor, flipped: Bool) -> CKMessageBubbleImage {
        var normal = bubbleImage.with(mask: color)
        var highlight = bubbleImage.with(mask: color.darken(with: 0.12))
        
        if flipped {
            normal = normal.flippedHorizontal()
            highlight = highlight.flippedHorizontal()
        }
        
        return CKMessageBubbleImage(image: normal.stretchable(with: capInsets),
                                    highlightedImage: highlight.stretchable(with: capInsets))
        
    }
    
    public static var defaultIncomingBubbleImage: CKMessageBubbleImageData = {
        let factory = CKMessagesBubbleImageFactory()
        return factory.incomingBubbleImage(with: UIColor.messageBubbleBlue)
    }()
    
    public static var defaultOutgoingBubbleImage: CKMessageBubbleImageData = {
        let factory = CKMessagesBubbleImageFactory()
        return factory.outgoingBubbleImage(with: UIColor.messageBubbleLightGray)
    }()
    
}





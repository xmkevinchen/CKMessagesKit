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
        
        self.init(bubbleImage: UIImage.bubbleCompatImage,
                  capInsets: .zero,
                  direction: UIApplication.shared.userInterfaceLayoutDirection)
    }
    
    func outgoingBubbleImage(with color: UIColor) -> CKMessageBubbleImage {
        return bubbleImage(with: color, flipped: false)
    }
    
    func incomingBubbleImage(with color: UIColor) -> CKMessageBubbleImage {
        return bubbleImage(with: color, flipped: true)
    }
    
    var isRTL: Bool {
        return direction == .rightToLeft
    }
    
    private func bubbleImage(with color: UIColor, flipped: Bool) -> CKMessageBubbleImage {
        var normal = bubbleImage.with(mask: color)
        var highlight = bubbleImage.with(mask: color.darken(with: 0.12))
        
        if flipped {
            normal = normal.flippedHorizontally()
            highlight = highlight.flippedHorizontally()
        }
        
        normal = normal.resizableImage(withCapInsets: capInsets, resizingMode: .stretch)
        highlight = highlight.resizableImage(withCapInsets: capInsets, resizingMode: .stretch)
        
        return CKMessageBubbleImage(image: normal, highlightedImage: highlight)
        
    }
    
    
    
}



extension CGSize {
    
    func centerInsets() -> UIEdgeInsets {
        let center = CGPoint(x: width / 2.0, y: height / 2.0)
        return UIEdgeInsets(top: center.y, left: center.x, bottom: center.y, right: center.x)
    }
}

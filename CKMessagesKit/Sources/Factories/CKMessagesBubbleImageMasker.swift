//
//  CKMessageBubbleImageMasker.swift
//  CKMessagesKit
//
//  Created by Kevin Chen on 9/17/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import Foundation

public class CKMessagesBubbleImageMasker {
    
    let bubbleImageFactory: CKMessagesBubbleImageFactory
    
    init(bubbleImageFactory: CKMessagesBubbleImageFactory) {
        self.bubbleImageFactory = bubbleImageFactory
    }
    
    convenience init() {
        self.init(bubbleImageFactory: CKMessagesBubbleImageFactory())
    }
    
    public func apply(to view: UIView, orientation: CKMessageOrientation, size: CGSize? = nil) {
        
        var image: UIImage
        switch orientation {
        case .incoming:
            image = bubbleImageFactory.incomingBubbleImage(with: UIColor.white).image
            
        case .outgoing:
            image = bubbleImageFactory.outgoingBubbleImage(with: UIColor.white).image
            
        }
        
        mask(view, with: image, size: size)
        
    }
    
    private func mask(_ view: UIView, with image: UIImage, size: CGSize? = nil) {
        
        let imageView = UIImageView(image: image)
        var frame = view.bounds
        if size != nil {
            frame.size = size!
        }
        
        imageView.frame = frame
        view.layer.mask = imageView.layer        
        
    }
    
    static public func apply(to view: UIView, orientation: CKMessageOrientation, size: CGSize? = nil) {
        let masker = CKMessagesBubbleImageMasker()
        masker.apply(to: view, orientation: orientation, size: size)
        
    }
    
}

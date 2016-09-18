//
//  CKMessageBubbleImageMasker.swift
//  CKMessagesKit
//
//  Created by Kevin Chen on 9/17/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import Foundation

class CKMessagesBubbleImageMasker {
    
    let bubbleImageFactory: CKMessagesBubbleImageFactory
    
    init(bubbleImageFactory: CKMessagesBubbleImageFactory) {
        self.bubbleImageFactory = bubbleImageFactory
    }
    
    convenience init() {
        self.init(bubbleImageFactory: CKMessagesBubbleImageFactory())
    }
    
    func apply(to view: UIView, orientation: CKMessageOrientation) {
        
        var image: UIImage
        switch orientation {
        case .incoming:
            image = bubbleImageFactory.incomingBubbleImage(with: UIColor.white).image
            
        case .outgoing:
            image = bubbleImageFactory.outgoingBubbleImage(with: UIColor.white).image
            
        }
        
        mask(view, with: image)
        
    }
    
    private func mask(_ view: UIView, with image: UIImage) {
        
        let imageView = UIImageView(image: image)
        imageView.frame = view.frame
        view.layer.mask = imageView.layer        
        
    }
    
    static func apply(to view: UIView, orientation: CKMessageOrientation) {
        let masker = CKMessagesBubbleImageMasker()
        masker.apply(to: view, orientation: orientation)
        
    }
    
}

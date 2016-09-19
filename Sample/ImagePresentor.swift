//
//  ImagePresentor.swift
//  CKMessagesKit
//
//  Created by Kevin Chen on 9/17/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import UIKit
import CKMessagesKit

struct ImageMessage: CKMessageData, Hashable {
    
    public var senderId: String
    public var sender: String
    public var text: String
    public var timestamp: Date
    public var image: UIImage?
    
    public init(senderId: String, sender: String, text: String, timestamp: Date = Date()) {
        self.senderId = senderId
        self.sender = sender
        self.text = text
        self.timestamp = timestamp
        self.image = UIImage(named: "sample-image")
    }
    
}

class ImagePresentor: CKMessagePresentor {
    
    var imageView: UIImageView
    
    init() {
        imageView = UIImageView(frame: .zero)
    }
    
    var messageView: UIView {
        return imageView
    }
    
    var message: CKMessageData? {
        didSet {
            if let message = message as? ImageMessage {
                imageView.image = message.image
                imageView.setNeedsDisplay()
            }
        }
    }
    
    func update(with message: CKMessageData) {
        self.message = message
    }
    
    static func presentor() -> CKMessagePresentor {
        return ImagePresentor()
    }
    
    func prepareForReuse() {
        imageView.image = nil
    }
    
}

extension ImagePresentor: CKMessageSizablePresentor {
    
    public func size(of trait: UITraitCollection) -> CGSize {
        
        var size: CGSize
        switch (trait.horizontalSizeClass, trait.verticalSizeClass) {
            
        case (.compact, .regular):
            size = CGSize(width: 240, height: 135)
            
        default:
            size = CGSize(width: 320, height: 180)
            
        }
        
        return size
    }
    
}

extension ImagePresentor: CKMessageMaskablePresentor {
    var isMessageBubbleHidden: Bool {
        return true
    }
}

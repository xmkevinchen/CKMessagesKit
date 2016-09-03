//
//  CKMessagesAvatarImage.swift
//  CKMessagesKit
//
//  Created by Kevin Chen on 9/2/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import UIKit

public struct CKMessagesAvatarImage: CKMessagesAvatarImageData {
    
    public var avatar: UIImage?
    public var highlighted: UIImage?
    public let placeholder: UIImage
    
    static public func avater(image: UIImage) -> CKMessagesAvatarImage {
        return CKMessagesAvatarImage(avatar: image, highlighted: image, placeholder: image)
    }
    
    static public func avater(placeholder: UIImage) -> CKMessagesAvatarImage {
        return CKMessagesAvatarImage(avatar: nil, highlighted: nil, placeholder: placeholder)
    }
    
    public init(avatar: UIImage?, highlighted: UIImage?, placeholder: UIImage) {
        self.avatar = avatar
        self.highlighted = highlighted
        self.placeholder = placeholder
    }
    
}

//
//  CKMessagesAvatarImageFactory.swift
//  CKMessagesKit
//
//  Created by Kevin Chen on 9/2/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import Foundation

public class CKMessagesAvatarImageFactory {
    
    private let diameter: UInt
    
    public init(diameter: UInt = 30) {
        self.diameter = diameter
    }
    
    public func avatar(placeholder: UIImage) -> CKMessagesAvatarImage {
        let image = placeholder.circular(diameter: diameter)
        return CKMessagesAvatarImage.avater(placeholder: image)
    }
    
    public func avatar(image: UIImage) -> CKMessagesAvatarImage {
        let normal = image.circular(diameter: diameter)
        let highlighted = image.circular(diameter: diameter, highlighted: UIColor(white: 0.1, alpha: 0.3))
        
        return CKMessagesAvatarImage(avatar: normal, highlighted: highlighted, placeholder: normal)
    }
    
    public func avatar(initials: String, backgroundColor: UIColor, textColor: UIColor, font: UIFont) -> CKMessagesAvatarImage {
        
        let image = self.image(initials: initials, backgroundColor: backgroundColor, textColor: textColor, font: font)
        let normal = image.circular(diameter: diameter)
        let highlighted = image.circular(diameter: diameter, highlighted: UIColor(white: 0.1, alpha: 0.3))
        return CKMessagesAvatarImage(avatar: normal, highlighted: highlighted, placeholder: normal)
        
    }
    
    private func image(initials: String, backgroundColor: UIColor, textColor: UIColor, font: UIFont) -> UIImage {
        
        let frame = CGRect(x: 0, y: 0, width: Int(diameter), height: Int(diameter))
        let attributes = [
            NSFontAttributeName: font,
            NSForegroundColorAttributeName: textColor
        ]
        
        let textFrame = NSString(string: initials).boundingRect(with: frame.size,
                                                                options: [.usesLineFragmentOrigin, .usesFontLeading],
                                                                attributes: attributes,
                                                                context: nil)
        let dx = frame.midX - textFrame.midX
        let dy = frame.midY - textFrame.midY
        let drawPoint = CGPoint(x: dx, y: dy)
        
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
        
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(backgroundColor.cgColor)
        context.fill(frame)
        NSString(string: initials).draw(at: drawPoint, withAttributes: attributes)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        return image
        
    }
    
    
}

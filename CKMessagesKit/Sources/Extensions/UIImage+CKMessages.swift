//
//  UIImage+CKMessages.swift
//  CKMessagesViewController
//
//  Created by Kevin Chen on 8/28/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import UIKit

public extension UIImage {
    
    public func with(mask: UIColor) -> UIImage {
        
        let imageRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        var image: UIImage?
        
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        
        let context = UIGraphicsGetCurrentContext()!
        context.scaleBy(x: 1.0, y: -1.0)
        context.translateBy(x: 0.0, y: -(imageRect.size.height))
        context.clip(to: imageRect, mask: cgImage!)
        context.setFillColor(mask.cgColor)
        context.fill(imageRect)
        
        image = UIGraphicsGetImageFromCurrentImageContext()
                        
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    func stretchable(with capInsets: UIEdgeInsets? = nil) -> UIImage {
        return resizableImage(withCapInsets: capInsets ?? size.centerInsets() ,
                              resizingMode: .stretch)
    }
    
    func flippedHorizontal() -> UIImage {
        return UIImage(cgImage: cgImage!, scale: scale, orientation: .upMirrored )
    }
    
    func circular(diameter: UInt, highlighted color: UIColor? = nil) -> UIImage {
        let frame = CGRect(x: 0, y: 0, width: Int(diameter), height: Int(diameter))
        
        UIGraphicsBeginImageContextWithOptions(frame.size, false, scale)
        
        let context = UIGraphicsGetCurrentContext()!
        let path = UIBezierPath(ovalIn: frame)
        path.addClip()
        draw(in: frame)
        
        if color != nil {
            context.setFillColor(color!.cgColor)
            context.fillEllipse(in: frame)
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image!
        
    }
    
}

public extension UIImage {
    
    public static var bubbleCompat: UIImage {
        return UIImage(named: "bubble_min", in: Bundle.messages, compatibleWith: nil)!
    }
    
    public static var accessory: UIImage {
        return UIImage(named: "clip", in: Bundle.messages, compatibleWith: nil)!
    }
    
    public static var typing: UIImage {
        return UIImage(named: "typing", in: Bundle.messages, compatibleWith: nil)!
    }
    
    public static var placeholder: UIImage {
        return UIImage(named: "image-placeholder", in: Bundle.messages, compatibleWith: nil)!
    }
}

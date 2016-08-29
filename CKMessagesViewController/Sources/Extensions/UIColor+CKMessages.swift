//
//  UIColor+CKMessages.swift
//  CKMessagesViewController
//
//  Created by Kevin Chen on 8/28/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import Foundation

extension UIColor {
        
    var isGreyScale: Bool {
        return cgColor.numberOfComponents == 2
    }
    
    func darken(with value: CGFloat) -> UIColor {
        
        let oldComponents = cgColor.components!
        var newComponents = [CGFloat](repeating: 0, count: 4)
        
        if isGreyScale {
            
            newComponents[0] = oldComponents[0] - value < 0.0 ? 0.0 : oldComponents[0] - value
            newComponents[1] = oldComponents[0] - value < 0.0 ? 0.0 : oldComponents[0] - value
            newComponents[2] = oldComponents[0] - value < 0.0 ? 0.0 : oldComponents[0] - value
            newComponents[3] = oldComponents[1]
            
        } else {
            newComponents[0] = oldComponents[0] - value < 0.0 ? 0.0 : oldComponents[0] - value
            newComponents[1] = oldComponents[1] - value < 0.0 ? 0.0 : oldComponents[1] - value
            newComponents[2] = oldComponents[2] - value < 0.0 ? 0.0 : oldComponents[2] - value
            newComponents[3] = oldComponents[3]

        }
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colorRef = CGColor(colorSpace: colorSpace, components: newComponents)
        
        let color = UIColor(cgColor: colorRef!)
        return color
    }
    
}

public extension UIColor {
    
    public static var messageBubbleGreen: UIColor {
        return UIColor(hue: 130.0 / 360.0,
                       saturation: 0.68,
                       brightness: 0.84,
                       alpha: 1.0)
    }
    
    public static var messageBubbleBlue: UIColor {
        return UIColor(hue: 210.0 / 360.0,
                       saturation: 0.94,
                       brightness: 1.0,
                       alpha: 1.0)
    }
    
    public static var messageBubbleRed: UIColor {
        return UIColor(hue: 0.0,
                       saturation: 0.79,
                       brightness: 1.0,
                       alpha: 1.0)
    }
    
    public static var messageBubbleLightGray: UIColor {
        return UIColor(hue: 240.0 / 360.0,
                       saturation: 0.02,
                       brightness: 0.92,
                       alpha: 1.0)
    }
}

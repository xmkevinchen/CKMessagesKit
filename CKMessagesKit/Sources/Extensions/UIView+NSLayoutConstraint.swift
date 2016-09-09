//
//  UIView+NSLayoutConstraint.swift
//  CKMessagesKit
//
//  Created by Chen Kevin on 8/31/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import UIKit

public extension UIView {
    
    public func pinSubview(_ subview: UIView, to attribute: NSLayoutAttribute) {
        
        addConstraint(NSLayoutConstraint(item: self,
                                         attribute: attribute,
                                         relatedBy: .equal,
                                         toItem: subview,
                                         attribute: attribute,
                                         multiplier: 1.0,
                                         constant: 0))
        
    }
    
    public func pinSubview(_ subview: UIView, to attributes: [NSLayoutAttribute] = [.top, .bottom, .leading, .trailing]) {
        attributes.forEach { pinSubview(subview, to: $0) }
    }
    
    
    
}

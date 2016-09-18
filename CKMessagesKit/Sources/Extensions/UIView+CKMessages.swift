//
//  UIView+Mask.swift
//  CKMessagesKit
//
//  Created by Kevin Chen on 9/2/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import UIKit

public extension UIView {
    
    func masked(with image: UIImage, inset: CGFloat = 2.0) {
        
        let imageView = UIImageView(image: image)
        imageView.frame = frame.insetBy(dx: inset, dy: inset)
        layer.mask = imageView.layer
        layer.masksToBounds = true
    }
    
}


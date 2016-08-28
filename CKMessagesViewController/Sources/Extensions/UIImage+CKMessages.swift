//
//  UIImage+CKMessages.swift
//  CKMessagesViewController
//
//  Created by Kevin Chen on 8/28/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import UIKit

extension UIImage {
    
    static var bubbleCompatImage: UIImage {
        return UIImage(named: "bubble_min", in: Bundle(for: CKMessagesViewController.self), compatibleWith: nil)!
    }
    
}

//
//  UIView+Layout.swift
//  CKMessagesViewController
//
//  Created by Kevin Chen on 8/26/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import UIKit

extension UIView: CKViewLayout {
    
    public typealias Content = UIView
    
    public var contents: [UIView] {
        return [self]
    }
    
    public func layout(in rect: CGRect) {
        frame = rect
    }
    
}

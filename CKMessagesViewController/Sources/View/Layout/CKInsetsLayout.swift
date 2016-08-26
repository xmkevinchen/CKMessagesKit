//
//  CKInsetsLayout.swift
//  CKMessagesViewController
//
//  Created by Kevin Chen on 8/26/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import UIKit

public struct CKInsetsLayout<Child: CKViewLayout>: CKViewLayout {
    
    public typealias Content = Child.Content
    
    public var child: Child
    public var insets: UIEdgeInsets
    
    public init(child: Child, insets: UIEdgeInsets = .zero) {
        self.child = child
        self.insets = insets
    }
    
    public func layout(in rect: CGRect) {
        let rect = UIEdgeInsetsInsetRect(rect, insets)
        
        child.layout(in: rect)
    }
    
    public var contents: [Child.Content] {
        return child.contents
    }
    
    
}

extension CKViewLayout {
    
    public func with(insets: UIEdgeInsets) -> CKInsetsLayout<Self> {
        return CKInsetsLayout(child: self, insets: insets)
    }
    
    public func with(insets all: CGFloat) -> CKInsetsLayout<Self> {
        let insets = UIEdgeInsets(top: all, left: all, bottom: all, right: all)
        return with(insets: insets)
    }
}

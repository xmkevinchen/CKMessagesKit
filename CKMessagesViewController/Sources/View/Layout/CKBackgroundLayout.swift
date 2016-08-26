//
//  CKBackgroundLayout.swift
//  CKMessagesViewController
//
//  Created by Kevin Chen on 8/26/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import CoreGraphics

/// A layout that display its background content behind its foreground content.
public struct CKBackgroundLayout<Background: CKViewLayout, Foreground: CKViewLayout>: CKViewLayout
    where Background.Content == Foreground.Content
{
    public typealias Content = Background.Content
    
    public var background: Background
    public var foreground: Foreground
    
    public func layout(in rect: CGRect) {
        background.layout(in: rect)
        foreground.layout(in: rect)
    }
    
    public var contents: [Content] {
        return background.contents + foreground.contents
    }
    
}

extension CKViewLayout {
    
    public func with<Background: CKViewLayout>(background: Background) -> CKBackgroundLayout<Background, Self>
        where Background.Content == Self.Content {
        return CKBackgroundLayout(background: background, foreground: self)
    }
}

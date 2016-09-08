//
//  CGSize+CKMessages.swift
//  CKMessagesKit
//
//  Created by Chen Kevin on 9/7/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import Foundation

public extension CGSize {
    
    func centerInsets() -> UIEdgeInsets {
        let center = CGPoint(x: width / 2.0, y: height / 2.0)
        return UIEdgeInsets(top: center.y, left: center.x, bottom: center.y, right: center.x)
    }
}

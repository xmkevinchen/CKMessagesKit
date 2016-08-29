//
//  Bool+BitOperators.swift
//  CKMessagesViewController
//
//  Created by Kevin Chen on 8/28/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import Foundation

extension Bool {
    
    static func &(lhs: Bool, rhs: Bool) -> Bool {
        if lhs {
            return rhs
        }
        
        return false
    }
    
    static func |(lhs: Bool, rhs: Bool) -> Bool {
        if lhs { return rhs }
        return rhs
    }
    
    static func ^(lhs: Bool, rhs: Bool) -> Bool {
        return lhs != rhs
    }
}

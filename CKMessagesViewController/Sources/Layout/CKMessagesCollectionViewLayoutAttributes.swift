//
//  CKMessagesCollectionViewLayoutAttributes.swift
//  CKCollectionViewForDataCard
//
//  Created by Chen Kevin on 8/24/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import UIKit

public class CKMessagesCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {

    override public func copy() -> Any {
        let copy = super.copy() as! CKMessagesCollectionViewLayoutAttributes
        return copy
    }
    
    override public func isEqual(_ object: Any?) -> Bool {
        if let attributes = object as? CKMessagesCollectionViewLayoutAttributes {
            
            return super.isEqual(attributes)
            
        } else {
            return false
        }
    }
}

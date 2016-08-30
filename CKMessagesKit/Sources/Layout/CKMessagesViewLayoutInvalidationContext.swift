//
//  CKMessagesViewLayoutInvalidationContext.swift
//  CKCollectionViewForDataCard
//
//  Created by Kevin Chen on 8/24/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import UIKit

public class CKMessagesViewLayoutInvalidationContext: UICollectionViewFlowLayoutInvalidationContext {
    
    public var invalidateLayoutMessagesCache: Bool = false

    static func context() -> CKMessagesViewLayoutInvalidationContext {
        let context = CKMessagesViewLayoutInvalidationContext()
        context.invalidateFlowLayoutDelegateMetrics = true
        context.invalidateFlowLayoutAttributes = true
        context.invalidateLayoutMessagesCache = true
        return context
    }
}

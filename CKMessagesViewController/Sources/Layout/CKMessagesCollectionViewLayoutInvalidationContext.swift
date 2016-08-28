//
//  CKMessagesCollectionViewLayoutInvalidationContext.swift
//  CKCollectionViewForDataCard
//
//  Created by Kevin Chen on 8/24/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import UIKit

public class CKMessagesCollectionViewLayoutInvalidationContext: UICollectionViewFlowLayoutInvalidationContext {
    
    public var invalidateLayoutMessagesCache: Bool = false

    static func context() -> CKMessagesCollectionViewLayoutInvalidationContext {
        let context = CKMessagesCollectionViewLayoutInvalidationContext()
        context.invalidateFlowLayoutDelegateMetrics = true
        context.invalidateFlowLayoutAttributes = true
        return context
    }
}

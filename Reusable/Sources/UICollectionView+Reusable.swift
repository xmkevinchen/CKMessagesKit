//
//  UICollectionView+Reusable.swift
//  CKMessagesKit
//
//  Created by Kevin Chen on 8/31/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import UIKit

public extension UICollectionView {
    
    final func register<T: UICollectionViewCell>(for type: T.Type) where T: NibReusable {
        register(T.nib, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    final func register<T: UICollectionViewCell>(for type: T.Type) where T: Reusable {
        register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    final func dequeueReusable<T: UICollectionViewCell>(at indexPath: IndexPath, for type: T.Type = T.self) -> T where T: Reusable {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else  {
            fatalError(
                "Failed to dequeue a cell with identifier \(type.reuseIdentifier) matching type \(type.self). "
                    + "Check that the reuseIdentifier is set properly in your XIB/Storyboard "
                    + "and that you registered the cell beforehand"
            )
        }
        
        return cell
    }
    
    
    final func register<T: UICollectionReusableView>(forSupplementaryView ofKind : String, for type: T.Type = T.self) where T: NibReusable {
        register(T.self, forSupplementaryViewOfKind: ofKind, withReuseIdentifier: T.reuseIdentifier)
    }
    
    final func register<T: UICollectionReusableView>(forSupplementaryView ofKind : String, for type: T.Type = T.self)
        where T: Reusable {
        register(T.self, forSupplementaryViewOfKind: ofKind, withReuseIdentifier: T.reuseIdentifier)
    }
    
    final func dequeueReusable<T: UICollectionReusableView>(forSupplementaryView ofKind: String, at indexPath: IndexPath, for type: T.Type = T.self) -> T where T: Reusable {
        guard let view = dequeueReusableSupplementaryView(ofKind: ofKind, withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError(
                "Failed to dequeue a supplementary view with identifier \(type.reuseIdentifier) matching type \(type.self). "
                    + "Check that the reuseIdentifier is set properly in your XIB/Storyboard "
                    + "and that you registered the supplementary view beforehand"
            )
        }
        
        return view
    }
    
}


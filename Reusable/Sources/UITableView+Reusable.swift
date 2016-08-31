//
//  UITableView+Reusable.swift
//  CKMessagesKit
//
//  Created by Chen Kevin on 8/31/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import UIKit

public extension UITableView {
    
    final func register<T: UITableViewCell>(for type: T.Type) where T: Reusable {
        register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    final func register<T: UITableViewCell>(for type: T.Type) where T: NibReusable {
        register(T.nib, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    final func dequeueReusable<T: UITableViewCell>(at indexPath: IndexPath, for type: T.Type = T.self) -> T where T: Reusable {
        
        guard let cell = self.dequeueReusableCell(withIdentifier: type.reuseIdentifier, for: indexPath) as? T else {
            fatalError(
                "Failed to dequeue a cell with identifier \(type.reuseIdentifier) matching type \(type.self). "
                    + "Check that the reuseIdentifier is set properly in your XIB/Storyboard "
                    + "and that you registered the cell beforehand"
            )
        }
        
        return cell
    }
    
    final func register<T: UITableViewHeaderFooterView>(for type: T.Type) where T: Reusable {
        register(T.self, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
    }
    
    final func register<T: UITableViewHeaderFooterView>(for type: T.Type) where T: NibReusable {
        register(T.nib, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
    }
    
    final func dequeueReusable<T: UITableViewHeaderFooterView>(for type: T.Type = T.self) -> T? where T: Reusable {
        
        guard let view = self.dequeueReusableHeaderFooterView(withIdentifier: type.reuseIdentifier) as? T? else {
            fatalError(
                "Failed to dequeue a header/footer with identifier \(type.reuseIdentifier) matching type \(type.self). "
                    + "Check that the reuseIdentifier is set properly in your XIB/Storyboard "
                    + "and that you registered the header/footer beforehand"
            )
        }
        
        return view
    }
    
}

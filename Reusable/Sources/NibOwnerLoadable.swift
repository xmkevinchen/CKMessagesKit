//
//  NibOwnerLoadable.swift
//  CKMessagesKit
//
//  Created by Chen Kevin on 8/31/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import UIKit

public protocol NibOwnerLoadable: class {
    static var nib: UINib { get }
}

public extension NibOwnerLoadable {
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }
}

public extension NibOwnerLoadable where Self: UIView {
    
    static func viewFromNib(owner: Self = Self()) -> Self {
        
        let attributes: [NSLayoutAttribute] = [.top, .leading, .bottom, .trailing]
        
        for instance in nib.instantiate(withOwner: self, options: nil) {
            if let view = instance as? UIView {
                view.translatesAutoresizingMaskIntoConstraints = false
                owner.addSubview(view)
                
                attributes.forEach { attribute in
                    
                    let constraint = NSLayoutConstraint(item: view, attribute: attribute, relatedBy: .equal, toItem: owner, attribute: attribute, multiplier: 1.0, constant: 0)
                    owner.addConstraint(constraint)
                }
            }
        }
        
        return owner
    }
}

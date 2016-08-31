//
//  UIStoryboard+Identifier.swift
//  CKMessagesKit
//
//  Created by Chen Kevin on 8/31/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import Foundation

public extension UIStoryboard {
    
    func instantiate<T: UIViewController>(for type: T.Type = T.self) -> T where T: Identifiable {
        guard let viewController = instantiateViewController(withIdentifier: T.identifier) as? T else {
            fatalError("The viewController '\(T.identifier)' of '\(self)' is not of class '\(self)'")
        }
        
        return viewController
    }
    
}

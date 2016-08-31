//
//  Reusable.swift
//  CKMessagesKit
//
//  Created by Kevin Chen on 8/31/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import Foundation

public protocol Reusable: class, Identifiable {
    static var reuseIdentifier: String { get }
}

public extension Reusable {
    static var reuseIdentifier: String {
        return identifier
    }
}


public protocol NibReusable: Reusable, NibLoadable {}



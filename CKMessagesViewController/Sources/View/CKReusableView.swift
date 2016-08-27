//
//  CKReusableView.swift
//  CKMessagesViewController
//
//  Created by Chen Kevin on 8/27/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import UIKit

protocol CKRusableView: class {
    static var ReuseIdentifier: String { get }
}

extension CKRusableView {
    static var ReuseIdentifier: String {
        return String(describing: Self.self)
    }
}

extension UICollectionViewCell: CKRusableView {}

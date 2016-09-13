//
//  CKMessagesToolbar.swift
//  CKMessagesKit
//
//  Created by Kevin Chen on 8/30/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import UIKit

public class CKMessagesToolbar: UIToolbar {
    
    public var preferredDefaultHeight: CGFloat = 44.0 {
        willSet {
            assert(newValue > 0)
        }
    }
    public var maximumHeight = CGFloat.greatestFiniteMagnitude
    
            
    public private(set) var contentView: CKMessagesToolbarContentView!
    
    public var textView: CKMessagesComposerTextView {
        return contentView.textView
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView = CKMessagesToolbarContentView.viewFromNib()        
        addSubview(contentView)
        pinSubview(contentView)
        setNeedsUpdateConstraints()
        translatesAutoresizingMaskIntoConstraints = false
    }        
    
}

// MARK:- BarItems

public extension CKMessagesToolbar {
    
    public var leftBarItem: CKMessagesToolbarItem? {
        get {
            return contentView.leftBarItem
        }
        
        set {
            contentView.leftBarItem = newValue
        }
    }
    
    public var leftBarItems: [CKMessagesToolbarItem]? {
        get {
            return contentView.leftBarItems
        }
        
        set {
            contentView.leftBarItems = newValue
        }
    }
    
    public var rightBarItem: CKMessagesToolbarItem? {
        
        get {
            return contentView.rightBarItem
        }
        
        set {
            contentView.rightBarItem = newValue
        }
    }
    
    public var rightBarItems: [CKMessagesToolbarItem]? {
        
        get {
            return contentView.rightBarItems
        }
        
        set {
            contentView.rightBarItems = newValue
        }
    }
}

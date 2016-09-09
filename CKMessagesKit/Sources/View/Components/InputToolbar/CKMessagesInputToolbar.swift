//
//  CKMessagesInputToolbar.swift
//  CKMessagesKit
//
//  Created by Kevin Chen on 8/30/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import UIKit

public protocol CKMessagesInputToolbarDelegate: UIToolbarDelegate {
    
    func toolbar(_ toolbar: CKMessagesInputToolbar, didClickLeftBarButton sender: UIButton)
    func toolbar(_ toolbar: CKMessagesInputToolbar, didClickRightBarButton sender: UIButton)
    
}

public class CKMessagesInputToolbar: UIToolbar {
    
    public enum SendButtonPosition {
        case left
        case right
    }
    
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
        contentView.frame = frame
        addSubview(contentView)
        pinSubview(contentView)
        setNeedsUpdateConstraints()
    
    }
    
}

// MARK:- BarItems

public extension CKMessagesInputToolbar {
    
    public var leftBarItem: CKMessagesInputToolbarItem? {
        get {
            return contentView.leftBarItem
        }
        
        set {
            contentView.leftBarItem = newValue
        }
    }
    
    public var leftBarItems: [CKMessagesInputToolbarItem]? {
        get {
            return contentView.leftBarItems
        }
        
        set {
            contentView.leftBarItems = newValue
        }
    }
    
    public var rightBarItem: CKMessagesInputToolbarItem? {
        
        get {
            return contentView.rightBarItem
        }
        
        set {
            contentView.rightBarItem = newValue
        }
    }
    
    public var rightBarItems: [CKMessagesInputToolbarItem]? {
        
        get {
            return contentView.rightBarItems
        }
        
        set {
            contentView.rightBarItems = newValue
        }
    }
}


public final class CKMessagesToolbarButtonFactory {
    
    private let font: UIFont
    
    public init(font: UIFont) {
        self.font = font
    }
    
    convenience init() {
        self.init(font: UIFont.preferredFont(forTextStyle: .headline))
    }
    
    public var accessoryButton: CKMessagesInputToolbarItem {
        let accessory = UIImage.accessory
        let normal = accessory.with(mask: UIColor.lightGray)
        let highlighted = accessory.with(mask: UIColor.darkGray)
        let accessoryButton = CKMessagesInputToolbarItem(frame: CGRect(x: 0, y: 0, width: accessory.size.width, height: 32.0))
        accessoryButton.setImage(normal, for: .normal)
        accessoryButton.setImage(highlighted, for: .highlighted)
        
        accessoryButton.contentMode = .scaleAspectFit
        accessoryButton.backgroundColor = UIColor.clear
        accessoryButton.tintColor = UIColor.lightGray
        accessoryButton.titleLabel?.font = font
        
        
        return accessoryButton
    }
    
    public var sendButton: CKMessagesInputToolbarItem {
        
        let title = "Send"
        
        let button = CKMessagesInputToolbarItem(frame: .zero)
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.messageBubbleBlue, for: .normal)
        button.setTitleColor(UIColor.messageBubbleBlue.darken(with: 0.1), for: .highlighted)
        button.setTitleColor(UIColor.lightGray, for: .disabled)
        
        button.titleLabel?.font = font
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.minimumScaleFactor = 0.85
        button.backgroundColor = UIColor.clear
        button.tintColor = UIColor.messageBubbleBlue
        
        let height: CGFloat = 32.0
        
        let titleSize = NSString(string: title).boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: height),
                                                             options: [.usesLineFragmentOrigin, .usesFontLeading],
                                                             attributes: [NSFontAttributeName: font],
                                                             context: nil).integral.size
        button.frame = CGRect(origin: .zero, size: titleSize)
        
        return button
        
    }
    
}

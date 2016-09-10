//
//  CKMessagesToolbarItem.swift
//  CKMessagesKit
//
//  Created by Kevin Chen on 9/8/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import UIKit

public class CKMessagesToolbarItem: UIButton {
    
    
    /// For additional button space
    public var additional = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    
    public init(image: UIImage, highlightedImage: UIImage? = nil,
                target: Any?, action: Selector?) {
        
        super.init(frame: .zero)
        
        setImage(image, for: .normal)
        if highlightedImage != nil {
            setImage(highlightedImage, for: .highlighted)
        }
        
        contentMode = .scaleAspectFit
        sizeToFit()
    }
    
    
    
    public init(title: String?,
                font: UIFont = UIFont.preferredFont(forTextStyle: .headline),
                target: Any?, action: Selector?) {
        super.init(frame:.zero)
        setTitle(title, for: .normal)
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        titleLabel?.minimumScaleFactor = 0.85
        titleLabel?.adjustsFontSizeToFitWidth = true
        
        sizeToFit()
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        
        size.width += (additional.left + additional.right)
        size.height += (additional.top + additional.bottom)
        
        return size
    }
    
}

public extension CKMessagesToolbarItem {
    
    static var accessory: CKMessagesToolbarItem {
        
        let accessory = UIImage.accessory
        let normal = accessory.with(mask: UIColor.lightGray)
        let highlighted = accessory.with(mask: UIColor.darkGray)
        
        let button = CKMessagesToolbarItem(image: normal, highlightedImage: highlighted, target: nil, action: nil)
        
        button.tintColor = UIColor.lightGray
        return button
    }
    
    static var send: CKMessagesToolbarItem {
        
        let title = "Send"
        let font = UIFont.preferredFont(forTextStyle: .headline)
        
        let button = CKMessagesToolbarItem(title: title, font: font, target: nil, action: nil)
        
        button.setTitleColor(UIColor.messageBubbleBlue, for: .normal)
        button.setTitleColor(UIColor.messageBubbleBlue.darken(with: 0.1), for: .highlighted)
        button.setTitleColor(UIColor.lightGray, for: .disabled)
                
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

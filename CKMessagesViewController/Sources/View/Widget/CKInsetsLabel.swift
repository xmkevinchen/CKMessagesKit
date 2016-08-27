//
//  CKInsetsLabel.swift
//  CKMessagesViewController
//
//  Created by Kevin Chen on 8/26/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import UIKit

//@IBDesignable
public class CKInsetsLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    
    
    
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    private var _textInsets: UIEdgeInsets = .zero
    
//    @IBInspectable
    public var textInsets: UIEdgeInsets {
        get {
            return _textInsets
        }
        
        set {
            guard newValue != _textInsets else {
                return
            }
            
            _textInsets = newValue
            
            setNeedsDisplay()
        }
    }
    
    
    override public func drawText(in rect: CGRect) {
        super.drawText(in:
            CGRect(x: rect.minX + _textInsets.left,
                   y: rect.minY + _textInsets.top,
                   width: rect.width - _textInsets.right,
                   height: rect.height - _textInsets.bottom))
    }
    
}

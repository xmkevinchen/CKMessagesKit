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
        super.drawText(in:UIEdgeInsetsInsetRect(rect, _textInsets))
    }
    
    public override var intrinsicContentSize: CGSize {
        
        var size = super.intrinsicContentSize
        if size == .zero && text != nil {
            
            size = NSString(string: text!).boundingRect(with: bounds.size,
                                                        options: [.usesLineFragmentOrigin, .usesFontLeading],
                                                        attributes: [NSFontAttributeName: font],
                                                        context: nil).integral.size
            
        }
        size.width += (_textInsets.left + _textInsets.right)
        size.height += (_textInsets.top + _textInsets.bottom)
        
        return size
    }
    
}

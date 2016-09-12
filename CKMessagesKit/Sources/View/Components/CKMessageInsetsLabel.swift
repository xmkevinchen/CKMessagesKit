//
//  CKMessageInsetsLabel.swift
//  CKMessagesViewController
//
//  Created by Kevin Chen on 8/26/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import UIKit

public class CKMessageInsetsLabel: UILabel {
    
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
    
    public var textInsets: UIEdgeInsets = .zero {
        
        didSet {
            guard textInsets != oldValue else {
                return
            }
            
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    
    
    override public func drawText(in rect: CGRect) {
        super.drawText(in:UIEdgeInsetsInsetRect(rect, textInsets))
    }
    
    public override var intrinsicContentSize: CGSize {
        
        var size = super.intrinsicContentSize
        if size == .zero && text != nil {
            
            size = NSString(string: text!).boundingRect(with: bounds.size,
                                                        options: [.usesLineFragmentOrigin, .usesFontLeading],
                                                        attributes: [NSFontAttributeName: font],
                                                        context: nil).integral.size
            
        }
        size.width += (textInsets.left + textInsets.right)
        size.height += (textInsets.top + textInsets.bottom)
        
        return size
    }
    
}

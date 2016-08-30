//
//  CKMessageViewCell.swift
//  CKMessagesViewController
//
//  Created by Chen Kevin on 8/27/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import UIKit

public class CKMessageViewCell: CKMessageDataViewCell {
            
    public var textView: UITextView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    
    override public func prepareForReuse() {
        super.prepareForReuse()        
        textView.text = nil
        textView.attributedText = nil
    }
    
    
    override public func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        if let attributes = layoutAttributes as? CKMessagesCollectionViewLayoutAttributes {
                        
            if attributes.messageFont != textView.font {
                textView.font = attributes.messageFont
            }
                                    
        }
    }
    
    private func configure() {
        textView = CKMessageCellTextView(frame: frame)
        attach(hostedView: textView)
    }
        
}

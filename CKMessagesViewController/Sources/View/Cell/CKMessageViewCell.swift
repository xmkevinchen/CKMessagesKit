//
//  CKMessageViewCell.swift
//  CKMessagesViewController
//
//  Created by Chen Kevin on 8/27/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import UIKit

class CKMessageViewCell: CKMessageDataViewCell {
            
    let textView: CKMessageCellTextView = CKMessageCellTextView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        attach(hostedView: textView)
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
        attach(hostedView: textView)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textView.dataDetectorTypes = []
        textView.text = nil
        textView.attributedText = nil
    }
    
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        if let attributes = layoutAttributes as? CKMessagesCollectionViewLayoutAttributes {
            
            if attributes.messageTextViewContainerInsetes != textView.textContainerInset {
                textView.textContainerInset = attributes.messageTextViewContainerInsetes
                textView.setNeedsDisplay()
            }
            
            if attributes.messageFont != textView.font {
                textView.font = attributes.messageFont
                textView.linkTextAttributes = [
                    NSFontAttributeName: attributes.messageFont,
                    //            NSForegroundColorAttributeName : UIColor.white,
                    NSUnderlineStyleAttributeName : [NSUnderlineStyle.styleSingle, .patternSolid] ]
            }
            
        }
    }
    
    private func configure() {
        textView.layer.borderColor = UIColor.red.cgColor
        textView.layer.borderWidth = 1
    }
        
}

//
//  CKMessageTextCell.swift
//  CKMessagesKit
//
//  Created by Kevin Chen on 9/10/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import UIKit
import Reusable

public class CKMessageTextCell: CKMessageBasicCell, NibLoadable {
    
    @IBOutlet public weak var textView: CKMessageCellTextView!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        if let textView = CKMessageTextCell.nib.instantiate(withOwner: self, options: nil).first as? CKMessageCellTextView {
            self.textView = textView
            self.textView.translatesAutoresizingMaskIntoConstraints = false
            self.textView.frame = .zero
            messageView = textView
        }
                
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    public override func prepareForReuse() {
        super.prepareForReuse()
        
        textView.text = nil
        textView.attributedText = nil
    }
    
    public override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        if let attributes = layoutAttributes as? CKMessagesViewLayoutAttributes {
            
            guard attributes.representedElementCategory == .cell else {
                return
            }
            
            if textView.font != attributes.messageFont {
                textView.font = attributes.messageFont
            }                        
            
        }
    }

}

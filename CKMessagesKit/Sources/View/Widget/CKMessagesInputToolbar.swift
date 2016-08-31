//
//  CKMessagesInputToolbar.swift
//  CKMessagesKit
//
//  Created by Kevin Chen on 8/30/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import UIKit

class CKMessagesInputToolbar: UIToolbar {
    
    let preferredDefaultHeight: CGFloat = 44.0
    var contentView: CKMessagesToolbarContentView?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView = CKMessagesToolbarContentView.viewFromNib()
        
    }
    
    

}

//
//  CKMessagesToolbarContentView.swift
//  CKMessagesKit
//
//  Created by Kevin Chen on 8/30/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import UIKit

class CKMessagesToolbarContentView: UIView {

    @IBOutlet weak var leftContainerView: UIView!
    @IBOutlet weak var rightContainerView: UIView!
    @IBOutlet weak var textView: CKMessagesComposerTextView!

    @IBOutlet weak var leftHorizontalSpacingConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightHorizontalSpacingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var leftContainerWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightContainerWidthConstraint: NSLayoutConstraint!
    
}

extension CKMessagesToolbarContentView: CKNibLoadable {
    
}

//
//  CKMessagesAvatarImageData.swift
//  CKMessagesKit
//
//  Created by Kevin Chen on 9/2/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import UIKit

public protocol CKMessagesAvatarImageData {
    
    var avatar: UIImage? { get }
    var highlighted: UIImage? { get }
    var placeholder: UIImage { get }
    
}

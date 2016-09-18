//
//  CKMessagesBubbleImageData.swift
//  CKMessagesViewController
//
//  Created by Kevin Chen on 8/28/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import UIKit

public protocol CKMessagesBubbleImageData {
    var image: UIImage { get }
    var highlightedImage: UIImage { get }
}

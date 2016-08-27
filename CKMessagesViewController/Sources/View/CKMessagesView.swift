//
//  CKMessagesView.swift
//  CKMessagesViewController
//
//  Created by Kevin Chen on 8/26/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

//@IBDesignable
class CKMessagesView: UIView {

    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var messageTopLabel: UILabel!
    
    @IBOutlet weak var avatarContainerView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var messageContainerView: UIView!
    @IBOutlet weak var messageBubbleImageView: UIImageView!
    @IBOutlet weak var contentView: CKMessagePresentingView!
    
    @IBOutlet weak var accessoryContainerView: UIView!
    @IBOutlet weak var accessoryContainerWidthConstraints: NSLayoutConstraint!
    
}

//
//  ViewController.swift
//  Sample
//
//  Created by Kevin Chen on 8/24/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import UIKit
import CKMessagesKit

extension String {
    
    var initials: String {
        return capitalized
            .components(separatedBy: " ")
            .flatMap { $0.substring(to: $0.index(after: $0.startIndex)) }
            .joined()
    }
    
}

class ViewController: CKMessagesViewController, CKMessagesViewMessaging {
    
    var messages = [CKMessageData]()
    
    var formatter = DateFormatter()
    
    var incomingAvatar: CKMessagesAvatarImageData?
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        title = "Messages"
                
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.typing, style: .plain, target: self, action: #selector(showTypingIndicator(_:)))
        
        /// 1. Register presentor for specified message type
        register(presentor: GridViewController.self, for: GridMessage.self)
        register(presentor: ListViewController.self, for: ListMessage.self)
        
        messagesView.messenger = self
        messagesView.decorator = self        
        
        /// 2. Show / Hide avatars
        let avatarFactory = CKMessagesAvatarImageFactory(diameter: 48)
        messagesView.messagesViewLayout.outgoingAvatarSize = .zero
        messagesView.messagesViewLayout.incomingAvatarSize = CGSize(width: 48, height: 48)        
        
        for _ in 0..<4 {
            insertNewMessage()
        }
        
        messagesView.messagesViewLayout.minimumLineSpacing = 10
        
        /// 3. Configurae toolbar items
        let send = CKMessagesToolbarItem.send
        send.addTarget(self, action: #selector(send(_:)), for: .touchUpInside)
        inputToolbar.rightBarItems = [CKMessagesToolbarItem.accessory, send]
        
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        formatter.doesRelativeDateFormatting = true
        
        /// 4. Specify the bar item should be enabled automatically when the `textView` contains text.
        enablesAutomaticallyBarItem = send
        
        incomingAvatar = avatarFactory.avatar(image: UIImage(named: "wechat")!)
        
        messagesView.reloadData()
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    public func messageForItem(at indexPath: IndexPath, of messagesView: CKMessagesView) -> CKMessageData {
        return messages[indexPath.item]
    }
    
    
    
    /// Show typing indicator as collection view section footer
    ///
    /// - parameter sender:
    func showTypingIndicator(_ sender: AnyObject) {
        isShowingIndicator = true
        scrollToBottom(animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.isShowingIndicator = false
            self.messagesView.reloadData()
        }
    }
    
    
    /// Send message behavior
    ///
    /// - parameter sender:
    func send(_ sender: UIButton) {
        let messageText = currentlyComposedMessageText()
        let message = CKMessage(senderId: arc4random() % 2 == 0 ? senderId: "incoming", sender: self.sender, text: messageText)
        messages.append(message)
        finishSendingMessage()
    }
    
    
    
    public var senderId: String {
        return "kevin"
    }
    
    public var sender: String {
        return "Kevin Chen"
    }
    
    let text = "It is almost always cleaner and easier to update a constraint immediately after the affecting change has occurred. Deferring these changes to a later method makes the code more complex and harder to understand.\nHowever, there are times when you may want to batch changes for performance reasons. This should only be done when changing the constraints in place is too slow, or when a view is making a number of redundant changes.\nTo batch a change, instead of making the change directly, call the setNeedsUpdateConstraints method on the view holding the constraint. Then, override the view’s updateConstraints method to modify the affected constraints."
    
    private func generateMessage(at index: Int) -> CKMessageData? {
        
        var message: CKMessageData?
        let value = index % 4
        
        let length = self.text.lengthOfBytes(using: .utf8)
        let lastIndex = self.text.index(self.text.startIndex, offsetBy: max(Int(arc4random_uniform(UInt32(length - 1))), 80))
//        let lastIndex = self.text.index(self.text.startIndex, offsetBy: 60)
        let text = self.text.substring(to: lastIndex)
        
        switch value {
        case 0:
            
            message = CKMessage(senderId: senderId, sender: sender, text: "Your Apple ID must be associated with a paid Apple Developer Program or Apple Developer Enterprise Program to access certain software downloads.")
            
        case 1:
            message = CKMessage(senderId: "incoming", sender: "Incoming", text: text)
            
        case 2:
            message = GridMessage(senderId: senderId, sender: sender, text: String(index))
            
        case 3:
            message = ListMessage(senderId: "incoming", sender: "Incoming", text: String(index))
            
        default:
            break
        }
        
        return message
    }
    
    private func insertNewMessage() {
        let message = generateMessage(at: messages.count)
        if message != nil {
            messages.append(message!)
        }
        
    }
    
}

extension ViewController: CKMessagesViewDecorating {
        
    func messagesView(_ messagesView: CKMessagesView, layout: CKMessagesViewLayout, contentSizeAt indexPath: IndexPath) -> CGSize? {
        let message = messages[indexPath.item]
        
        switch message {
        case is GridMessage:
            return CGSize(width: 260, height: 60)
            
        case is ListMessage:
            return CGSize(width: 240, height: 200)
            
        default:
            return nil
        }
        
    }
    
//    func messagesView(_ messagesView: CKMessagesView, layout: CKMessagesViewLayout, textForTopLabelAt indexPath: IndexPath) -> String? {
//        
//        if indexPath.item % 3 == 0 {
//            let message = messages[indexPath.item]
//            return formatter.string(from: message.timestamp)
//        } else {
//            return nil
//        }
//    }
//    
//    func messagesView(_ messagesView: CKMessagesView, layout: CKMessagesViewLayout, textForBubbleTopLabelAt indexPath: IndexPath) -> String? {
//        let message = messages[indexPath.item]
//        return message.sender
//    }
//    
//    
//    
//    //    func attributedTextForMessageTop(at indexPath: IndexPath, of messagesView: CKMessagesView) -> NSAttributedString? {
//    //        let paragraphStyle = NSMutableParagraphStyle()
//    //
//    //        let message = messages[indexPath.item]
//    //        if message.senderId == senderId {
//    //            paragraphStyle.alignment = .right
//    //            paragraphStyle.tailIndent = -15
//    //        } else {
//    //            paragraphStyle.alignment = .left
//    //            paragraphStyle.firstLineHeadIndent = 45
//    //            paragraphStyle.headIndent = 45
//    //        }
//    //
//    //        return NSAttributedString(string: message.sender,
//    //                                  attributes: [
//    //                                    NSParagraphStyleAttributeName: paragraphStyle
//    //            ])
//    //    }
//    
//    
//    func messagesView(_ messagesView: CKMessagesView, layout: CKMessagesViewLayout, textForBottomLabelAt indexPath: IndexPath) -> String? {
//        let message = messages[indexPath.item]
//        
//        if message.senderId == senderId {
//            return "Send"
//        }
//        
//        return nil
//    }
    
    func messagesView(_ messagesView: CKMessagesView, layout: CKMessagesViewLayout, avatarAt indexPath: IndexPath) -> CKMessagesAvatarImageData? {
        let message = messages[indexPath.item]
        
        if message.senderId != senderId {
            return incomingAvatar
        } else {
            return nil
        }
    }
    
    
}


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
    var avatarFactory = CKMessagesAvatarImageFactory()
    var formatter = DateFormatter()
        
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        title = "Messages"
        
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage.typing, style: .plain, target: self, action: #selector(showTypingIndicator(_:))),
            UIBarButtonItem(image: UIImage.typing, style: .plain, target: self, action: #selector(showTypingIndicator(_:)))]
        
        // Do any additional setup after loading the view, typically from a nib.
        register(presentor: GridViewController.self, for: GridMessage.self)
        register(presentor: ListViewController.self, for: ListMessage.self)
        
        messagesView.messenger = self
        messagesView.decorator = self        
        
        
        messagesView.messagesViewLayout.outgoingAvatarSize = .zero
//        (messagesView.collectionViewLayout as! CKMessagesViewLayout).messageFont = UIFont.systemFont(ofSize: 14)
        
        for _ in 0..<8 {
            insertNewMessage()
        }
        
        messagesView.messagesViewLayout.minimumLineSpacing = 20
        
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        formatter.doesRelativeDateFormatting = true
        
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
//        return GridMessage(senderId: "incoming", sender: "Incoming", text: String(1))
        
    }
    
    
    
    
    func showTypingIndicator(_ sender: AnyObject) {
        isShowingIndicator = true
        scrollToBottom(animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.isShowingIndicator = false
            self.messagesView.reloadData()
        }
    }
    
    override func didClickSendButton(_ button: UIButton, messageText: String) {
        
        let message = CKMessage(senderId: arc4random() % 2 == 0 ? senderId: "incoming", sender: sender, text: messageText)
        messages.append(message)
        finishSendingMessage()
    }
    
    
    
    public var senderId: String {
        return "kevin"
    }
    
    public var sender: String {
        return "Kevin Chen"
    }
    
    
    
    
        
    private func generateMessage(at index: Int) -> CKMessageData? {
        
        var message: CKMessageData?
        let value = index % 4
        
        switch value {
        case 0:
            message = CKMessage(senderId: senderId, sender: sender, text: "Your Apple ID must be associated with a paid Apple Developer Program or Apple Developer Enterprise Program to access certain software downloads.")
            
        case 1:
            message = CKMessage(senderId: "incoming", sender: "Incoming", text: "Get the latest beta releases of Xcode, iOS, macOS, watchOS, tvOS, and more.")
            
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
        if message is CKMessage {
            return nil
        }
        
        return CGSize(width:Int(100 + arc4random_uniform(50)), height:Int(50 + arc4random_uniform(100)))
    }
    
    func messagesView(_ messagesView: CKMessagesView, layout: CKMessagesViewLayout, textForMessageTopLabelAt indexPath: IndexPath) -> String? {
        let message = messages[indexPath.item]
        return message.sender
    }
    
    
    
    //    func attributedTextForMessageTop(at indexPath: IndexPath, of messagesView: CKMessagesView) -> NSAttributedString? {
    //        let paragraphStyle = NSMutableParagraphStyle()
    //
    //        let message = messages[indexPath.item]
    //        if message.senderId == senderId {
    //            paragraphStyle.alignment = .right
    //            paragraphStyle.tailIndent = -15
    //        } else {
    //            paragraphStyle.alignment = .left
    //            paragraphStyle.firstLineHeadIndent = 45
    //            paragraphStyle.headIndent = 45
    //        }
    //
    //        return NSAttributedString(string: message.sender,
    //                                  attributes: [
    //                                    NSParagraphStyleAttributeName: paragraphStyle
    //            ])
    //    }
    
    
    func messagesView(_ messagesView: CKMessagesView, layout: CKMessagesViewLayout, textForBottomLabelAt indexPath: IndexPath) -> String? {
        let message = messages[indexPath.item]
        
        if message.senderId == senderId {
            return "Send"
        }
        
        return nil
    }
    
    func messagesView(_ messagesView: CKMessagesView, layout: CKMessagesViewLayout, avatarAt indexPath: IndexPath) -> CKMessagesAvatarImageData? {
        let message = messages[indexPath.item]
        
        return avatarFactory.avatar(initials: message.sender.initials,
                                    backgroundColor: UIColor.darkGray,
                                    textColor: UIColor.white,
                                    font: UIFont.preferredFont(forTextStyle: .headline))
    }
    
    
}


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
    
    var isModel: Bool = false
    
    var messages = [CKMessageData]()
    var formatter = DateFormatter()
    var incomingAvatar: CKMessagesAvatarImageData?
    var incomingBubbleImage: CKMessagesBubbleImageData?
    var outgoingBubbleImage: CKMessagesBubbleImageData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Messages"
        messagesView.backgroundColor = UIColor.lightGray
        
        if isModel {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismiss(_:)))
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.typing, style: .plain, target: self, action: #selector(showTypingIndicator(_:)))
        
        /// 1. Register presentor for specified message type
        messagesView.register(presentor: GridViewController.self, of: GridMessage.self)
        messagesView.register(presentor: ListViewController.self, of: ListMessage.self)
        messagesView.register(presentor: CKMessageTextDataPresentor.self, of: CKMessage.self)
        messagesView.register(presentor: CKMessageImageDataPresentor.self, of: CKMessageImage.self)
        messagesView.register(presentor: ImagePresentor.self, of: ImageMessage.self)
        
        messagesView.messenger = self
        messagesView.decorator = self        
        
        /// 2. Show / Hide avatars
        let avatarFactory = CKMessagesAvatarImageFactory(diameter: 36)
        messagesView.messagesViewLayout.outgoingAvatarSize = .zero
        messagesView.messagesViewLayout.incomingAvatarSize = CGSize(width: 36, height: 36)
        
        for _ in 0..<1 {
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
        
        incomingAvatar = avatarFactory.avatar(image: #imageLiteral(resourceName: "super-mario"))
        let bubbleFactory = CKMessagesBubbleImageFactory()
        incomingBubbleImage = bubbleFactory.incomingBubbleImage(with: .messageBubbleLightGray)
        outgoingBubbleImage = bubbleFactory.outgoingBubbleImage(with: .messageBubbleBlue)
        
        messagesView.reloadData()
        
    }
    
    private func generateMessage(at index: Int) -> CKMessageData? {
        
        var message: CKMessageData?
        let value = index % 6
        
        switch value {
        case 1:
            
            message = CKMessage(senderId: senderId,
                                sender: sender,
                                text: "Your Apple ID must be associated with a paid Apple Developer Program or Apple Developer Enterprise Program to access certain software downloads.")
            
        case 3:
            _ = self.text.lengthOfBytes(using: .utf8)
            let maximum = max(60, Int(arc4random_uniform(UInt32(120))))
            let lastIndex = self.text.index(self.text.startIndex, offsetBy: maximum)
            let substring = self.text.substring(to: lastIndex)
            message = CKMessage(senderId: "incoming", sender: "Incoming", text: substring)
            
        case 2:
            message = GridMessage(senderId: senderId, sender: sender, index: index)
            
        case 4:
            message = ListMessage(senderId: "incoming", sender: "Incoming", index: index)
            
        case 5:
            message = ImageMessage(senderId: "image", sender: "Image Message")
            
        case 0:
            let filename = "zoro@2x.png"
            let imageURL = Bundle.main.bundleURL.appendingPathComponent(filename)
            message = CKMessageImage(senderId: senderId, sender: sender, imageURL: imageURL)
            
        default:
            break
        }
        
        return message
    }

    func dismiss(_ sender: AnyObject) {
        resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath)
        
        let message = messages[indexPath.row]
        
        if message.senderId != senderId {
            if let presentor = messagesView.dequeueReusablePresentor(of: type(of: message), at: indexPath) as? CKMessageTextDataPresentor {
                presentor.textView.textColor = UIColor.black
            }
        }
        
        return cell
        
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
    
    
    
    private func insertNewMessage() {
        let message = generateMessage(at: messages.count)
        if message != nil {
            messages.append(message!)
        }
        
    }
    
}

extension ViewController: CKMessagesViewDecorating {
    
    func messagesView(_ messagesView: CKMessagesView, layout: CKMessagesViewLayout, messageSizeAt indexPath: IndexPath) -> CGSize? {
        let message = messages[indexPath.item]
        
        switch message {
        case is GridMessage:
            return CGSize(width: 260, height: 60)
            
        case is ListMessage:
            return CGSize(width: 240, height: 150)
            
        case is ImageMessage:
            return CGSize(width: 160, height: 90)
            
        default:
            return nil
        }
        
    }
    
    func messagesView(_ messagesView: CKMessagesView, layout: CKMessagesViewLayout, textForTopLabelAt indexPath: IndexPath) -> String? {
        
        return "\(indexPath)"
    }
    
    func messagesView(_ messagesView: CKMessagesView, layout: CKMessagesViewLayout, textForBubbleTopLabelAt indexPath: IndexPath) -> String? {
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
        
        if message.senderId != senderId {
            return incomingAvatar
        } else {
            return nil
        }
    }
    
    func messagesView(_ messagesView: CKMessagesView, layout: CKMessagesViewLayout, messageInsetsAt indexPath: IndexPath) -> UIEdgeInsets? {
        let message = messages[indexPath.item]
        
        
        if message is ListMessage {
            return .zero
        } else if message is ImageMessage {
            return .zero
        }
        
        return nil
    }
    
    func messagesView(_ messagesView: CKMessagesView, layout: CKMessagesViewLayout, bubbleTailHorizontalSpaceAt indexPath: IndexPath) -> CGFloat? {
        let message = messages[indexPath.item]
        
        if message is ImageMessage {
            return 0
        }
        
        return nil
    }
    
    func messagesView(_ messagesView: CKMessagesView, layout: CKMessagesViewLayout, messageBubbleAt indexPath: IndexPath) -> CKMessagesBubbleImageData? {
        
        let message = messages[indexPath.item]
        if message.senderId == senderId  {
            
            return outgoingBubbleImage
            
        } else {
            return incomingBubbleImage
        }
        
        
    }
    
    
}


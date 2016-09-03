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

class ViewController: CKMessagesViewController, CKMessagesViewMessaging, CKMessagesViewDecorating {
    
    var messages = [CKMessageData]()
    var avatarFactory = CKMessagesAvatarImageFactory()
        
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        title = "Messages"
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
        register(presentor: GridViewController.self, for: GridMessage.self)
        register(presentor: ListViewController.self, for: ListMessage.self)
        
        messagesView.messenger = self
        messagesView.decorator = self
        
        
        messagesView.messagesViewLayout.outgoingAvatarSize = .zero
//        (messagesView.collectionViewLayout as! CKMessagesViewLayout).messageFont = UIFont.systemFont(ofSize: 14)
        
        for i in 0..<100 {
            var message: CKMessageData?
            let value = i % 4
            
            switch value {
            case 0:
                message = CKMessage(senderId: senderId, sender: sender, text: "Your Apple ID must be associated with a paid Apple Developer Program or Apple Developer Enterprise Program to access certain software downloads.")
                
            case 1:
                message = CKMessage(senderId: "incoming", sender: "Incoming", text: "Get the latest beta releases of Xcode, iOS, macOS, watchOS, tvOS, and more.")
                
            case 2:
                message = GridMessage(senderId: senderId, sender: sender, text: String(i))
                
            case 3:
                message = ListMessage(senderId: "incoming", sender: "Incoming", text: String(i))
                
            default:
                break
            }
            
            if message != nil {
                messages.append(message!)
            }
        }
        
        messagesView.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    public func messageForItem(at indexPath: IndexPath, of messagesView: CKMessagesView) -> CKMessageData {
        return messages[indexPath.item]
//        return GridMessage(senderId: "incoming", sender: "Incoming", text: String(1))
        
    }
    
    
    func avatarImage(at indexPath: IndexPath, of messagesView: CKMessagesView) -> CKMessagesAvatarImageData? {
        
        let message = messages[indexPath.item]
        
        return avatarFactory.avater(initials: message.sender.initials,
                                    backgroundColor: UIColor.darkGray,
                                    textColor: UIColor.white,
                                    font: UIFont.preferredFont(forTextStyle: .headline))

    }
    
    
    
    public var senderId: String {
        return "outgoing"
    }
    
    public var sender: String {
        return "Kevin Chen"
    }
    
    func contentSize(at indexPath: IndexPath, of messagesView: CKMessagesView) -> CGSize {
                
        let value = indexPath.item % 4
        
        if value == 2 {
            return CGSize(width:240, height:50)
        } else if value == 3 {
            return CGSize(width:200, height:240)
        } else {
            return .zero
        }
        
        
//        return CGSize(width:240, height:50)
    }
    
    
}


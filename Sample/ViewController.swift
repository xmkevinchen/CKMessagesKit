//
//  ViewController.swift
//  Sample
//
//  Created by Kevin Chen on 8/24/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import UIKit
import CKMessagesViewController

class ViewController: CKMessagesViewController, CKMessagesViewMessaging, CKMessagesViewDecorating {
    
    var messages = [CKMessageData]()
        
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        messagesView.messenger = self
        messagesView.decorator = self
        
        messagesView.reloadData()
        
        // Do any additional setup after loading the view, typically from a nib.
        register(presentor: GridViewController.self, for: GridMessage.self)
        register(presentor: ListViewController.self, for: ListMessage.self)
//        (messagesView.collectionViewLayout as! CKMessagesCollectionViewLayout).messageFont = UIFont.systemFont(ofSize: 14)
        
        for i in 0..<100 {
            var message: CKMessageData?
            let value = i % 4
            
            switch value {
            case 0:
                message = CKMessage(senderId: senderId, sender: sender, text: "Your Apple ID must be associated with a paid Apple Developer Program or Apple Developer Enterprise Program to access certain software downloads.")
                
            case 1:
                message = CKMessage(senderId: "incoming", sender: "Incoming", text: "Get the latest beta releases of Xcode, iOS, macOS, watchOS, tvOS, and more.")
                
            case 2:
                message = GridMessage(senderId: "incoming", sender: "Incoming", text: String(i))
                
            case 3:
                message = ListMessage(senderId: "incoming", sender: "Incoming", text: String(i))
                
            default:
                break
            }
            
            if message != nil {
                messages.append(message!)
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    public func messageForItem(at indexPath: IndexPath, of messagesView: CKMessagesCollectionView) -> CKMessageData {
        return messages[indexPath.item]
        
    }
    
    
    
    public var senderId: String {
        return "outgoing"
    }
    
    public var sender: String {
        return "Kevin Chen"
    }
    
    func contentSize(at indexPath: IndexPath, of messagesView: CKMessagesCollectionView) -> CGSize {
                
        let value = indexPath.item % 4
        if value == 2 {
            return CGSize(width:240, height:50)
        } else if value == 3 {
            return CGSize(width:200, height:240)
        } else {
            return .zero
        }
    }
    
}


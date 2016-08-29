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
    
    
        
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        messagesView.messenger = self
        messagesView.decorator = self
        
        messagesView.reloadData()
        
        // Do any additional setup after loading the view, typically from a nib.
        register(presentor: GridViewController.self, for: CollectionMessage.self)
//        (messagesView.collectionViewLayout as! CKMessagesCollectionViewLayout).messageFont = UIFont.systemFont(ofSize: 14)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    public func messageForItem(at indexPath: IndexPath, of messagesView: CKMessagesCollectionView) -> CKMessageData {
        let value = indexPath.item % 3
        
        switch value {
        case 0:
            return CKMessage(senderId: senderId, sender: sender, text: "Your Apple ID must be associated with a paid Apple Developer Program or Apple Developer Enterprise Program to access certain software downloads.")
            
        case 1:
            return CKMessage(senderId: "fiona", sender: "Fiona", text: "Get the latest beta releases of Xcode, iOS, macOS, watchOS, tvOS, and more.")
            
        case 2:
            return CollectionMessage(senderId: "fiona", sender: "Fiona", text: String(indexPath.item))
            
        default:
            return CKMessage(senderId: senderId, sender: sender, text: "Send out message")
        }
    }
    
    
    
    public var senderId: String {
        return "kevin"
    }
    
    public var sender: String {
        return "Kevin Chen"
    }
    
    func contentSize(at indexPath: IndexPath, of messagesView: CKMessagesCollectionView) -> CGSize {
        if indexPath.item % 3 == 2 {
            return CGSize(width:240, height:50)
        } else {
            return .zero
        }
    }
    
}


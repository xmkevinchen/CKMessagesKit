//
//  ViewController.swift
//  Sample
//
//  Created by Kevin Chen on 8/24/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import UIKit
import CKMessagesViewController

class ViewController: CKMessagesViewController, CKMessagesViewDataSource {
    
    
    public var senderId: String {
        return "kevin"
    }
    
    public var sender: String {
        return "Kevin Chen"
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        dataSource = self
        register(presentor: GridViewController.self, for: CollectionMessage.self)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    
    func messageView(_ messageView: CKMessagesCollectionView, messageForItemAt indexPath: IndexPath) -> CKMessageData {
        
        if arc4random() % 3 == 0 {
            return CKMessage(senderId: senderId, sender: sender, text: "Send out message")
        } else {
            return CKMessage(senderId: "fiona", sender: "Fiona", text: "Incoming message")
        }
        
    }
}


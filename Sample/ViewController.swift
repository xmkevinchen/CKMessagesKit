//
//  ViewController.swift
//  Sample
//
//  Created by Kevin Chen on 8/24/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import UIKit
import CKMessagesViewController

class ViewController: CKMessagesViewController, CKMessagesViewDelegate {
    
    
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        delegate = self
        register(presentor: GridViewController.self, for: CollectionMessage.self)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    
    
    
    func messageView(_ messageView: CKMessagesCollectionView, messageForItemAt indexPath: IndexPath) -> CKMessageData {
        
        return CollectionMessage(senderId: "1", sender: "CK", text: String(indexPath.item))
        
    }
}


//
//  ViewController.swift
//  Sample
//
//  Created by Kevin Chen on 8/24/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import UIKit
import CKMessagesViewController

class ViewController: CKMessagesViewController {
    
    
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
     
        messagesView.register(CKMessagesViewCustomizeCell.self, forCellWithReuseIdentifier: "CKMessagesViewCustomizeCell")
                
        
    }

    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("====> cellForItem at: \(indexPath)")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CKMessagesViewCustomizeCell", for: indexPath) as! CKMessagesViewCustomizeCell
        return cell
    }
    
    
    
}


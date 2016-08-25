//
//  CKMessagesViewController.swift
//  CKCollectionViewForDataCard
//
//  Created by Chen Kevin on 8/17/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import UIKit

open class CKMessagesViewController: UIViewController {

    @IBOutlet weak var messagesView: CKMessagesCollectionView!
        
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        configure()
        
    }
    
    static open func nib() -> UINib {
        #if swift(>=3.0)
           return UINib(nibName: String(describing:CKMessagesViewController.self), bundle: Bundle(for: CKMessagesViewController.self))
        #else
            return UINib(nibName: String(CKMessagesViewController.self), bundle: Bundle(for: CKMessagesViewController.self))
        #endif
    }

    private func configure() {
        
        #if swift(>=3.0)
            type(of:self).nib().instantiate(withOwner: self, options: nil)
        #else
            self.dynamicType.nib().instantiate(withOwner: self, options: nil)
        #endif
        
        
        messagesView.topAnchor.constraint(equalTo: topLayoutGuide.topAnchor).isActive = true
        messagesView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        messagesView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        messagesView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.bottomAnchor).isActive = true
        
        messagesView.register(CKMessagesViewCell.nib(), forCellWithReuseIdentifier: CKMessagesViewCell.identifier())
        
        messagesView.delegate = self
        messagesView.dataSource = self
        messagesView.reloadData()
        
    }
}

extension CKMessagesViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CKMessagesViewCell", for: indexPath)
        cell.contentView.backgroundColor = UIColor.lightGray
        
        return cell
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let layout = collectionViewLayout as? CKMessagesCollectionViewLayout {
            return layout.sizeForItem(at: indexPath)
        } else {
            return CGSize.zero
        }
    }
    
}


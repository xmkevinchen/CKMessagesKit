//
//  CKMessagesViewController.swift
//  CKCollectionViewForDataCard
//
//  Created by Kevin Chen on 8/17/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import UIKit

public protocol CKMessagesViewDelegate: class {
    
    func messageView(_ messageView: CKMessagesCollectionView, messageForItemAt indexPath: IndexPath) -> CKMessageData
    
}

open class CKMessagesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet open weak var messagesView: CKMessagesCollectionView!
    
    open weak var delegate: CKMessagesViewDelegate?
    
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
    
    public func register(presentor: CKMessagePresenting.Type, for message: CKMessageData.Type) {
        
        registeredPresentors[String(describing: message)] = presentor
        
    }
    
    private var registeredPresentors = [String: CKMessagePresenting.Type]()
    private var presentors = [IndexPath: CKMessagePresenting]()
    private var reusablePresentors = [String: [CKMessagePresenting]]()
    
    private func presentor(at indexPath: IndexPath) -> CKMessagePresenting? {
        
        if let message = delegate?.messageView(messagesView, messageForItemAt: indexPath) {
            let key = String(describing: type(of:message))
            
            guard registeredPresentors[key] != nil else {
                return nil
            }
            
            if let presentor = reusablePresentors[key]?.last {
                reusablePresentors[key]?.removeLast()
                return presentor
            } else {
                let presentor = registeredPresentors[key]!.presentor(with: message)
                if presentor is UIViewController {
                    addChildViewController(presentor as! UIViewController)
                }
                return presentor
            }
        }
        
        return nil
        
    }
    
    private func recycle(presentor: CKMessagePresenting, at indexPath: IndexPath) {
        
        presentors.removeValue(forKey: indexPath)
        
        let key = String(describing:presentor.messageType)
        
        guard registeredPresentors[key] != nil else {
            return
        }
        
        if reusablePresentors[key] == nil {
            reusablePresentors[key] = [presentor]
        } else {
            reusablePresentors[key]?.append(presentor)
        }
        
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
                
        messagesView.register(CKMessagesViewCell.classForCoder(), forCellWithReuseIdentifier: "CKMessagesViewCell")
        
        
        messagesView.delegate = self
        messagesView.dataSource = self
        messagesView.reloadData()

    }
    
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CKMessagesViewCell", for: indexPath) as! CKMessagesViewCell
        if let presentor = presentor(at: indexPath) {
            cell.messageView = presentor.messageView
        }
        
        return cell
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let layout = collectionViewLayout as? CKMessagesCollectionViewLayout {
            
            return layout.sizeForItem(at: indexPath)
        } else {
            return CGSize.zero
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let presentor = presentors[indexPath] {
            recycle(presentor: presentor, at: indexPath)
        }
    }
}




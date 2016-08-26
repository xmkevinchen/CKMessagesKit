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
    
    private var usingPresentors = [IndexPath: CKMessagePresenting]()
    private var reusablePresentors = [String: [CKMessagePresenting]]()
    private var preparedPresentors = [IndexPath: CKMessagePresenting]()
    
    private func presentor(at indexPath: IndexPath) -> CKMessagePresenting? {
        
        if let message = delegate?.messageView(messagesView, messageForItemAt: indexPath) {
            
            let key = String(describing: type(of:message))
            
            guard registeredPresentors[key] != nil else {
                return nil
            }
            
            if let presentor = usingPresentors[indexPath] {
                return presentor
            }
            
            var presentor: CKMessagePresenting
            
            if #available(iOS 10, *) {
                if let _presentor = preparedPresentors[indexPath] {
                    preparedPresentors.removeValue(forKey: indexPath)
                    presentor = _presentor
                    usingPresentors[indexPath] = presentor
                    return presentor
                }
            }
                        
            
            if let _presentor = reusablePresentors[key]?.last {
                reusablePresentors[key]?.removeLast()
                presentor = _presentor
                presentor.message = message
            } else {
                presentor = registeredPresentors[key]!.presentor(with: message)
            }
            
            usingPresentors[indexPath] = presentor
            
            return presentor
        }
        
        
        return nil
        
    }
    
    func preparePresentor(for indexPath: IndexPath) {
        
        if let message = delegate?.messageView(messagesView, messageForItemAt: indexPath) {
            
            if var presentor = preparedPresentors[indexPath] {
                presentor.message = message
                return
            }
            
            let key = String(describing: type(of:message))
            
            guard registeredPresentors[key] != nil else {
                return
            }
            
            if var presentor = reusablePresentors[key]?.last {
                presentor.message = message
                reusablePresentors[key]?.removeLast()
                preparedPresentors[indexPath] = presentor
            } else {
                let presentor = registeredPresentors[key]!.presentor(with: message)
                preparedPresentors[indexPath] = presentor

            }
            
            
        }
        
        
    }
    
    private func recyclePresentor(at indexPath: IndexPath) {
        
        guard let presentor = usingPresentors[indexPath] else {
            return
        }
        
        usingPresentors.removeValue(forKey: indexPath)
        
        
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
        
        messagesView.translatesAutoresizingMaskIntoConstraints = false
                
        messagesView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        messagesView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        messagesView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        messagesView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
                
        messagesView.register(CKMessagesViewCell.self, forCellWithReuseIdentifier: String(describing: CKMessagesViewCell.self))
        
        
        messagesView.delegate = self
        messagesView.dataSource = self
        
        if #available(iOS 10, *) {
            messagesView.prefetchDataSource = self
        }
        
        messagesView.reloadData()
        
        
    }
    
    
    open override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        reusablePresentors.removeAll()
        preparedPresentors.removeAll()
        
        
    }
    
    
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CKMessagesViewCell.self), for: indexPath) as! CKMessagesViewCell
        
        preparePresentor(for: indexPath)
        
        
        return cell
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let layout = collectionViewLayout as? CKMessagesCollectionViewLayout {
            
            return layout.sizeForItem(at: indexPath)
        } else {
            return CGSize.zero
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if let cell = cell as? CKMessagesViewCell {
            
            guard let presentor = presentor(at: indexPath) , let message = delegate?.messageView(messagesView, messageForItemAt: indexPath) else {
                return
            }
            
            presentor.renderPresenting(with: message)
            cell.messageView = presentor.messageView
            
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        recyclePresentor(at: indexPath)
    }
    
}

@available(iOS 10, *)
extension CKMessagesViewController: UICollectionViewDataSourcePrefetching {
    
    public func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { preparePresentor(for: $0) }
    }
}




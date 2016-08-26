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

open class CKMessagesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {

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
    private var unusedPresentors = [String: [CKMessagePresenting]]()
    private var pretchedPresentors = [IndexPath: CKMessagePresenting]()
    
    private  func presentor(of message: CKMessageData, at indexPath: IndexPath) -> CKMessagePresenting? {
        
        let MessageType = String(describing: type(of:message))
        guard let PresentorType = registeredPresentors[MessageType] else {
            return nil
        }
        
        // If pretchPresentors has presentor for indexPath then just use it
        
        if let presentor = pretchedPresentors[indexPath] {
            usingPresentors[indexPath] = presentor
            pretchedPresentors.removeValue(forKey: indexPath)
            return presentor
        }
        
        
        if var presentor = unusedPresentors[MessageType]?.first {
            unusedPresentors[MessageType]?.removeFirst()
            usingPresentors[indexPath] = presentor
            presentor.message = message
            return presentor
        }
        
        var presentor = PresentorType.presentor()
        presentor.message = message
        usingPresentors[indexPath] = presentor
        return presentor
        
    }
    
    func prefetchPresentor(of message: CKMessageData, at indexPath: IndexPath) {
        
        guard pretchedPresentors[indexPath] == nil else {
            return
        }
        
        let MessageType = String(describing: type(of:message))
        guard let PresentorType = registeredPresentors[MessageType] else {
            return
        }
        
        if var presentor = unusedPresentors[MessageType]?.first {
            unusedPresentors[MessageType]?.removeFirst()
            presentor.message = message
            pretchedPresentors[indexPath] = presentor
        } else {
            var presentor = PresentorType.presentor()
            presentor.message = message
            pretchedPresentors[indexPath] = presentor
        }
        
    }
    
    
    private func recyclePresentor(at indexPath: IndexPath) {
        
        if let presentor = usingPresentors[indexPath] {
            usingPresentors.removeValue(forKey: indexPath)
            
            let MessageType = String(describing: presentor.messageType)
            if unusedPresentors[MessageType] == nil {
                unusedPresentors[MessageType] = []
            }
                        
            unusedPresentors[MessageType]!.append(presentor)
            
            presentor.messageView.removeFromSuperview()
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
        
        unusedPresentors.removeAll()
        pretchedPresentors.removeAll()
        usingPresentors.removeAll()
        
        messagesView.collectionViewLayout.invalidateLayout()
        
    }
    
    
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CKMessagesViewCell.self), for: indexPath) as! CKMessagesViewCell
        
        if #available(iOS 10, *) {
            
            /**
             * For some unknown reason, on iOS 10, the hostedView sometime would be added to wrong indexPath cell
             * which makes some cells are empty.
             * So on iOS 10, at least, for now, moving attaching hostedView process to @collectionView(_:willDisplay:forItemAt:) delegate could solve the issue
             */
            
        } else {
            if let message = delegate?.messageView(messagesView, messageForItemAt: indexPath),
                let presentor = presentor(of: message, at: indexPath) {
                cell.attach(hostedView: presentor.messageView)
            }
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
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if #available(iOS 10, *) {
            
            /**
             * For some unknown reason, on iOS 10, the hostedView sometime would be added to wrong indexPath cell
             * which makes some cells are empty.
             * So on iOS 10, at least, for now, process attaching hostedView in willDisplay could solve the issue
             */
            
            if let cell = cell as? CKMessagesViewCell,
                let message = delegate?.messageView(messagesView, messageForItemAt: indexPath),
                let presentor = presentor(of: message, at: indexPath) {
                cell.attach(hostedView: presentor.messageView)
                presentor.renderPresenting(with: message)
            }
        }
    }
    

    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        recyclePresentor(at: indexPath)
    }
    
    
    fileprivate func debuggingPresentors(place: StaticString = #function) {
        print("===> \(place) usingPresentors: \(usingPresentors)")
        print("===> \(place) unusedPresentors: \(unusedPresentors)")
        print("===> \(place) pretchedPresentors: \(pretchedPresentors)")
        print("")
        print("")
    }
}

@available(iOS 10, *)
extension CKMessagesViewController: UICollectionViewDataSourcePrefetching {
    
    public func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            if let message = delegate?.messageView(messagesView, messageForItemAt: indexPath) {
                prefetchPresentor(of: message, at: indexPath)
            }
        }
        
//        debuggingPresentors()
    
    }
}




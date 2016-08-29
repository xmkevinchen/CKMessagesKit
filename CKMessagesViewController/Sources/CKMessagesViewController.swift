//
//  CKMessagesViewController.swift
//  CKCollectionViewForDataCard
//
//  Created by Kevin Chen on 8/17/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import UIKit


open class CKMessagesViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    @IBOutlet open weak var messagesView: CKMessagesCollectionView!
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        configure()
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    static open func nib() -> UINib {
        #if swift(>=3.0)
           return UINib(nibName: String(describing:CKMessagesViewController.self), bundle: Bundle(for: CKMessagesViewController.self))
        #else
            return UINib(nibName: String(CKMessagesViewController.self), bundle: Bundle(for: CKMessagesViewController.self))
        #endif
    }
    
    open override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        unusedPresentors.removeAll()
        prefetchedPresentors.removeAll()
        usingPresentors.removeAll()
        
        messagesView.collectionViewLayout.invalidateLayout()
        
    }

    
    // MARK:- Public functions
    
    public func register(presentor: CKMessagePresenting.Type, for message: CKMessageData.Type) {
        
        registeredPresentors[String(describing: message)] = presentor
        
    }
    
    
    
    // MARK: - UICollectionView
    
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {        
        return 0
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        var cellForItem: UICollectionViewCell!
        
        if let messagesView = collectionView as? CKMessagesCollectionView,
            let message = messagesView.messenger?.messageForItem(at: indexPath, of: messagesView) {
            
            var messageCell: CKMessageDataViewCell!
            
            
            if hasPresentor(of: message) {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CKMessageHostedViewCell.self), for: indexPath) as! CKMessageHostedViewCell
                
                if #available(iOS 10, *) {
                    
                    /**
                     * For some unknown reason, on iOS 10, the hostedView sometime would be added to wrong indexPath cell
                     * which makes some cells are empty.
                     * So on iOS 10, at least, for now, moving attaching hostedView process to @collectionView(_:willDisplay:forItemAt:) delegate could solve the issue
                     */
                    
                } else {
                    if let presentor = presentor(of: message, at: indexPath) {
                        cell.attach(hostedView: presentor.messageView)
                    }
                }
                
                messageCell = cell
                
            } else {
                guard isProcessable(of: message) else {
                    fatalError("Unknown message type")
                }
                
                // Just for CKMessage now
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CKMessageViewCell.ReuseIdentifier, for: indexPath) as! CKMessageViewCell
                cell.textView.text = message.text
                
                messageCell = cell
            }
            
            let bubbleImageData = messagesView.decorator?.messageBubbleImage(at: indexPath, of: messagesView)
            
            if isOutgoing(message: message) {
                messageCell.direction = .outgoing
                
            } else {
                messageCell.direction = .incoming
            }
            
            messageCell.messageBubbleImageView.image = bubbleImageData?.image
            messageCell.messageBubbleImageView.highlightedImage = bubbleImageData?.highlightedImage
            
            cellForItem = messageCell
            
        }
        
        
        assert(cellForItem != nil)
        
        return cellForItem
        
        
        
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let layout = collectionViewLayout as? CKMessagesCollectionViewLayout {
            
            return layout.sizeForItem(at: indexPath)
        } else {
            return CGSize.zero
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        
        if let messagesView = collectionView as? CKMessagesCollectionView,
            let message = messagesView.messenger?.messageForItem(at: indexPath, of: messagesView) {
            
            if #available(iOS 10, *) {
                
                /**
                 * For some unknown reason, on iOS 10, the hostedView sometime would be added to wrong indexPath cell
                 * which makes some cells are empty.
                 * So on iOS 10, at least, for now, process attaching hostedView in willDisplay could solve the issue
                 */
                
                if let cell = cell as? CKMessageHostedViewCell,
                    let presentor = presentor(of: message, at: indexPath) {
                    cell.attach(hostedView: presentor.messageView)
                    presentor.renderPresenting(with: message)
                }
            }
        }
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        recyclePresentor(at: indexPath)
    }

            
    
    // MARK: - Private Properties
    
    private var registeredPresentors = [String: CKMessagePresenting.Type]()
    private var usingPresentors = [IndexPath: CKMessagePresenting]()
    private var unusedPresentors = [String: [CKMessagePresenting]]()
    private var prefetchedPresentors = [IndexPath: CKMessagePresenting]()
    
    // MARK: - Private functions
    
    private func hasPresentor(of message: CKMessageData) -> Bool {
        return registeredPresentors[String(describing: type(of:message))] != nil
    }
    
    private func isProcessable(of message: CKMessageData) -> Bool {
        var isProcessable = false
        
        switch message {
        case is CKMessage:
            isProcessable = true
        default:
            break
        }
        
        return isProcessable
        
    }
    
    private func presentor(of message: CKMessageData, at indexPath: IndexPath) -> CKMessagePresenting? {
        
        let MessageType = String(describing: type(of:message))
        guard let PresentorType = registeredPresentors[MessageType] else {
            return nil
        }
        
        // If pretchPresentors has presentor for indexPath then just use it
        
        if let presentor = prefetchedPresentors[indexPath] {
            usingPresentors[indexPath] = presentor
            prefetchedPresentors.removeValue(forKey: indexPath)
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
    
    fileprivate func prefetchPresentor(of message: CKMessageData, at indexPath: IndexPath) {
        
        guard prefetchedPresentors[indexPath] == nil else {
            return
        }
        
        let MessageType = String(describing: type(of:message))
        guard let PresentorType = registeredPresentors[MessageType] else {
            return
        }
        
        if var presentor = unusedPresentors[MessageType]?.first {
            unusedPresentors[MessageType]?.removeFirst()
            presentor.message = message
            prefetchedPresentors[indexPath] = presentor
        } else {
            var presentor = PresentorType.presentor()
            presentor.message = message
            prefetchedPresentors[indexPath] = presentor
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
        
        if #available(iOS 9, *) {
            
            messagesView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            messagesView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            messagesView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            messagesView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            
        } else {
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[m]|", options: [], metrics: nil, views: ["m": self.messagesView]))
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[m]|", options: [], metrics: nil, views: ["m": self.messagesView]))
            
        }
        
        messagesView.register(CKMessageHostedViewCell.self, forCellWithReuseIdentifier: CKMessageHostedViewCell.ReuseIdentifier)
        messagesView.register(CKMessageViewCell.self, forCellWithReuseIdentifier: CKMessageViewCell.ReuseIdentifier)
        
        
        messagesView.delegate = self
        messagesView.dataSource = self
                
        
        if #available(iOS 10, *) {
            messagesView.prefetchDataSource = self
        }
        
        
    }
    
    private func isOutgoing(message: CKMessageData) -> Bool {
        return message.senderId == messagesView.messenger?.senderId
    }
    
    fileprivate func debuggingPresentors(place: StaticString = #function) {
        print("===> \(place) usingPresentors: \(usingPresentors)")
        print("===> \(place) unusedPresentors: \(unusedPresentors)")
        print("===> \(place) pretchedPresentors: \(prefetchedPresentors)")
        print("")
        print("")
    }
}

@available(iOS 10, *)
extension CKMessagesViewController: UICollectionViewDataSourcePrefetching {
    
    public func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        guard let messagesView = collectionView as? CKMessagesCollectionView else {
            return
        }
        
        indexPaths.forEach { indexPath in
            if let message = messagesView.messenger?.messageForItem(at: indexPath, of: messagesView) {
                prefetchPresentor(of: message, at: indexPath)
            }
        }
        
        
    }
}




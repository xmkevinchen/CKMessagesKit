//
//  CKMessagesViewController.swift
//  CKCollectionViewForDataCard
//
//  Created by Kevin Chen on 8/17/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import UIKit
import Reusable



open class CKMessagesViewController: UIViewController, NibLoadable {
    
    @IBOutlet open weak var messagesView: CKMessagesView!
    @IBOutlet weak var inputToolbar: CKMessagesInputToolbar!
    private var toolbarHeight: CGFloat = 44.0
    
    
    // MARK: - Life Cycle
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        configure()
        toolbarHeight = inputToolbar.preferredDefaultHeight
        additionalContentInsets = .zero
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        toolbarHeight = inputToolbar.preferredDefaultHeight
        view.layoutIfNeeded()
        messagesView.collectionViewLayout.invalidateLayout()
        
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    open override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        unusedPresentors.removeAll()
        prefetchedPresentors.removeAll()
        usingPresentors.removeAll()
        
        messagesView.collectionViewLayout.invalidateLayout()
        
    }
    
    public static var nib: UINib {
        #if swift(>=3.0)
            return UINib(nibName: String(describing:CKMessagesViewController.self), bundle: Bundle(for: CKMessagesViewController.self))
        #else
            return UINib(nibName: String(CKMessagesViewController.self), bundle: Bundle(for: CKMessagesViewController.self))
        #endif
    }
    

    

    
    

    
    // MARK:- Public functions
    
    public func register(presentor: CKMessagePresenting.Type, for message: CKMessageData.Type) {
        
        registeredPresentors[String(describing: message)] = presentor
        
    }
    
    // MARK: - Private Properties
    
    fileprivate var registeredPresentors = [String: CKMessagePresenting.Type]()
    fileprivate var usingPresentors = [IndexPath: CKMessagePresenting]()
    fileprivate var unusedPresentors = [String: [CKMessagePresenting]]()
    fileprivate var prefetchedPresentors = [IndexPath: CKMessagePresenting]()
    
    
    private func configure() {
        
        #if swift(>=3.0)
            type(of:self).nib.instantiate(withOwner: self, options: nil)
        #else
            self.dynamicType.nib.instantiate(withOwner: self, options: nil)
        #endif
        
        messagesView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[m]|", options: [], metrics: nil, views: ["m": self.messagesView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[m]|", options: [], metrics: nil, views: ["m": self.messagesView]))
        
        messagesView.register(for: CKMessageDataViewCell.self)
        messagesView.register(for: CKMessageViewCell.self)
        
        messagesView.delegate = self
        messagesView.dataSource = self
                
        
        if #available(iOS 10, *) {
            messagesView.prefetchDataSource = self
        }
        
        
    }
    
    // MARK: - ContentInsets
    
    public var additionalContentInsets: UIEdgeInsets = .zero {
        
        didSet {
             
            let top = additionalContentInsets.top
            let bottom = toolbarHeight + additionalContentInsets.bottom
            
            let insets = UIEdgeInsets(top: topLayoutGuide.length + top,
                                      left: 0.0,
                                      bottom: bottomLayoutGuide.length + bottom,
                                      right: 0.0)

            
            contentInsets = insets
        }
    }
    
    private var contentInsets: UIEdgeInsets = .zero {
        
        didSet {
            if messagesView.contentInset != contentInsets {
                messagesView.contentInset = contentInsets
            }
            
            if messagesView.scrollIndicatorInsets != contentInsets {
                messagesView.scrollIndicatorInsets = contentInsets
            }
        }
    }
    
    
}


// MARK: - Presentor

extension CKMessagesViewController {
    
    
    fileprivate func hasPresentor(of message: CKMessageData) -> Bool {
        return registeredPresentors[String(describing: type(of:message))] != nil
    }
    
    fileprivate func isProcessable(of message: CKMessageData) -> Bool {
        var isProcessable = false
        
        switch message {
        case is CKMessage:
            isProcessable = true
        default:
            break
        }
        
        return isProcessable
        
    }
    
    fileprivate func presentor(of message: CKMessageData, at indexPath: IndexPath) -> CKMessagePresenting? {
        
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
    
    
    fileprivate func recyclePresentor(at indexPath: IndexPath) {
        
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
}


// MARK: - Rotation
extension CKMessagesViewController {
    
    open override var shouldAutorotate: Bool {
        return true
    }
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            return .allButUpsideDown
            
        default:
            return .all
        }
    }
    
    open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        resetLayoutAndCaches()
    }
    
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        resetLayoutAndCaches()
    }
    
    
    private func resetLayoutAndCaches() {
        let context = CKMessagesViewLayoutInvalidationContext.context()
        context.invalidateLayoutMessagesCache = true
        messagesView.collectionViewLayout.invalidateLayout(with: context)
    }
}

// MARK: - UICollectionView

extension CKMessagesViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        var cellForItem: UICollectionViewCell!
        
        if let messagesView = collectionView as? CKMessagesView,
            let message = messagesView.messenger?.messageForItem(at: indexPath, of: messagesView) {
            
            var messageCell: CKMessageDataViewCell!
            
            
            if hasPresentor(of: message) {
                let cell: CKMessageDataViewCell = collectionView.dequeueReusable(at: indexPath)
                
                if #available(iOS 10, *) {
                    
                    /**
                     * For some unknown reason, on iOS 10, the hostedView sometime would be added to wrong indexPath cell
                     * which makes some cells are empty.
                     * So on iOS 10, at least, for now, moving attaching hostedView process to @collectionView(_:willDisplay:forItemAt:) delegate could solve the issue
                     */
                    prefetchPresentor(of: message, at: indexPath)
                    
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
                
                let cell: CKMessageViewCell = collectionView.dequeueReusable(at: indexPath)
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
        
        
        return messagesView.messagesViewLayout.sizeForItem(at: indexPath)
        
//        if let layout = collectionViewLayout as? CKMessagesViewLayout {
//            
//            return layout.sizeForItem(at: indexPath)
//        } else {
//            return CGSize.zero
//        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        
        if let messagesView = collectionView as? CKMessagesView,
            let message = messagesView.messenger?.messageForItem(at: indexPath, of: messagesView) {
            
            if #available(iOS 10, *) {
                
                /**
                 * For some unknown reason, on iOS 10, the hostedView sometime would be added to wrong indexPath cell
                 * which makes some cells are empty.
                 * So on iOS 10, at least, for now, process attaching hostedView in willDisplay could solve the issue
                 */
                
                if let cell = cell as? CKMessageDataViewCell,
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
    
    fileprivate func isOutgoing(message: CKMessageData) -> Bool {
        return message.senderId == messagesView.messenger?.senderId
    }
}

@available(iOS 10, *)
extension CKMessagesViewController: UICollectionViewDataSourcePrefetching {
    
    public func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        guard let messagesView = collectionView as? CKMessagesView else {
            return
        }
        
        indexPaths.forEach { indexPath in
            if let message = messagesView.messenger?.messageForItem(at: indexPath, of: messagesView) {
                prefetchPresentor(of: message, at: indexPath)
            }
        }
        
        
    }
}

// MARK: - Debugging
extension CKMessagesViewController {
    fileprivate func debuggingPresentors(place: StaticString = #function) {
        print("===> \(place) usingPresentors: \(usingPresentors)")
        print("===> \(place) unusedPresentors: \(unusedPresentors)")
        print("===> \(place) pretchedPresentors: \(prefetchedPresentors)")
        print("")
        print("")
    }
}



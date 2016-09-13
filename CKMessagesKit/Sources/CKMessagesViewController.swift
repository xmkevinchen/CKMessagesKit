//
//  CKMessagesViewController.swift
//  CKCollectionViewForDataCard
//
//  Created by Kevin Chen on 8/17/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import UIKit
import Reusable

open class CKMessagesViewController: UIViewController {
    
    // MARK: - Public Properties
    
    @IBOutlet public weak var messagesView: CKMessagesView!
    @IBOutlet public weak var inputToolbar: CKMessagesToolbar!
    
    @IBOutlet weak var inputToobarBottomConstraint: NSLayoutConstraint!
    
    /// Specify the bar item should be enabled automatically when the `textView` contains text
    public weak var enablesAutomaticallyBarItem: CKMessagesToolbarItem? {
        didSet {
            enablesAutomaticallyBarItem?.isEnabled = inputToolbar.contentView.textView.hasText
        }
    }
    
    public static var nib: UINib {
        #if swift(>=3.0)
            return UINib(nibName: String(describing:CKMessagesViewController.self), bundle: Bundle(for: CKMessagesViewController.self))
        #else
            return UINib(nibName: String(CKMessagesViewController.self), bundle: Bundle(for: CKMessagesViewController.self))
        #endif
    }
    
    public var automaticallyScrollsToMostRecentMessage: Bool = true {
        
        didSet {
            guard automaticallyScrollsToMostRecentMessage else {
                return
            }
            
            scrollToBottom(animated: true)
        }
    }
    
    public var additionalContentInsets: UIEdgeInsets = .zero {
        didSet {
            updateMessagesViewInsets()
        }
    }
    
    public var isShowingIndicator: Bool = false {
        
        didSet {
            guard isShowingIndicator != oldValue else {
                return
            }
            
            messagesView.messagesViewLayout.invalidateLayout(with: CKMessagesViewLayoutInvalidationContext.context())
            messagesView.messagesViewLayout.invalidateLayout()
        }
    }
        
    // MARK: - Private Properties
    
    fileprivate var toolbarHeight: CGFloat = 44.0
    fileprivate var registeredPresentors = [String: CKMessagePresenting.Type]()
    fileprivate var usingPresentors = [IndexPath: CKMessagePresenting]()
    fileprivate var unusedPresentors = [String: [CKMessagePresenting]]()
    fileprivate var prefetchedPresentors = [IndexPath: CKMessagePresenting]()
    fileprivate var keyboardEndFrame: CGRect = .zero
    
    // MARK: - Life Cycle
    
    deinit {
        removePresentors()
        unregisterObservers()
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        configure()
        registerObservers()
        
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        toolbarHeight = inputToolbar.preferredDefaultHeight        
        messagesView.collectionViewLayout.invalidateLayout()
        updateMessagesViewInsets()
        
        if automaticallyScrollsToMostRecentMessage {
            DispatchQueue.main.async {
                self.scrollToBottom(animated: false)
                self.messagesView.messagesViewLayout.invalidateLayout(with: CKMessagesViewLayoutInvalidationContext.context())
            }
        }
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
        
    open override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        removePresentors()
        
        messagesView.collectionViewLayout.invalidateLayout()
        messagesView.setNeedsLayout()
        
    }
    
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let toobar = inputToolbar {
            if toolbarHeight != toobar.bounds.height {
                toolbarHeight = toobar.bounds.height
                updateMessagesViewInsets(with: keyboardEndFrame)
                scrollToBottom(animated: true)
            }
        }
    }
    
    

    
    private func configure() {
        
        #if swift(>=3.0)
            type(of:self).nib.instantiate(withOwner: self, options: nil)
        #else
            self.dynamicType.nib.instantiate(withOwner: self, options: nil)
        #endif
        
        messagesView.translatesAutoresizingMaskIntoConstraints = false
        
        messagesView.register(for: CKMessageBasicCell.self)
        messagesView.register(for: CKMessageTextCell.self)
        messagesView.register(forSupplementaryView: UICollectionElementKindSectionFooter, for: CKMessagesIndicatorFooterView.self)
        
        messagesView.delegate = self
        messagesView.dataSource = self
                
        
        if #available(iOS 10, *) {
            messagesView.prefetchDataSource = self
        }
        
        automaticallyScrollsToMostRecentMessage = true
        
        toolbarHeight = inputToolbar.preferredDefaultHeight
        
        inputToolbar.contentView.textView.placeHolder = "New Message"
        inputToolbar.contentView.textView.delegate = self
//        inputToolbar.removeFromSuperview()
        
        additionalContentInsets = .zero
        updateMessagesViewInsets()                
    }

    
    
}


// MARK: - Presentor

extension CKMessagesViewController {
    
    
    /// Register presentor type of specified message type
    ///
    /// - parameter presentor: Presentor type
    /// - parameter message:   Message type
    public func register(presentor: CKMessagePresenting.Type, for message: CKMessageData.Type) {
        registeredPresentors[String(describing: message)] = presentor
    }
    
    
    fileprivate func hasPresentor(of message: CKMessageData) -> Bool {
        return registeredPresentors[String(describing: type(of:message))] != nil
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
        
        if let child = presentor as? UIViewController {
            addChildViewController(child)
            child.didMove(toParentViewController: self)
        }
        
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
            
            if let child = presentor as? UIViewController {
                addChildViewController(child)
                child.didMove(toParentViewController: self)
            }
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
    
    
    fileprivate func removePresentors() {
        unusedPresentors.flatMap { return $0.value }.forEach { presentor in
            if let presentor = presentor as? UIViewController {
                presentor.removeFromParentViewController()
            }
        }
        
        unusedPresentors.removeAll()
        
        prefetchedPresentors.flatMap { return $0.value }.forEach { presentor in
            if let presentor = presentor as? UIViewController {
                presentor.removeFromParentViewController()
            }
        }
        
        prefetchedPresentors.removeAll()
        
        usingPresentors.flatMap { return $0.value }.forEach { presentor in
            if let presentor = presentor as? UIViewController {
                presentor.removeFromParentViewController()
            }
        }
        
        usingPresentors.removeAll()
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


// MARK: - Scrolling & Insets

extension CKMessagesViewController {
    
    fileprivate func updateMessagesViewInsets(with keyboradFrame: CGRect = .zero) {
        self.keyboardEndFrame = keyboradFrame
        
        let top = additionalContentInsets.top + topLayoutGuide.length
        let bottom = additionalContentInsets.bottom
            + toolbarHeight
            + keyboradFrame.height
            + bottomLayoutGuide.length
        
        let insets = UIEdgeInsets(top: top,
                                  left: additionalContentInsets.left,
                                  bottom: bottom,
                                  right: additionalContentInsets.right)
        
        self.messagesView.contentInset = insets
        self.messagesView.scrollIndicatorInsets = insets
    }
    
    
    public func scrollToBottom(animated: Bool) {
        let numberOfItems = messagesView.numberOfItems(inSection: 0)
        guard messagesView.numberOfSections == 1 && numberOfItems >= 1 else {
            return
        }
        
        let indexPath = IndexPath(item: numberOfItems - 1, section: 0)
        scroll(to: indexPath, animated: animated)
        
    }
    
    public func scroll(to indexPath: IndexPath, animated: Bool) {
        if messagesView.numberOfSections <= indexPath.section {
            return
        }
        
        let numberOfItems = messagesView.numberOfItems(inSection: 0)
        if numberOfItems == 0 {
            return
        }
        
        let contentHeight = messagesView.messagesViewLayout.collectionViewContentSize.height
        
        if contentHeight < messagesView.bounds.height {
            messagesView.scrollRectToVisible(CGRect(x: 0.0, y: contentHeight - 1.0, width: 1.0, height: 1.0), animated: animated)
            return
        }
        
        let item = max(min(indexPath.item, numberOfItems - 1), 0)
        let indexPath = IndexPath(item: item, section: 0)
        let size = messagesView.messagesViewLayout.sizeForItem(at: indexPath)
        let heightForVisibleMessage = messagesView.bounds.height
            - messagesView.contentInset.top
            - messagesView.contentInset.bottom
            - inputToolbar.bounds.height
        
        let scrollPosition: UICollectionViewScrollPosition = size.height > heightForVisibleMessage ? .bottom : .top
        
        messagesView.scrollToItem(at: indexPath, at: scrollPosition, animated: animated)
        
    }
}

// MARK: - Notification

extension CKMessagesViewController {
    
    fileprivate func registerObservers() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveKeyboardWillShow(_:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveKeyboardWillHide(_:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didReceivePreferredContentSizeChanged(_:)), name: Notification.Name.UIContentSizeCategoryDidChange, object: nil)
        
        
    }
    
    fileprivate func unregisterObservers() {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @objc private func didReceiveKeyboardWillShow(_ notification: Notification) {
        
        if let userInfo = notification.userInfo,
            let keyboardEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let animationCurve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? Int,
            let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double 
        {
        
            
            guard !keyboardEndFrame.isNull else {
                return
            }
            
            
            let animationOption = UIViewAnimationOptions(rawValue: UInt(animationCurve << 16))

            UIView.animate(withDuration: animationDuration,
                           delay: 0.0,
                           options: [animationOption],
                           animations:
                {
                    self.updateMessagesViewInsets(with: keyboardEndFrame)
                    self.inputToobarBottomConstraint.constant = keyboardEndFrame.height
                    self.view.layoutIfNeeded()
                    self.scrollToBottom(animated: true)

                    
                }, completion: { _ in })
        }
        
    }
    
    @objc private func didReceiveKeyboardWillHide(_ notification: Notification) {
        
        if let userInfo = notification.userInfo,
            let keyboardEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let animationCurve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? Int,
            let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double
        {
            
            
            guard !keyboardEndFrame.isNull else {
                return
            }
            
            
            let animationOption = UIViewAnimationOptions(rawValue: UInt(animationCurve << 16))
            
            UIView.animate(withDuration: animationDuration,
                           delay: 0.0,
                           options: [animationOption],
                           animations:
                {
                    self.updateMessagesViewInsets(with: .zero)
                    self.inputToobarBottomConstraint.constant = 0
                    self.view.layoutIfNeeded()
                    
                    
                }, completion: { _ in })
        }
        
    }
    
    

    
    @objc private func didReceivePreferredContentSizeChanged(_ notification: Notification) {
        messagesView.messagesViewLayout.invalidateLayout()
        messagesView.setNeedsLayout()
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
            
            var messageCell: CKMessageBasicCell!
            
            
            if hasPresentor(of: message) {
                let cell: CKMessageBasicCell = collectionView.dequeueReusable(at: indexPath)
                
                if #available(iOS 10, *) {
                    
                    /**
                     * For some unknown reason, on iOS 10, the hostedView sometime would be added to wrong indexPath cell
                     * which makes some cells are empty.
                     * So on iOS 10, at least, for now, moving attaching hostedView process to @collectionView(_:willDisplay:forItemAt:) delegate could solve the issue
                     */
                    prefetchPresentor(of: message, at: indexPath)
                    
                } else {
                    if let presentor = presentor(of: message, at: indexPath) {
                        cell.messageView = presentor.messageView
                    }
                }

                
                messageCell = cell
                
            } else {
                
                // For all unregistered / unknown message type, handle as text message, which is the basic case of messages view
                
                let cell: CKMessageTextCell = collectionView.dequeueReusable(at: indexPath)
                cell.textView.text = message.text
                cell.textView.dataDetectorTypes = .all
                                
                messageCell = cell
            }
            
            
            var needsAvatar: Bool = true
            let isOutgoing = self.isOutgoing(message: message)
            if isOutgoing {
                messageCell.orientation = .outgoing
                if messagesView.messagesViewLayout.outgoingAvatarSize == .zero {
                    needsAvatar = false
                }
                
            } else {
                messageCell.orientation = .incoming
                if messagesView.messagesViewLayout.incomingAvatarSize == .zero {
                    needsAvatar = false
                }
            }
            
            
            var avatarImageData: CKMessagesAvatarImageData?
            
            if needsAvatar {
                avatarImageData = messagesView.decorator?.messagesView(messagesView, layout: messagesView.messagesViewLayout, avatarAt: indexPath)
                messageCell.avatarImageView.image = avatarImageData?.avatar
                messageCell.avatarImageView.highlightedImage = avatarImageData?.highlighted                
            }
            
            let bubbleImageData = messagesView.decorator?.messagesView(messagesView, layout: messagesView.messagesViewLayout, messageBubbleAt: indexPath)
            messageCell.bubbleImageView.image = bubbleImageData?.image
            messageCell.bubbleImageView.highlightedImage = bubbleImageData?.highlightedImage
            
            if let attributedText = messagesView.decorator?.messagesView(messagesView, layout: messagesView.messagesViewLayout, attributedTextForTopLabelAt: indexPath) {
                messageCell.topLabel.attributedText = attributedText
            } else if let text = messagesView.decorator?.messagesView(messagesView, layout: messagesView.messagesViewLayout, textForTopLabelAt: indexPath) {
                messageCell.topLabel.text = text
            }
            
            if let attributedText = messagesView.decorator?.messagesView(messagesView, layout: messagesView.messagesViewLayout, attributedTextForBubbleTopLabelAt: indexPath) {
                messageCell.bubbleTopLabel.attributedText = attributedText
            } else if let text = messagesView.decorator?.messagesView(messagesView, layout: messagesView.messagesViewLayout, textForBubbleTopLabelAt: indexPath) {
                
                var messageTopLabelInset: CGFloat = 15
                let textInsets = messageCell.bubbleTopLabel.textInsets
                if isOutgoing {
                    if messagesView.messagesViewLayout.outgoingAvatarSize != .zero {
                        messageTopLabelInset += messagesView.messagesViewLayout.outgoingAvatarSize.width
                    }
                    messageCell.bubbleTopLabel.textAlignment = .right
                    messageCell.bubbleTopLabel.textInsets = UIEdgeInsets(top: textInsets.top, left: 0, bottom: textInsets.bottom, right: messageTopLabelInset)
                    
                } else {
                    
                    if messagesView.messagesViewLayout.incomingAvatarSize != .zero {
                        messageTopLabelInset += messagesView.messagesViewLayout.incomingAvatarSize.width
                    }
                    
                    messageCell.bubbleTopLabel.textAlignment = .left
                    messageCell.bubbleTopLabel.textInsets = UIEdgeInsets(top: textInsets.top, left: messageTopLabelInset, bottom: textInsets.bottom, right: 0)
                }
                messageCell.bubbleTopLabel.text = text
            }
            
            
            
            if let attributedText = messagesView.decorator?.messagesView(messagesView, layout: messagesView.messagesViewLayout, attributedTextForBottomLabelAt: indexPath) {
                messageCell.bottomLabel.attributedText = attributedText
            } else if let text = messagesView.decorator?.messagesView(messagesView, layout: messagesView.messagesViewLayout, textForBottomLabelAt: indexPath) {
                messageCell.bottomLabel.text = text
                
                if  isOutgoing {
                    messageCell.bottomLabel.textAlignment = .right
                } else {
                    messageCell.bottomLabel.textAlignment = .left
                }
            }
                        
            cellForItem = messageCell
                        
        }
        
        assert(cellForItem != nil)
        
        cellForItem.layer.rasterizationScale = UIScreen.main.scale
        cellForItem.layer.shouldRasterize = true
        
        return cellForItem
        
        
        
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return messagesView.messagesViewLayout.sizeForItem(at: indexPath)
        
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
                
                if let cell = cell as? CKMessageBasicCell, let presentor = presentor(of: message, at: indexPath) {
                    cell.messageView = presentor.messageView
                    presentor.renderPresenting(with: message)
                }
            }
        }               
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        recyclePresentor(at: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionElementKindSectionFooter:
            
            let indicator: CKMessagesIndicatorFooterView = collectionView.dequeueReusable(forSupplementaryView: UICollectionElementKindSectionFooter, at: indexPath)
            return indicator
            
        default:
            fatalError()
        }
        
    }
        
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return isShowingIndicator ? CGSize(width: messagesView.messagesViewLayout.itemWidth, height: 30) : .zero
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

// MARK: - Receive & Send Message
extension CKMessagesViewController {
    
    
    public func finishSendingMessage(animated: Bool = true) {
        let textView = inputToolbar.contentView.textView!
        textView.text = nil
        textView.undoManager?.removeAllActions()
        textView.delegate?.textViewDidChange?(textView)
        
        messagesView.messagesViewLayout.invalidateLayout(with: CKMessagesViewLayoutInvalidationContext.context())
        messagesView.reloadData()
        
        if automaticallyScrollsToMostRecentMessage {
            scrollToBottom(animated: animated)
        }
        
    }
    
    public func finishReceivingMessage(animated: Bool = true) {
                        
        messagesView.messagesViewLayout.invalidateLayout(with: CKMessagesViewLayoutInvalidationContext.context())
        messagesView.reloadData()
        
        if automaticallyScrollsToMostRecentMessage {
            scrollToBottom(animated: animated)
        }
    }
    
}

// MARK: - TextView Delegate

extension CKMessagesViewController: UITextViewDelegate {
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        
        guard textView == inputToolbar.contentView.textView else {
            return
        }
        
        textView.becomeFirstResponder()
        
        if automaticallyScrollsToMostRecentMessage {
            scrollToBottom(animated: true)
        }
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        
        guard textView == inputToolbar.contentView.textView else {
            return
        }
        
        textView.resignFirstResponder()
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        
        guard textView == inputToolbar.contentView.textView else {
            return
        }
        
        enablesAutomaticallyBarItem?.isEnabled = textView.hasText
    }
    
    public func currentlyComposedMessageText() -> String {
        
        let textView = inputToolbar.contentView.textView!
        textView.inputDelegate?.selectionWillChange(textView)
        textView.inputDelegate?.selectionDidChange(textView)
        
        return textView.text.trimmingCharacters(in: .whitespaces)
    }
}

//// MARK: - Input
//
//extension CKMessagesViewController {
//
//    open override var canBecomeFirstResponder: Bool {
//        return true
//    }
//
//    open override var inputAccessoryView: UIView? {
//        return self.inputToolbar
//    }
//
//}


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



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
    @IBOutlet public var inputToolbar: CKMessagesToolbar!
    @IBOutlet public var inputToolbarBottomConstraint: NSLayoutConstraint!
    @IBOutlet public var inputToolbarLeadingConstraint: NSLayoutConstraint!
    @IBOutlet public var inputToolbarTrailingConstraint: NSLayoutConstraint!
    
    /// Specify the bar item should be enabled automatically when the `textView` contains text
    public weak var enablesAutomaticallyBarItem: CKMessagesToolbarItem? {
        didSet {
            enablesAutomaticallyBarItem?.isEnabled = inputToolbar.contentView.textView.hasText
        }
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

    fileprivate var hasRegistered: Bool = false
    fileprivate var toolbarHeight: CGFloat = 44.0
    
    // MARK: - Life Cycle
    
    deinit {
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
        
        
        messagesView.collectionViewLayout.invalidateLayout()
        view.layoutIfNeeded()
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
        
        inputToolbar.backgroundColor = UIColor.clear
    }
    
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateMessagesViewInsets()
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    
        if toolbarHeight != inputToolbar.bounds.height {
            toolbarHeight = inputToolbar.bounds.height
            let keyboardFrame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - inputToolbar.frame.maxY)
            updateMessagesViewInsets(with: keyboardFrame)
            
            if automaticallyScrollsToMostRecentMessage {
                scrollToBottom(animated: true)
            }
        }

    }
    
        
    open override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
                
        messagesView.collectionViewLayout.invalidateLayout()
        messagesView.setNeedsLayout()
        
    }
    
    
    private func configure() {
        
        if self.messagesView == nil {
            let messagesView = CKMessagesView(frame: .zero, collectionViewLayout: CKMessagesViewLayout())
            messagesView.backgroundColor = UIColor.white
            view.addSubview(messagesView)
            view.pinSubview(messagesView)
            self.messagesView = messagesView
        }
        
        if inputToolbar == nil {
            inputToolbar = CKMessagesToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44.0))
            view.addSubview(inputToolbar)
            
        }
        
        if inputToolbarBottomConstraint == nil {
            inputToolbarBottomConstraint = NSLayoutConstraint(item: view, attribute: .bottom,
                                                              relatedBy: .equal,
                                                              toItem: inputToolbar, attribute: .bottom,
                                                              multiplier: 1.0, constant: 0)
            view.addConstraint(inputToolbarBottomConstraint)
        }
        
        if inputToolbarLeadingConstraint == nil {
            inputToolbarLeadingConstraint = NSLayoutConstraint(item: inputToolbar, attribute: .leading,
                                                               relatedBy: .equal,
                                                               toItem: view, attribute: .leading,
                                                               multiplier: 1.0, constant: 0)
            view.addConstraint(inputToolbarLeadingConstraint)
        }
        
        if inputToolbarTrailingConstraint == nil {
            inputToolbarTrailingConstraint = NSLayoutConstraint(item: view, attribute: .trailing,
                                                                relatedBy: .equal,
                                                                toItem: inputToolbar, attribute: .trailing,
                                                                multiplier: 1.0, constant: 0)
            view.addConstraint(inputToolbarTrailingConstraint)
        }
        
        inputToolbar.translatesAutoresizingMaskIntoConstraints = false
        messagesView.translatesAutoresizingMaskIntoConstraints = false
        messagesView.alwaysBounceVertical = true
        
                                
        messagesView.delegate = self
        messagesView.dataSource = self
                
        
        if #available(iOS 10, *) {
            messagesView.prefetchDataSource = self
        }
        
        automaticallyScrollsToMostRecentMessage = true
        
        toolbarHeight = inputToolbar.preferredDefaultHeight
        inputToolbar.contentView.textView.placeHolder = "New Message"
        inputToolbar.contentView.textView.delegate = self
        
        additionalContentInsets = .zero        
        
        
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
        
        let top = additionalContentInsets.top + topLayoutGuide.length
        let bottom = additionalContentInsets.bottom + toolbarHeight + keyboradFrame.height
        
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
        
        let scrollPosition: UICollectionViewScrollPosition = size.height > heightForVisibleMessage ? [.bottom] : [.top]
        
        messagesView.scrollToItem(at: indexPath, at: scrollPosition, animated: animated)
        
    }
}

// MARK: - Notification

extension CKMessagesViewController {
    
    fileprivate func registerObservers() {
        
        guard !hasRegistered else { return }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didReceiveKeyboardWillShow(_:)),
                                               name: Notification.Name.UIKeyboardWillShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didReceiveKeyboardWillHide(_:)),
                                               name: Notification.Name.UIKeyboardWillHide,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didReceivePreferredContentSizeChanged(_:)),
                                               name: Notification.Name.UIContentSizeCategoryDidChange,
                                               object: nil)
        
    }
    
    fileprivate func unregisterObservers() {
        guard hasRegistered else { return }
        NotificationCenter.default.removeObserver(self)
    }
    
    
    open func didReceiveKeyboardWillShow(_ notification: Notification) {
        
        if let userInfo = notification.userInfo,
            let keyboardEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let animationCurve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? Int,
            let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double
        {
            
            
            guard !keyboardEndFrame.isNull else {
                return
            }
            
            var keyboardFrame = keyboardEndFrame
            
            // Hardware keyboards
            if keyboardEndFrame.origin.y + keyboardEndFrame.height > view.frame.height {
                keyboardFrame.size.height = view.frame.height - keyboardEndFrame.origin.y
            }
            
            let animationOption = UIViewAnimationOptions(rawValue: UInt(animationCurve << 16))
            
            UIView.animate(withDuration: animationDuration,
                           delay: 0.0,
                           options: [animationOption],
                           animations:
                {
                    self.inputToolbarBottomConstraint.constant = keyboardFrame.height
                    self.updateMessagesViewInsets(with: keyboardFrame)
                    self.view.layoutIfNeeded()
                    
                    if self.automaticallyScrollsToMostRecentMessage {
                        self.scrollToBottom(animated: true)
                    }
                    
                    
                }, completion: { _ in })
        }
        
    }
    
    open func didReceiveKeyboardWillHide(_ notification: Notification) {
        
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
                    self.inputToolbarBottomConstraint.constant = 0
                    self.view.layoutIfNeeded()
                    
                    
                }, completion: { _ in })
        }
        
    }
    
    

    
    open func didReceivePreferredContentSizeChanged(_ notification: Notification) {
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
        
        /// Dequeue the basic cell to be rendered
        let cell: CKMessageBasicCell = collectionView.dequeueReusable(at: indexPath)
        guard let message = messagesView.messenger?.messageForItem(at: indexPath, of: messagesView) else {
            fatalError()
        }
        
        let orientation: CKMessageOrientation
            = (message.senderId == messagesView.messenger?.senderId) ? .outgoing : .incoming
        cell.orientation = orientation
        
        /// Dequeu proper presentor for cell and message
        let presentor = messagesView.dequeueReusablePresentor(of: type(of: message), at: indexPath)
        presentor.message = message
        cell.messageView = presentor.messageView

        if let presentor = presentor as? CKMessageMaskablePresentor {
            if presentor.messageView.frame.size != presentor.size {
                var frame = presentor.messageView.frame
                frame.size = presentor.size
                presentor.messageView.frame = frame
            }
            
            CKMessagesBubbleImageMasker.apply(to: presentor.messageView, orientation: orientation)
        }
        
        
        let bubbleImageData = messagesView.decorator?.messagesView(messagesView, layout: messagesView.messagesViewLayout, messageBubbleAt: indexPath)
        cell.bubbleImageView.image = bubbleImageData?.image
        cell.bubbleImageView.highlightedImage = bubbleImageData?.highlightedImage
    
        if let attributedText = messagesView.decorator?.messagesView(messagesView, layout: messagesView.messagesViewLayout, attributedTextForTopLabelAt: indexPath) {
            cell.topLabel.attributedText = attributedText
        } else if let text = messagesView.decorator?.messagesView(messagesView, layout: messagesView.messagesViewLayout, textForTopLabelAt: indexPath) {
            cell.topLabel.text = text
        }
        
        if let attributedText = messagesView.decorator?.messagesView(messagesView, layout: messagesView.messagesViewLayout, attributedTextForBubbleTopLabelAt: indexPath) {
            cell.bubbleTopLabel.attributedText = attributedText
        } else if let text = messagesView.decorator?.messagesView(messagesView, layout: messagesView.messagesViewLayout, textForBubbleTopLabelAt: indexPath) {
            
            var messageTopLabelInset: CGFloat = 15
            let textInsets = cell.bubbleTopLabel.textInsets
            if orientation == .outgoing {
                if messagesView.messagesViewLayout.outgoingAvatarSize != .zero {
                    messageTopLabelInset += messagesView.messagesViewLayout.outgoingAvatarSize.width
                }
                cell.bubbleTopLabel.textAlignment = .right
                cell.bubbleTopLabel.textInsets = UIEdgeInsets(top: textInsets.top, left: 0, bottom: textInsets.bottom, right: messageTopLabelInset)
                
            } else {
                
                if messagesView.messagesViewLayout.incomingAvatarSize != .zero {
                    messageTopLabelInset += messagesView.messagesViewLayout.incomingAvatarSize.width
                }
                
                cell.bubbleTopLabel.textAlignment = .left
                cell.bubbleTopLabel.textInsets = UIEdgeInsets(top: textInsets.top, left: messageTopLabelInset, bottom: textInsets.bottom, right: 0)
            }
            cell.bubbleTopLabel.text = text
        }
        
        
        
        if let attributedText = messagesView.decorator?.messagesView(messagesView, layout: messagesView.messagesViewLayout, attributedTextForBottomLabelAt: indexPath) {
            cell.bottomLabel.attributedText = attributedText
        } else if let text = messagesView.decorator?.messagesView(messagesView, layout: messagesView.messagesViewLayout, textForBottomLabelAt: indexPath) {
            cell.bottomLabel.text = text
            
            if  orientation == .outgoing {
                cell.bottomLabel.textAlignment = .right
            } else {
                cell.bottomLabel.textAlignment = .left
            }
        }
        
        var needsAvatar: Bool = true
        if orientation == .outgoing {
            if messagesView.messagesViewLayout.outgoingAvatarSize == .zero {
                needsAvatar = false
            }
        } else {
            if messagesView.messagesViewLayout.incomingAvatarSize == .zero {
                needsAvatar = false
            }
        }
        
        var avatarImageData: CKMessagesAvatarImageData?
        
        if needsAvatar {
            avatarImageData = messagesView.decorator?.messagesView(messagesView, layout: messagesView.messagesViewLayout, avatarAt: indexPath)
            cell.avatarImageView.image = avatarImageData?.avatar
            cell.avatarImageView.highlightedImage = avatarImageData?.highlighted
        }


        return cell

    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {        
        return messagesView.messagesViewLayout.sizeForItem(at: indexPath)
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        messagesView.recycleReusablePresentor(at: indexPath)
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
        messagesView.prefetchPresentors(at: indexPaths)
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

extension CKMessagesViewController: UIScrollViewDelegate {
    
}

// MARK: - Input

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





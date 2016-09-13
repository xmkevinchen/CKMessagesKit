//
//  CKMessagesComposerTextView.swift
//  CKMessagesKit
//
//  Created by Kevin Chen on 8/30/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import UIKit

public class CKMessagesComposerTextView: UITextView {
    
    public override var hasText: Bool {
        return text.trimmingCharacters(in: .whitespaces)
            .lengthOfBytes(using: .utf8) > 0
    }
    
    public var placeHolder: String? {
        didSet {
            guard placeHolder != oldValue else {
                return
            }
            
            setNeedsDisplay()
        }
    }
    public var placeHolderTextColor: UIColor? {
        didSet {
            guard placeHolderTextColor != oldValue else {
                return
            }
            
            setNeedsDisplay()
        }
    }

    override public func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        configure()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public var bounds: CGRect {
        
        didSet {
            if contentSize.height <= bounds.size.height + 1 {
                contentOffset = .zero
            }
        }
    }
    
    override public var text: String! {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override public var attributedText: NSAttributedString! {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override public var font: UIFont? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override public var textAlignment: NSTextAlignment {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var heightConstraint: NSLayoutConstraint?
    private var minHeightConstraint: NSLayoutConstraint?
    private var maxHeightConstraint: NSLayoutConstraint?
    
    
    private func configure() {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        let cornerRadius: CGFloat = 6.0
        backgroundColor = UIColor.white
        
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 0.5
        layer.cornerRadius = cornerRadius
        
        scrollIndicatorInsets = UIEdgeInsets(top: cornerRadius, left: 0, bottom: cornerRadius, right: 0)
        textContainerInset = UIEdgeInsets(top: 4.0, left: 2.0, bottom: 4.0, right: 2.0)
        contentInset = UIEdgeInsets(top: 1.0, left: 0.0, bottom: 1.0, right: 0.0)
        
        isScrollEnabled = true
        scrollsToTop = false
        isUserInteractionEnabled = true
        
        font = UIFont.preferredFont(forTextStyle: .body)
        textColor = UIColor.black
        textAlignment = .natural
        
        contentMode = .redraw
        dataDetectorTypes = []
        keyboardAppearance = .default
        keyboardType = .default
        returnKeyType = .default
        
        text = nil
        placeHolder = nil
        placeHolderTextColor = UIColor.lightGray
        
        associateConstraints()
        registerObservers()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        let size = sizeThatFits(frame.size)
        var height = size.height
        
        if maxHeightConstraint != nil {
            height = min(height, maxHeightConstraint!.constant)
        }
        
        if minHeightConstraint != nil {
            height = max(height, minHeightConstraint!.constant)
        }
        
        heightConstraint?.constant = height        
        
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if text.lengthOfBytes(using: .utf8) == 0 && placeHolder != nil {
            placeHolderTextColor?.set()
            NSString(string: placeHolder!).draw(in: rect.insetBy(dx: 7.0, dy: 5.0),
                                                withAttributes: placeHolderTextAttributes)
        }
    }
    
    
    
    private var placeHolderTextAttributes: [String: Any]? {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.alignment = textAlignment
        
        return [
            NSFontAttributeName: font ?? UIFont.preferredFont(forTextStyle: .body),
            NSForegroundColorAttributeName: placeHolderTextColor ?? UIColor.lightGray,
            NSParagraphStyleAttributeName: paragraphStyle
        ]
    }
    
    
    private func associateConstraints() {
        
        constraints.forEach { constraint in
            if constraint.firstAttribute == .height {
                
                switch constraint.relation {
                case .equal:
                    heightConstraint = constraint
                    
                case .lessThanOrEqual:
                    maxHeightConstraint = constraint
                    
                case .greaterThanOrEqual:
                    minHeightConstraint = constraint
                }
            }
        }
    }
    
    private func registerObservers() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didReceiveTextViewNotification(_:)),
                                               name: Notification.Name.UITextViewTextDidChange,
                                               object: self)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didReceiveTextViewNotification(_:)),
                                               name: Notification.Name.UITextViewTextDidBeginEditing,
                                               object: self)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didReceiveTextViewNotification(_:)),
                                               name: Notification.Name.UITextViewTextDidEndEditing,
                                               object: self)
        
    }
    
    @objc private func didReceiveTextViewNotification(_ notification: Notification) {
        setNeedsDisplay()
    }
    

}

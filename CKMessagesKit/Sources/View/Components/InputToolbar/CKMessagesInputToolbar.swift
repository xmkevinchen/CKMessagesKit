//
//  CKMessagesInputToolbar.swift
//  CKMessagesKit
//
//  Created by Kevin Chen on 8/30/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import UIKit

public protocol CKMessagesInputToolbarDelegate: UIToolbarDelegate {
    
    func toolbar(_ toolbar: CKMessagesInputToolbar, didClickLeftBarButton sender: UIButton)
    func toolbar(_ toolbar: CKMessagesInputToolbar, didClickRightBarButton sender: UIButton)
    
}

public class CKMessagesInputToolbar: UIToolbar {
    
    public enum SendButtonPosition {
        case left
        case right
    }
    
    public var preferredDefaultHeight: CGFloat = 44.0 {
        willSet {
            assert(newValue > 0)
        }
    }
    public var maximumHeight = CGFloat.greatestFiniteMagnitude
    public var enableSendButtonAutomatically: Bool = true {
        didSet {
            updateSendButtonEnabledState()
        }
    }
    public var sendButtonPosition: SendButtonPosition = .right {
        
        didSet {
            
        }
    }
            
    public private(set) var contentView: CKMessagesToolbarContentView!
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView = CKMessagesToolbarContentView.viewFromNib()
        contentView.frame = frame
        addSubview(contentView)
        pinSubview(contentView)
        setNeedsUpdateConstraints()
        
        contentView.leftBarButtonItemDidUpdateHandler = { button in
            
            if let button = button {
                button.addTarget(self, action: #selector(self.leftBarButtonClicked(_:)), for: .touchUpInside)
            }
        }
        
        contentView.rightBarButtonItemDidUpdateHandler = { button in
            
            if let button = button {
                button.addTarget(self, action: #selector(self.rightBarButtonClicked(_:)), for: .touchUpInside)
            }
        }
        
        let factory = CKMessagesToolbarButtonFactory()
        
        contentView.leftBarButtonItem = factory.accessoryButton
        contentView.rightBarButtonItem = factory.sendButton
        
        updateSendButtonEnabledState()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textViewDidChange(_:)),
                                               name: Notification.Name.UITextViewTextDidChange,
                                               object: contentView.textView)
                
    }
    
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        
    }
        
    
    @objc private func leftBarButtonClicked(_ sender: UIButton) {
        (delegate as? CKMessagesInputToolbarDelegate)?.toolbar(self, didClickLeftBarButton: sender)
    }
    
    @objc private func rightBarButtonClicked(_ sender: UIButton) {
        (delegate as? CKMessagesInputToolbarDelegate)?.toolbar(self, didClickRightBarButton: sender)
    }
    
    @objc private func textViewDidChange(_ notification: Notification) {
        updateSendButtonEnabledState()
    }
    
    
    private func updateSendButtonEnabledState() {
        guard enableSendButtonAutomatically else {
            return
        }
        
        let hasText = contentView.textView.hasText
        switch sendButtonPosition {
        case .left:
            contentView.leftBarButtonItem?.isEnabled = hasText
        case .right:
            contentView.rightBarButtonItem?.isEnabled = hasText
        }
        
    }
    
}


public final class CKMessagesToolbarButtonFactory {
    
    private let font: UIFont
    
    public init(font: UIFont) {
        self.font = font
    }
    
    convenience init() {
        self.init(font: UIFont.preferredFont(forTextStyle: .headline))
    }
    
    public var accessoryButton: UIButton {
        let accessory = UIImage.accessory
        let normal = accessory.with(mask: UIColor.lightGray)
        let highlighted = accessory.with(mask: UIColor.darkGray)
        let accessoryButton = UIButton(frame: CGRect(x: 0, y: 0, width: accessory.size.width, height: 32.0))
        accessoryButton.setImage(normal, for: .normal)
        accessoryButton.setImage(highlighted, for: .highlighted)
        
        accessoryButton.contentMode = .scaleAspectFit
        accessoryButton.backgroundColor = UIColor.clear
        accessoryButton.tintColor = UIColor.lightGray
        accessoryButton.titleLabel?.font = font
        
        
        return accessoryButton
    }
    
    public var sendButton: UIButton {
        
        let title = "Send"
        
        let button = UIButton(frame: .zero)
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.messageBubbleBlue, for: .normal)
        button.setTitleColor(UIColor.messageBubbleBlue.darken(with: 0.1), for: .highlighted)
        button.setTitleColor(UIColor.lightGray, for: .disabled)
        
        button.titleLabel?.font = font
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.minimumScaleFactor = 0.85
        button.backgroundColor = UIColor.clear
        button.tintColor = UIColor.messageBubbleBlue
        
        let height: CGFloat = 32.0
        
        let titleSize = NSString(string: title).boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: height),
                                                             options: [.usesLineFragmentOrigin, .usesFontLeading],
                                                             attributes: [NSFontAttributeName: font],
                                                             context: nil).integral.size
        button.frame = CGRect(origin: .zero, size: titleSize)
        
        return button
        
    }
    
}

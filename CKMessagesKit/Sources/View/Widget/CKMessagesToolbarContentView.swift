//
//  CKMessagesToolbarContentView.swift
//  CKMessagesKit
//
//  Created by Kevin Chen on 8/30/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import UIKit
import Reusable

public class CKMessagesToolbarContentView: UIView {

    @IBOutlet weak var leftContainerView: UIView!
    @IBOutlet weak var rightContainerView: UIView!
    @IBOutlet weak var textView: CKMessagesComposerTextView!

    let defaultHorizontalSpacing: CGFloat = 8.0
    
    @IBOutlet weak var leftHorizontalSpacingConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightHorizontalSpacingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var leftContainerWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightContainerWidthConstraint: NSLayoutConstraint!
    
    
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        translatesAutoresizingMaskIntoConstraints = false
        
        leftHorizontalSpacingConstraint.constant = defaultHorizontalSpacing
        rightHorizontalSpacingConstraint.constant = defaultHorizontalSpacing
        
        backgroundColor = UIColor.clear
    }
    
    override public var backgroundColor: UIColor? {
        didSet {
            
            if leftContainerView != nil {
                leftContainerView.backgroundColor = backgroundColor
            }
            
            if rightContainerView != nil {
                rightContainerView.backgroundColor = backgroundColor
            }
        }
    }
    
    override public func setNeedsDisplay() {
        super.setNeedsDisplay()
        if textView != nil {
            textView.setNeedsDisplay()
        }
    }
    
    // MARK: - Getter & Setter
    
    public var leftViewWidth: CGFloat {
        get {
            return leftContainerWidthConstraint.constant
        }
        
        set {
            leftContainerWidthConstraint.constant = newValue
            setNeedsUpdateConstraints()
        }
    }
    
    public var rightViewWidth: CGFloat {
        get {
            return rightContainerWidthConstraint.constant
        }
        
        set {
            rightContainerWidthConstraint.constant = newValue
            setNeedsUpdateConstraints()
        }
    }
    
    public var leftPadding: CGFloat {
        return leftHorizontalSpacingConstraint.constant
    }
    
    public var rightPadding: CGFloat {
        return rightContainerWidthConstraint.constant
    }
    
    
    public var leftView: UIView? {
        
        willSet {
            if leftView != nil {
                leftView?.removeFromSuperview()
            }
        }
        
        didSet {
            guard let view = leftView else {
                leftHorizontalSpacingConstraint.constant = 0.0
                leftContainerView.isHidden = true
                leftViewWidth = 0.0
                return
            }
            
            if view.frame == .zero {
                view.frame = leftContainerView.bounds
            }
            
            leftContainerView.isHidden = false
            leftHorizontalSpacingConstraint.constant = defaultHorizontalSpacing
            leftViewWidth = view.frame.width
            
            view.translatesAutoresizingMaskIntoConstraints = false
            leftContainerView.addSubview(view)
            leftContainerView.pinSubview(view)
            setNeedsUpdateConstraints()
        }
    }
    
    public var rightView: UIView? {
        
        willSet {
            if rightView != nil {
                rightView?.removeFromSuperview()
            }
        }
        
        didSet {
            guard let view = rightView else {
                rightHorizontalSpacingConstraint.constant = 0.0
                rightContainerView.isHidden = true
                rightViewWidth = 0.0
                return
            }
            
            if view.frame == .zero {
                view.frame = rightContainerView.bounds
            }
            
            rightContainerView.isHidden = false
            rightHorizontalSpacingConstraint.constant = defaultHorizontalSpacing
            rightViewWidth = view.frame.width
            
            view.translatesAutoresizingMaskIntoConstraints = false
            rightContainerView.addSubview(view)
            rightContainerView.pinSubview(view)
            setNeedsUpdateConstraints()
        }
        
    }
    
}

extension CKMessagesToolbarContentView: NibLoadable {}

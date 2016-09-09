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
    
    var leftBarButtonItemDidUpdateHandler: ((UIButton?) -> Void)?
    var rightBarButtonItemDidUpdateHandler: ((UIButton?) -> Void)?
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        translatesAutoresizingMaskIntoConstraints = false
        
        leftHorizontalSpacingConstraint.constant = defaultHorizontalSpacing
        rightHorizontalSpacingConstraint.constant = defaultHorizontalSpacing
        
        backgroundColor = UIColor.clear
    }
    
    override public func setNeedsDisplay() {
        super.setNeedsDisplay()
        if textView != nil {
            textView.setNeedsDisplay()
        }
    }
    
    // MARK: - Getter & Setter
    
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
    
    public var leftBarItemWidth: CGFloat {
        get {
            return leftContainerWidthConstraint.constant
        }
        
        set {
            leftContainerWidthConstraint.constant = newValue
            setNeedsUpdateConstraints()
        }
    }
    
    public var rightBarItemWidth: CGFloat {
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
    
    
    public var leftBarButtonItem: UIButton? {
        
        willSet {
            if leftBarButtonItem != nil {
                leftBarButtonItem?.removeFromSuperview()
            }
        }
        
        didSet {
            
            defer {
                leftBarButtonItemDidUpdateHandler?(leftBarButtonItem)
            }
            
            guard let item = leftBarButtonItem else {
                leftHorizontalSpacingConstraint.constant = 0.0
                leftContainerView.isHidden = true
                leftBarItemWidth = 0.0
                return
            }
            
            if item.frame == .zero {
                item.frame = leftContainerView.bounds
            }
            
            leftContainerView.isHidden = false
            leftHorizontalSpacingConstraint.constant = defaultHorizontalSpacing
            leftBarItemWidth = item.frame.width
            
            item.translatesAutoresizingMaskIntoConstraints = false
            leftContainerView.addSubview(item)
            leftContainerView.pinSubview(item)
            setNeedsUpdateConstraints()
            
            
        }
    }
    
    public var rightBarButtonItem: UIButton? {
        
        willSet {
            if rightBarButtonItem != nil {
                rightBarButtonItem?.removeFromSuperview()
            }
        }
        
        didSet {
            
            defer {
                rightBarButtonItemDidUpdateHandler?(rightBarButtonItem)
            }
            
            guard let item = rightBarButtonItem else {
                rightHorizontalSpacingConstraint.constant = 0.0
                rightContainerView.isHidden = true
                rightBarItemWidth = 0.0
                return
            }
            
            if item.frame == .zero {
                item.frame = rightContainerView.bounds
            }
            
            rightContainerView.isHidden = false
            rightHorizontalSpacingConstraint.constant = defaultHorizontalSpacing
            rightBarItemWidth = item.frame.width
            
            item.translatesAutoresizingMaskIntoConstraints = false
            rightContainerView.addSubview(item)
            rightContainerView.pinSubview(item)
            setNeedsUpdateConstraints()
        }
        
    }
    
}

extension CKMessagesToolbarContentView: NibLoadable {}

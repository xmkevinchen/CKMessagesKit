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
    @IBOutlet weak var composerContainerView: UIView!
    
    @IBOutlet var textView: CKMessagesComposerTextView!

    let DefaultHorizontalSpacing: CGFloat = 8.0
    
    private let BarItemHeight: CGFloat = 32.0
    
    @IBOutlet weak var leftHorizontalSpacingConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightHorizontalSpacingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var leftContainerWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightContainerWidthConstraint: NSLayoutConstraint!
    
    var leftBarButtonItemDidUpdateHandler: ((UIButton?) -> Void)?
    var rightBarButtonItemDidUpdateHandler: ((UIButton?) -> Void)?
    
    public weak var leftBarItem: CKMessagesInputToolbarItem? = nil {
        didSet {
            if leftBarItem == nil {
                layout(barItems: nil, in: leftContainerView)
            } else {
                layout(barItems: [leftBarItem!], in: leftContainerView)
            }
        }
    }
    
    
    public var leftBarItems: [CKMessagesInputToolbarItem]? = nil {
        didSet {
            layout(barItems: leftBarItems, in: leftContainerView)
        }
    }
    
    public weak var rightBarItem: CKMessagesInputToolbarItem? = nil {
        didSet {
            if rightBarItem == nil {
                layout(barItems: nil, in: rightContainerView)
            } else {
                layout(barItems: [rightBarItem!], in: rightContainerView)
            }
        }

    }
    
    
    public var rightBarItems: [CKMessagesInputToolbarItem]? = nil {
        didSet {
            layout(barItems: rightBarItems, in: rightContainerView)
        }
    }

    // MARK: - Bar Items
    
    private func layout(barItems: [CKMessagesInputToolbarItem]?, in container: UIView) {
        
        container.subviews.forEach { $0.removeFromSuperview() }
        
        if let barItems = barItems {
            
            var width: CGFloat = 0.0
            var previous: Any?
            
            for item in barItems {
                
                let size = item.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: BarItemHeight))
                width += size.width
                
                container.addSubview(item)
                item.translatesAutoresizingMaskIntoConstraints = false
                
                
                item.addConstraint(NSLayoutConstraint(item: item, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: size.width))
                item.addConstraint(NSLayoutConstraint(item: item, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: BarItemHeight))
                container.addConstraint(NSLayoutConstraint(item: item, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0))
                container.addConstraint(NSLayoutConstraint(item: item, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0))
                
                if let previous = previous {
                    container.addConstraint(NSLayoutConstraint(item: item, attribute: .leading, relatedBy: .equal, toItem: previous, attribute: .trailing, multiplier: 1.0, constant: DefaultHorizontalSpacing))
                    width += DefaultHorizontalSpacing
                    
                } else {
                    container.addConstraint(NSLayoutConstraint(item: item, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0))
                }
                
                                                
                if barItems.index(of: item) == barItems.endIndex - 1 {
                    container.addConstraint(NSLayoutConstraint(item: item, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0))
                } else {
                    width += DefaultHorizontalSpacing
                }
                
                previous = item
            }
            
            
            if container === leftContainerView {
                leftHorizontalSpacingConstraint.constant = DefaultHorizontalSpacing
                leftContainerWidthConstraint.constant = width
            } else if container === rightContainerView {
                rightHorizontalSpacingConstraint.constant = DefaultHorizontalSpacing
                rightContainerWidthConstraint.constant = width
            }
            
        } else {
            
            
            
            if container === leftContainerView {
                leftHorizontalSpacingConstraint.constant = 0
                leftContainerWidthConstraint.constant = 0
            } else if container === rightContainerView {
                rightHorizontalSpacingConstraint.constant = 0
                rightContainerWidthConstraint.constant = 0
                
            }
        }
        
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        translatesAutoresizingMaskIntoConstraints = false
        
        
        leftBarItem = nil
        rightBarItem = nil
        
        backgroundColor = UIColor.clear
    }
    
    deinit {
        textView = nil
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
            
            if composerContainerView != nil {
                composerContainerView.backgroundColor = backgroundColor
            }
        }
    }
    
    public var leftPadding: CGFloat {
        return leftHorizontalSpacingConstraint.constant
    }
    
    public var rightPadding: CGFloat {
        return rightContainerWidthConstraint.constant
    }
    
    
}

extension CKMessagesToolbarContentView: NibLoadable {}

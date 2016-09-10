//
//  CKMessagePresenting.swift
//  CKMessagesViewController
//
//  Created by Kevin Chen on 8/24/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//



public protocol CKMessagePresenting {
                            
    var messageView: UIView { get }
    var messageType: CKMessageData.Type { get }        
    var message: CKMessageData? { get set }
    
    static func presentor() -> CKMessagePresenting
    func renderPresenting(with message: CKMessageData)
    
    
    
}


public extension CKMessagePresenting where Self: UIViewController {
    
    var messageView: UIView {
        replaceLayoutGuide()
        return view
    }
    
    func replaceLayoutGuide() {
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let removingConstraints = view.constraints.filter {
                return ($0.firstItem is UILayoutSupport && $0.secondItem != nil)
                    || ($0.secondItem is UILayoutSupport)
            }
        
        let replacingConstraints = removingConstraints.filter {
                return ($0.firstItem is UILayoutSupport && $0.secondItem as? UIView != view)
                    || ($0.firstItem as? UIView != view && $0.secondItem is UILayoutSupport)
            }
            .flatMap { constraint -> NSLayoutConstraint in
            
            if constraint.firstItem is UILayoutSupport {
                return NSLayoutConstraint(item: view,
                                          attribute: constraint.secondAttribute,
                                          relatedBy: constraint.relation,
                                          toItem: constraint.secondItem,
                                          attribute: constraint.secondAttribute,
                                          multiplier: constraint.multiplier,
                                          constant: constraint.constant)
            } else {
                
                return NSLayoutConstraint(item: constraint.firstItem,
                                          attribute: constraint.firstAttribute,
                                          relatedBy: constraint.relation,
                                          toItem: view,
                                          attribute: constraint.firstAttribute,
                                          multiplier: constraint.multiplier,
                                          constant: constraint.constant)
            }
            
            
            
            
        }
        
        view.removeConstraints(removingConstraints)
        view.addConstraints(replacingConstraints)

        view.subviews.filter { $0 is UILayoutSupport }
            .forEach { $0.removeFromSuperview() }
    }
    
}

public extension CKMessagePresenting where Self: UIViewController {
    
    var messagesViewController: CKMessagesViewController? {
                
        var parentVC: UIViewController? = parent
        
        while parentVC != nil && !(parentVC! is CKMessagesViewController) {
            parentVC = parentVC?.parent
        }
        
        return parentVC as? CKMessagesViewController
    }
    
}


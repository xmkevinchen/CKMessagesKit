//
//  CKMessageImageDataPresentor.swift
//  CKMessagesKit
//
//  Created by Kevin Chen on 9/19/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import UIKit

open class CKMessageImageDataPresentor: UIViewController, CKMessagePresentor {
    
    @IBOutlet public weak var imageView: UIImageView!
    @IBOutlet public weak var spinner: UIActivityIndicatorView!
    
    public var placeholderImage: UIImage = .placeholder
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let message = message {
            update(with: message)
        }
    }
    
            
    /// MARK: - CKMessagePresentor
    
    public var message: CKMessageData? {
        didSet {
            
            guard imageView != nil else {
                return
            }
            
            if let message = message as? CKMessageImageData {
                
                spinner.startAnimating()
                spinner.isHidden = false
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.imageView.image = message.image != nil ? message.image : self.placeholderImage
                    self.spinner.stopAnimating()
                    self.spinner.isHidden = true
                    
                }
                
            
            } else {
                imageView.image = nil
            }
        }
    }
    
    public var messageView: UIView {
        return view
    }
    
    public func update(with message: CKMessageData) {
        
        if let message = message as? CKMessageImageData {
            self.message = message
        }
        
        imageView.setNeedsDisplay()
        
    }
    
    public func prepareForReuse() {
        imageView.image = nil
        spinner.stopAnimating()
        spinner.isHidden = true
    }
    
    public static func presentor() -> CKMessagePresentor {
        return CKMessageImageDataPresentor(nibName: String(describing: CKMessageImageDataPresentor.self),
                                           bundle: Bundle(for: CKMessageImageDataPresentor.self))
    }
    
    
}


extension CKMessageImageDataPresentor: CKMessageSizablePresentor {
    
    public func size(of trait: UITraitCollection) -> CGSize {
        
        var size: CGSize
        switch (trait.horizontalSizeClass, trait.verticalSizeClass) {
            
        case (.compact, .regular):
            size = CGSize(width: 240, height: 135)
            
        default:
            size = CGSize(width: 320, height: 180)
            
        }
        
        return size
    }
    
}

extension CKMessageImageDataPresentor: CKMessageMaskablePresentor {
    public var isMessageBubbleHidden: Bool {
        return false
    }
}

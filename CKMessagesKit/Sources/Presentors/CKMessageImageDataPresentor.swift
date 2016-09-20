//
//  CKMessageImageDataPresentor.swift
//  CKMessagesKit
//
//  Created by Kevin Chen on 9/19/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import UIKit

class CKMessageImageDataPresentor: UIViewController, CKMessagePresentor {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
            
    /// MARK: - CKMessagePresentor
    
    var message: CKMessageData? {
        didSet {
            if let message = message {
                update(with: message)
            }
        }
    }
    
    var messageView: UIView {
        return view
    }
    
    func update(with message: CKMessageData) {
        
        if let message = message as? CKMessageImageData {
            self.message = message
        }
        
    }
    
    func prepareForReuse() {
        imageView.image = nil
        spinner.stopAnimating()
        spinner.isHidden = true
    }
    
    static func presentor() -> CKMessagePresentor {
        return CKMessageImageDataPresentor(nibName: String(describing: CKMessageImageDataPresentor.self),
                                           bundle: Bundle(for: CKMessageImageDataPresentor.self))
    }
    
    
}

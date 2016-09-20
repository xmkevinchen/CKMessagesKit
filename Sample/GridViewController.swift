//
//  GridViewController.swift
//  CKMessagesViewController
//
//  Created by Kevin Chen on 8/24/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import UIKit
import CKMessagesKit
import Reusable

struct GridMessage: CKMessageData, Hashable {
    
    public var senderId: String
    public var sender: String
    public var index: Int
    public var timestamp: Date
    
    public var hashValue: Int {
        return "GridMessage:\(senderId).\(index).\(timestamp)".hashValue
    }
    
    public init(senderId: String, sender: String, index: Int, timestamp: Date = Date()) {
        self.senderId = senderId
        self.sender = sender
        self.index = index
        self.timestamp = timestamp
    }
    
}


class GridViewController: UIViewController, CKMessageSizablePresentor, CKMessageEmbeddablePresentor, Reusable {
    
    
    public func size(of trait: UITraitCollection) -> CGSize {
        
        var size: CGSize
        switch (trait.horizontalSizeClass, trait.verticalSizeClass) {
            
        case (.compact, .regular):
            size = CGSize(width: 200, height: 60)
            
        default:
            size = CGSize(width: 320, height: 60)
            
        }
        
        return size
    }
    
    var insets: UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
    }
    
    public func prepareForReuse() {
        
    }

    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let message = self.message as? GridMessage {
            update(with: message)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    public var message: CKMessageData?
    public var messageView: UIView {
        return view
    }
    
    public static func presentor() -> CKMessagePresentor {
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController: GridViewController = storyboard.instantiate()
        return viewController
    }
    
    func update(with message: CKMessageData) {
        if let message = message as? GridMessage, let collectionView = collectionView {
            self.message = message
            collectionView.reloadData()
        }
    }
    
}



@IBDesignable
class GridCell: UICollectionViewCell {
    
    @IBOutlet weak var textLabel: UILabel!
    
    @IBInspectable var borderColor: UIColor? = nil {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
            layer.masksToBounds = borderWidth > 0
        }
    }
    
}

extension GridViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridCell", for: indexPath) as! GridCell
        
        if let message = message as? GridMessage {
            cell.textLabel.text = String(indexPath.item + message.index)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("====> didSelectItemAt: \(indexPath)")
        
        let alert = UIAlertController(title: "Clicked", message: "\(indexPath)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
}

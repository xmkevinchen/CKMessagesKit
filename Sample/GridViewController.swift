//
//  GridViewController.swift
//  CKMessagesViewController
//
//  Created by Kevin Chen on 8/24/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import UIKit
import CKMessagesViewController

final class GridViewController: UIViewController, CKMessagePresenting {
    
    public var messageType: CKMessageData.Type = CKTextMessage.self

    
    public static func presentor(with message: CKMessageData) -> CKMessagePresenting {
        let viewControlelr = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "GridViewController") as! GridViewController
        viewControlelr.message = message as? CKTextMessage
        return viewControlelr
    }

    

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        collectionView.reloadData()
    }
    
    
    var message: CKTextMessage?
    
    
    
    public func refresh(with message: CKMessageData) {
        self.message = message as? CKTextMessage
        collectionView.reloadData()
    }
    
    var messageView: UIView {
        return view
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
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridCell", for: indexPath) as! GridCell
        cell.textLabel.text = String(indexPath.item + Int(message!.message)!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("====> didSelectItemAt: \(indexPath)")
    }
    
}

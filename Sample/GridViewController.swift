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
    

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        collectionView.reloadData()
    }
    

    typealias Message = CKMessage
    var message: CKMessage?
    
    static func presentor(with message: Message) -> GridViewController {
        let viewControlelr = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "GridViewController") as! GridViewController
        viewControlelr.message = message
        return viewControlelr
    }
    
    
    func refresh(with message: CKMessage) {
        self.message = message
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
        cell.textLabel.text = String(indexPath.item + Int(message!.text)!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("====> didSelectItemAt: \(indexPath)")
    }
    
}

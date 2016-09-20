//
//  ListViewController.swift
//  CKMessagesViewController
//
//  Created by Chen Kevin on 8/29/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import UIKit
import CKMessagesKit
import Reusable

struct ListMessage: CKMessageData, Hashable {
    
    public var senderId: String
    public var sender: String
    public var text: String
    public var timestamp: Date
    
    public init(senderId: String, sender: String, text: String, timestamp: Date = Date()) {
        self.senderId = senderId
        self.sender = sender
        self.text = text
        self.timestamp = timestamp
    }
    
}

class ListViewController: UIViewController, CKMessagePresentor, Reusable {

    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let message = self.message {
            update(with: message)
        }
        
    }

    
    public var message: CKMessageData?
    
    public var messageView: UIView {
        replaceLayoutGuide()
        return view
    }
    
    public static func presentor() -> CKMessagePresentor {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController: ListViewController = storyboard.instantiate()
        return viewController
    }
    
    func update(with message: CKMessageData) {
        if let message = message as? ListMessage, let tableView = tableView {
            self.message = message
            tableView.reloadData()
        }
    }
    
    func prepareForReuse() {
        
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

extension ListViewController: CKMessageMaskablePresentor, CKMessageEmbeddablePresentor {
    
    public var isMessageBubbleHidden: Bool {
        return false
    }

    public func size(of trait: UITraitCollection) -> CGSize {
        return CGSize(width: 240, height: 180)
    }
    
    var insets: UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    }

}

extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let _ = message as? ListMessage {
            return 10
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if let message = message as? ListMessage {
            cell.textLabel?.text = String(Int(message.text)! + indexPath.row)
        }
        return cell
    }
}

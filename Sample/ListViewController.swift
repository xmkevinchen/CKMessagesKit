//
//  ListViewController.swift
//  CKMessagesViewController
//
//  Created by Chen Kevin on 8/29/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import UIKit
import CKMessagesViewController

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

class ListViewController: UIViewController, CKMessagePresenting, UITableViewDataSource, UITableViewDelegate {

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
            renderPresenting(with: message)
        }
        
    }

    
    public var message: CKMessageData?
    public var messageType: CKMessageData.Type = ListMessage.self
    
    public static func presentor() -> CKMessagePresenting {
        let viewControlelr = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ListViewController") as! ListViewController
        return viewControlelr
    }
    
    func renderPresenting(with message: CKMessageData) {
        if let message = message as? ListMessage, let tableView = tableView {
            self.message = message
            tableView.reloadData()
        }
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let _ = message as? ListMessage {
            return 5
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

//
//  RootViewController.swift
//  CKMessagesKit
//
//  Created by Chen Kevin on 9/13/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import UIKit
import Reusable

protocol SegueHandler {
    associatedtype SegueIdentifier: RawRepresentable
}

extension SegueHandler where Self: UIViewController, SegueIdentifier.RawValue == String {
    
    func performSegue(withIdentifier identifier: SegueIdentifier, sender: AnyObject?) {
        performSegue(withIdentifier: identifier.rawValue, sender: sender)
    }
    
    func segueIdentifier(for segue: UIStoryboardSegue) -> SegueIdentifier {
        guard let identifier = segue.identifier, let segueIdentifier = SegueIdentifier(rawValue: identifier) else {
            fatalError("Invalid segue identifier \(segue.identifier)")
        }
        
        return segueIdentifier
    }
    
}

class RootViewController: UIViewController, SegueHandler {
    
    enum SegueIdentifier: String {
        case PushSegue
        case PresentModalSegua
    }

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        title = "CKMessagesKit"
        tableView.delegate = self
        tableView.dataSource = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        switch segueIdentifier(for: segue) {
        case .PushSegue:
            navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
            
        case .PresentModalSegua:
            if let navController = segue.destination as? UINavigationController,
                let viewController = navController.viewControllers.first as? ViewController {
                viewController.isModel = true
            }
                        
        }
        
    }
        
    func dismiss(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
 
}


extension RootViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "PRESENTATION"
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var numberOfRows = 0
        
        switch section {
        case 0:
            numberOfRows = 2
        case 1:
            numberOfRows = 2
            
        default:
            break
        }
        
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CKMessagesKitCell", for: indexPath)
        
        var title: String?
        
        switch (indexPath.section, indexPath.row) {
            
        case (0, 0):
            title = "Push via Storyboard"
            
        case (0, 1):
            title = "Push programmatically"
            
        case (1, 0):
            title = "Present via Storyboard"
            
        case (1, 1):
            title = "Present programmatically"
            
        default: break
        }
        
        cell.textLabel?.text = title
        cell.accessoryType = .disclosureIndicator
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            performSegue(withIdentifier: .PushSegue, sender: nil)
            
        case (0, 1):
            let viewController = ViewController()
            navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
            navigationController?.pushViewController(viewController, animated: true)
            
            
        case (1, 0):
            performSegue(withIdentifier: .PresentModalSegua, sender: nil)
            
        case (1, 1):
            let viewController = ViewController()
            viewController.isModel = true
            let navController = UINavigationController(rootViewController: viewController)
            showDetailViewController(navController, sender: nil)
            
        default:
            break
        }
    }
    
    
}

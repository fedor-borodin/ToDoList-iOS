//
//  ViewController.swift
//  ToDoList
//
//  Created by Admin on 30/04/2017.
//  Copyright © 2017 fborodin. All rights reserved.
//

import UIKit

var itemsList = [Item]()

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    // get number of rows
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsList.count
    }
    
    // fill cells with data
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        
        if indexPath.row < itemsList.count {
            cell.textLabel?.text = itemsList[indexPath.row].title
            cell.accessoryType = itemsList[indexPath.row].status ? .checkmark : .none
        }
        
        return cell
    }
    
    // touch the cell to check/uncheck
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row < itemsList.count {
            itemsList[indexPath.row].status = !itemsList[indexPath.row].status
            
            tableView.reloadRows(at: [indexPath], with: .automatic)
            
            do {
                try itemsList.writeToPersistense()
            } catch let error {
                NSLog("Error writing to persistence: \(error)")
            }
        }
    }
    
    // swipe left to delete
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            itemsList.remove(at: indexPath.row)
            
            tableView.reloadData()
            
            do {
                try itemsList.writeToPersistense()
            } catch let error {
                NSLog("Error writing to persistence: \(error)")
            }
        }
    }
    
    // delete all Tasks
    @IBAction func deleteAllPressed(_ sender: UIBarButtonItem) {
        if itemsList.count > 0 {
            let dialogAction = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            let deleteAction = UIAlertAction(title: "Delete All", style: .destructive, handler: {(alertAction) -> Void in
                itemsList.removeAll()
                
                self.tableView.reloadData()
                
                do {
                    try itemsList.writeToPersistense()
                } catch let error {
                    NSLog("Error writing to persistence: \(error)")
                }
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            dialogAction.addAction(deleteAction)
            dialogAction.addAction(cancelAction)
            
            self.present(dialogAction, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        NotificationCenter.default.addObserver(self, selector: #selector(UIApplicationDelegate.applicationDidEnterBackground(_:)), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        
        do {
            itemsList = try [Item].readFromPersistence()
        } catch let error as NSError {
            if error.domain == NSCocoaErrorDomain && error.code == NSFileReadNoSuchFileError {
                NSLog("No persistence file found, not necessarily an error...")
            } else {
                let alert = UIAlertController(title: "Error", message: "Could not load to-do list", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                NSLog("Error loading from persistense: \(error)")
            }
        }
    }
    
    // when app goes to background
    @objc
    public func applicationDidEnterBackground(_ notification: NSNotification) {
        do {
            try itemsList.writeToPersistense()
        } catch let error {
            NSLog("Error writing to persistence: \(error)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // when the main view appears on the screen
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
}


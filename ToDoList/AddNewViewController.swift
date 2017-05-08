//
//  AddNewViewController.swift
//  ToDoList
//
//  Created by Admin on 30/04/2017.
//  Copyright © 2017 fborodin. All rights reserved.
//

import UIKit

class AddNewViewController : UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var addItemField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.addItemField.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func saveItem(_ sender: UIBarButtonItem) {
        if let itemText = addItemField.text {
            itemsList.append(Item(toDo: itemText))
            
            do {
                try itemsList.writeToPersistense()
            } catch let error {
                NSLog("Error writing to persistence: \(error)")
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelItem(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // if user finished typing in a task with Return button pressed on a keyboard, we also save
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let itemText = addItemField.text {
            itemsList.append(Item(toDo: itemText))
            
            do {
                try itemsList.writeToPersistense()
            } catch let error {
                NSLog("Error writing to persistence: \(error)")
            }
        }
        self.dismiss(animated: true, completion: nil)
        
        return true
    }
}

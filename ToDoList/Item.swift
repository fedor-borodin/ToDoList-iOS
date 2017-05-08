//
//  Item.swift
//  ToDoList
//
//  Created by Admin on 30/04/2017.
//  Copyright © 2017 fborodin. All rights reserved.
//

import Foundation

// class describing a ToDo List Item (a Task)
class Item : NSObject, NSCoding {
    var title: String                   // name of the task
    var status: Bool                    // status of the task
    
    public init(toDo title: String) {
        self.title = title
        self.status = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        if let title = aDecoder.decodeObject(forKey: "title") as? String {
            self.title = title
        } else {
            return nil
        }
        
        if aDecoder.containsValue(forKey: "status") {
            self.status = aDecoder.decodeBool(forKey: "status")
        } else {
            return nil
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.title, forKey: "title")
        aCoder.encode(self.status, forKey: "status")
    }
}

// extension of ToDo List Item class to work with a collection of Items (ex. [Item])
extension Collection where Iterator.Element == Item {
    private static func persistencePath() -> URL? {
        let url = try? FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        return url?.appendingPathComponent("items.bin")
    }
    
    func writeToPersistense() throws {
        if let url = Self.persistencePath(), let array = self as? NSArray {
            let data = NSKeyedArchiver.archivedData(withRootObject: array)
            try data.write(to: url)
        } else {
            throw NSError(domain: "com.borodin-home.fborodin.ToDoList", code: 10, userInfo: nil)
        }
    }
    
    static func readFromPersistence() throws -> [Item] {
        if let url = persistencePath(), let data = (try Data(contentsOf: url) as Data?) {
            if let array = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Item] {
                return array
            } else {
                throw NSError(domain: "com.borodin-home.fborodin.ToDoList", code: 11, userInfo: nil)
            }
        } else {
            throw NSError(domain: "com.borodin-home.fborodin.ToDoList", code: 12, userInfo: nil)
        }
    }
}

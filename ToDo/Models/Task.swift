//
//  Task.swift
//  ToDo
//
//  Created by Kryg Tomasz on 05.06.2018.
//  Copyright © 2018 Kryg Tomasz. All rights reserved.
//

import Foundation
import Firebase

class Task {
    
    let key: String
    let ref: DatabaseReference?
    var title: String = ""
    var addedByUser: String = ""
    var completed: Bool = false
    var completedByUser: String?
    
    init(title: String, addedByUser: String, completed: Bool, key: String = "") {
        self.title = title
        self.addedByUser = addedByUser
        self.completed = completed
        self.key = key
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        if let title = snapshotValue["title"] as? String {
            self.title = title
        }
        if let addedByUser = snapshotValue["addedByUser"] as? String {
            self.addedByUser = addedByUser
        }
        if let completed = snapshotValue["completed"] as? Bool {
            self.completed = completed
        }
        if let completedByUser = snapshotValue["completedByUser"] as? String {
            self.completedByUser = completedByUser
        }
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "title": title,
            "addedByUser": addedByUser,
            "completed": completed,
            "completedByUser": completedByUser
        ]
    }
    
}

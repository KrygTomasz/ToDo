//
//  TaskGroup.swift
//  ToDo
//
//  Created by Kryg Tomasz on 09.06.2018.
//  Copyright © 2018 Kryg Tomasz. All rights reserved.
//

import Foundation
import Firebase

class TaskGroup {
    
    let key: String
    let ref: DatabaseReference?
    var title: String = ""
    var addedByUser: String = ""
    var colorHex: String = "#FFFFFF"
    var tasks: [Task] = []
//    var completed: Bool = false
//    var completedByUser: String?
    
    init(title: String, addedByUser: String, colorHex: String, key: String = "") {
        self.title = title
        self.addedByUser = addedByUser
        self.colorHex = colorHex
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
        if let colorHex = snapshotValue["colorHex"] as? String {
            self.colorHex = colorHex
        }
        let tasksSnapshot = snapshot.childSnapshot(forPath: "tasks")
        for child in tasksSnapshot.children {
            guard let snapshot = child as? DataSnapshot else { continue }
            let task = Task(snapshot: snapshot)
            tasks.append(task)
        }
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "title": title,
            "addedByUser": addedByUser,
            "colorHex": colorHex
        ]
    }
    
}

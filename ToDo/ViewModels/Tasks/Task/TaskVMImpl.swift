//
//  TaskVMImpl.swift
//  ToDo
//
//  Created by Kryg Tomasz on 06.06.2018.
//  Copyright © 2018 Kryg Tomasz. All rights reserved.
//

import Foundation

class TaskVMImpl: TaskVM {
    var task: Task
    var title: String {
        get {
            return task.title
        }
    }
    var addedByUser: String {
        get {
            return "Dodano przez: \(task.addedByUser)"
        }
    }
    var completed: Bool {
        get {
            return task.completed
        }
    }
    var color: String
        
    init(task: Task, color: String) {
        self.task = task
        self.color = color
    }
}

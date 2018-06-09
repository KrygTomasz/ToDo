//
//  TaskGroupVM.swift
//  ToDo
//
//  Created by Kryg Tomasz on 09.06.2018.
//  Copyright © 2018 Kryg Tomasz. All rights reserved.
//

import Foundation

class TaskGroupVMImpl: TaskGroupVM {
    var taskGroup: TaskGroup
    var title: String {
        get {
            return taskGroup.title
        }
    }
    var addedByUser: String {
        get {
            return "Dodano przez: \(taskGroup.addedByUser)"
        }
    }
    var colorHex: String {
        get {
            return taskGroup.colorHex
        }
    }
    
    init(taskGroup: TaskGroup) {
        self.taskGroup = taskGroup
    }
}

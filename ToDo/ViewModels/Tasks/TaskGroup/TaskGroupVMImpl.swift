//
//  TaskGroupVM.swift
//  ToDo
//
//  Created by Kryg Tomasz on 09.06.2018.
//  Copyright © 2018 Kryg Tomasz. All rights reserved.
//

import Foundation
import Firebase

class TaskGroupVMImpl: TaskGroupVM {
    var taskGroup: TaskGroup
    var title: String {
        get {
            return taskGroup.title
        }
    }
    var addedByUser: String {
        get {
            return taskGroup.addedByUser
        }
    }
    var colorHex: String {
        get {
            return taskGroup.colorHex
        }
    }
    
    init(taskGroup: TaskGroup, taskGroupsRef: DatabaseReference?) {
        self.taskGroup = taskGroup
        self.tasksRef = taskGroupsRef?.child(taskGroup.title).child("tasks")
        taskGroup.tasks.forEach {
            task in
            taskVMs.append(TaskVMImpl(task: task, color: colorHex))
        }
    }
    
    var taskVMs: [TaskVM] = []
    private var tasksRef: DatabaseReference?

    func prepare(completion: EmptyCompletion? = nil) {
        tasksRef?.observe(.value) {
            snapshot in
            var taskVMArray: [TaskVM] = []
            for child in snapshot.children {
                guard let snapshot = child as? DataSnapshot else { continue }
                let task = Task(snapshot: snapshot)
                let taskVM = TaskVMImpl(task: task, color: self.colorHex)
                taskVMArray.append(taskVM)
            }
            self.taskVMs = taskVMArray
            completion?()
        }
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfItems() -> Int {
        return taskVMs.count
    }
    
    func addTask(withTitle title: String) {
        let task = Task(title: title, addedByUser: User.shared.username, completed: false)
        let taskRef = tasksRef?.child(task.title)
        taskRef?.setValue(task.toAnyObject())
    }
    
    func getTaskVM(byIndex index: Int) -> TaskVM? {
        return taskVMs[safe: index]
    }
    
}

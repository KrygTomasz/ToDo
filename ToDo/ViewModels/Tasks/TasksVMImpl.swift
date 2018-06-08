//
//  TasksVMImpl.swift
//  ToDo
//
//  Created by Kryg Tomasz on 06.06.2018.
//  Copyright © 2018 Kryg Tomasz. All rights reserved.
//

import Foundation
import Firebase

class TasksVMImpl: TasksVM {
    
    var taskVMs: [TaskVM] = []
    
    private var tasksRef: DatabaseReference?
    
    func prepare(completion: EmptyCompletion? = nil) {
        tasksRef = Database.database().reference(withPath: "tasks")//User.shared.id)
        tasksRef?.observe(.value) {
            snapshot in
            var taskVMArray: [TaskVM] = []
            for child in snapshot.children {
                guard let snapshot = child as? DataSnapshot else { continue }
                let task = Task(snapshot: snapshot)
                let taskVM = TaskVMImpl(task: task)
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
    
    func logout(completion: EmptyCompletion? = nil) {
        do {
            try Auth.auth().signOut()
            completion?()
        } catch {
            return
        }
    }

    
}

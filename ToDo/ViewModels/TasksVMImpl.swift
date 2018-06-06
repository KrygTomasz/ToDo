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
    weak var delegate: TasksVCDelegate?
    
    private let tasksRef = Database.database().reference(withPath: "tasks")
    
    init() {
        showIndicator()
        tasksRef.observe(.value) { snapshot in
            var taskVMArray: [TaskVM] = []
            for child in snapshot.children {
                guard let snapshot = child as? DataSnapshot else { continue }
                let task = Task(snapshot: snapshot)
                let taskVM = TaskVMImpl(task: task)
                taskVMArray.append(taskVM)
            }
            self.taskVMs = taskVMArray
            self.hideIndicator()
            self.refreshView()
        }
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfItems() -> Int {
        return taskVMs.count
    }
    
    func showIndicator() {
        delegate?.showIndicator()
    }
    
    func hideIndicator() {
        delegate?.hideIndicator()
    }
    
    func refreshView() {
        delegate?.reloadCollectionView()
    }
    
    func addTask(withTitle title: String) {
        let task = Task(title: title, addedByUser: "Temporary", completed: false)
        let taskRef = tasksRef.child(task.title)
        taskRef.setValue(task.toAnyObject())
    }
    
    func getTaskVM(byIndex index: Int) -> TaskVM? {
        return taskVMs[safe: index]
    }
    
}

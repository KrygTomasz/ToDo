//
//  TaskGroupsVMImpl.swift
//  ToDo
//
//  Created by Kryg Tomasz on 09.06.2018.
//  Copyright © 2018 Kryg Tomasz. All rights reserved.
//

import Foundation
import Firebase

class TaskGroupsVMImpl: TaskGroupsVM {
    
    var taskGroupVMs: [TaskGroupVM] = []
    private var taskGroupsRef: DatabaseReference?
    
    var isUserLogged: Bool {
        get {
            return User.shared.isLogged
        }
    }

    func prepare(completion: EmptyCompletion? = nil) {
        taskGroupsRef = Database.database().reference(withPath: "groupTasks")//User.shared.id)
        taskGroupsRef?.observe(.value) {
            snapshot in
            var taskGroupVMArray: [TaskGroupVM] = []
            for child in snapshot.children {
                guard let snapshot = child as? DataSnapshot else { continue }
                let taskGroup = TaskGroup(snapshot: snapshot)
                let taskGroupVM = TaskGroupVMImpl(taskGroup: taskGroup, taskGroupsRef: self.taskGroupsRef)
                taskGroupVMArray.append(taskGroupVM)
            }
            self.taskGroupVMs = taskGroupVMArray
            completion?()
        }
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfItems() -> Int {
        return taskGroupVMs.count
    }
    
    func addTaskGroup(withTitle title: String) {
        let taskGroup = TaskGroup(title: title, addedByUser: User.shared.username, colorHex: "#13F41D")
        let taskGroupRef = taskGroupsRef?.child(taskGroup.title)
        taskGroupRef?.setValue(taskGroup.toAnyObject())
    }
    
    func getTaskGroupVM(byIndex index: Int) -> TaskGroupVM? {
        return taskGroupVMs[safe: index]
    }
    
    func logout(completion: EmptyCompletion? = nil) {
        do {
            try Auth.auth().signOut()
            User.shared.reset()
            completion?()
        } catch {
            return
        }
    }
    
}

//
//  TaskGroupVM.swift
//  ToDo
//
//  Created by Kryg Tomasz on 09.06.2018.
//  Copyright © 2018 Kryg Tomasz. All rights reserved.
//

import Foundation

protocol TaskGroupVM {
    var taskGroup: TaskGroup {get set}
    var title: String {get}
    var addedByUser: String {get}
    var colorHex: String {get}
    var taskCompletion: String {get}
    
    func prepare(completion: EmptyCompletion?)
    func numberOfSections() -> Int
    func numberOfItems() -> Int
    func addTask(withTitle title: String)
    func getTaskVM(byIndex index: Int) -> TaskVM?
}

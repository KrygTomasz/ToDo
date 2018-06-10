//
//  TaskGroupsVM.swift
//  ToDo
//
//  Created by Kryg Tomasz on 09.06.2018.
//  Copyright © 2018 Kryg Tomasz. All rights reserved.
//

import Foundation

typealias EmptyCompletion = (() -> Void)

protocol TaskGroupsVM {
    func prepare(completion: EmptyCompletion?)
    func numberOfSections() -> Int
    func numberOfItems() -> Int
    func addTaskGroup(withTitle title: String)
    func getTaskGroupVM(byIndex index: Int) -> TaskGroupVM?
    func logout(completion: EmptyCompletion?)
}

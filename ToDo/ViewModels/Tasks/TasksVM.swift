//
//  TasksVM.swift
//  ToDo
//
//  Created by Kryg Tomasz on 06.06.2018.
//  Copyright © 2018 Kryg Tomasz. All rights reserved.
//

import Foundation

typealias EmptyCompletion = (() -> Void)

protocol TasksVM {
    func prepare(completion: EmptyCompletion?)
    func numberOfSections() -> Int
    func numberOfItems() -> Int
    func addTask(withTitle title: String)
    func getTaskVM(byIndex index: Int) -> TaskVM?
}

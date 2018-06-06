//
//  TasksVM.swift
//  ToDo
//
//  Created by Kryg Tomasz on 06.06.2018.
//  Copyright © 2018 Kryg Tomasz. All rights reserved.
//

import Foundation

protocol TasksVM {
    var delegate: TasksVCDelegate? {get set}
    func numberOfSections() -> Int
    func numberOfItems() -> Int
    func showIndicator()
    func hideIndicator()
    func refreshView()
    func addTask(withTitle title: String)
    func getTaskVM(byIndex index: Int) -> TaskVM?
}

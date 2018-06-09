//
//  TaskVM.swift
//  ToDo
//
//  Created by Kryg Tomasz on 06.06.2018.
//  Copyright © 2018 Kryg Tomasz. All rights reserved.
//

import Foundation

protocol TaskVM {
    var task: Task {get set}
    var title: String {get}
    var addedByUser: String {get}
    var completed: Bool {get}
}

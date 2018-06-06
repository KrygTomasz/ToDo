//
//  LoginVM.swift
//  ToDo
//
//  Created by Kryg Tomasz on 06.06.2018.
//  Copyright © 2018 Kryg Tomasz. All rights reserved.
//

import Foundation

typealias LoginVMInput = (email: String, password: String)

protocol LoginVM {
    var delegate: LoginVCDelegate? {get set}
    func logIn(withCredentials credentials: LoginVMInput)
    func tryToAutoLogIn()
}

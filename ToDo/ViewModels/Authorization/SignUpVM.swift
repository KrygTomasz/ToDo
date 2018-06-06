//
//  SignUpVM.swift
//  ToDo
//
//  Created by Kryg Tomasz on 06.06.2018.
//  Copyright © 2018 Kryg Tomasz. All rights reserved.
//

import Foundation

typealias SignUpVMInput = (email: String, password: String, username: String)

protocol SignUpVM {
    var delegate: Hideable? {get set}
    func signUp(withCredentials credentials: SignUpVMInput)}

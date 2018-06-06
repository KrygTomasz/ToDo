//
//  SignUpVMImpl.swift
//  ToDo
//
//  Created by Kryg Tomasz on 06.06.2018.
//  Copyright © 2018 Kryg Tomasz. All rights reserved.
//

import Foundation
import Firebase

class SignUpVMImpl: SignUpVM {
    
    weak var delegate: Hideable?
    
    func signUp(withCredentials credentials: SignUpVMInput) {
        Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) {
            user, error in
            print(error?.localizedDescription)
            if error == nil {
                User.shared.update(email: credentials.email, password: credentials.password, username: credentials.username)
                let usersRef = Database.database().reference(withPath: "users")
                let userRef = usersRef.child(User.shared.id)
                userRef.setValue(["username": User.shared.username])
                self.delegate?.hide()
            }
        }
    }
    
}

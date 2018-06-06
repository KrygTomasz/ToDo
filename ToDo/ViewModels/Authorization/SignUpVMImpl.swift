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
    
    weak var delegate: SignUpVCDelegate?
    
    func signUp(withCredentials credentials: SignUpVMInput) {
        delegate?.showIndicator(description: "Rejestracja...")
        Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) {
            user, error in
            if error == nil {
                User.shared.update(email: credentials.email, password: credentials.password, username: credentials.username)
                let usersRef = Database.database().reference(withPath: "users")
                let userRef = usersRef.child(User.shared.id)
                userRef.setValue(["username": User.shared.username])
                self.delegate?.hideIndicator(withSuccess: true, description: "Konto zostało utworzone") {
                    self.delegate?.hideVC()
                }
                return
            }
            let errorMessage = error?.localizedDescription ?? "Błąd"
            print(errorMessage)
            self.delegate?.hideIndicator(withSuccess: false, description: errorMessage, completion: nil)
        }
    }
    
}

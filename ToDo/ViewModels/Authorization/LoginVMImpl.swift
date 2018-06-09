//
//  LoginVMImpl.swift
//  ToDo
//
//  Created by Kryg Tomasz on 06.06.2018.
//  Copyright © 2018 Kryg Tomasz. All rights reserved.
//

import Foundation
import Firebase

class LoginVMImpl: LoginVM {
    
    weak var delegate: LoginVCDelegate?
    
    func logIn(withCredentials credentials: LoginVMInput) {
        delegate?.showIndicator(description: "Logowanie...")
        Auth.auth().signIn(withEmail: credentials.email, password: credentials.password) {
            user, error in
            if error == nil {
                self.delegate?.hideIndicator(withSuccess: true, description: "Zalogowano", completion: nil)
                User.shared.update(email: credentials.email, password: credentials.password)
                self.observeUsername()
                self.delegate?.hideVC()
                return
            }
            let errorMessage = error?.localizedDescription ?? "Błąd"
            print(errorMessage)
            self.delegate?.hideIndicator(withSuccess: false, description: errorMessage, completion: nil)
        }
    }
    
    func tryToAutoLogIn() {
        let email = User.shared.email
        let password = User.shared.password
        if !email.isEmpty && !password.isEmpty {
            logIn(withCredentials: (email, password))
        }
    }
    
    private func observeUsername() {
        let userRef = Database.database().reference(withPath: "users").child(User.shared.id)
        userRef.observe(.value, with: {
            snapshot in
            guard
                let userJSON = snapshot.value as? [String: Any],
                let username = userJSON["username"] as? String
            else { return }
            User.shared.update(email: User.shared.email, password: User.shared.password, username: username)
        })
    }
    
}

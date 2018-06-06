//
//  SignUpVC.swift
//  ToDo
//
//  Created by Kryg Tomasz on 06.06.2018.
//  Copyright © 2018 Kryg Tomasz. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController {

    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton! {
        didSet {
            signUpButton.addTarget(self, action: #selector(onSignUpButtonClicked), for: .touchUpInside)
        }
    }
    
    var signUpVM: SignUpVM = SignUpVMImpl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpVM.delegate = self
    }
    
    @objc func onSignUpButtonClicked() {
        let login = loginTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let username = usernameTextField.text ?? ""
        signUpVM.signUp(withCredentials: (login, password, username))
    }

}

extension SignUpVC: Hideable {
    
    func hide() {
        self.navigationController?.popViewController(animated: true)
    }
    
}

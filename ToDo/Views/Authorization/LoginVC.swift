//
//  LoginVC.swift
//  ToDo
//
//  Created by Kryg Tomasz on 06.06.2018.
//  Copyright © 2018 Kryg Tomasz. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var loginTextField: UITextField! {
        didSet {
            loginTextField.text = User.shared.email
        }
    }
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            passwordTextField.text = User.shared.password
        }
    }
    @IBOutlet weak var loginButton: UIButton! {
        didSet {
            loginButton.addTarget(self, action: #selector(onLoginButtonClicked), for: .touchUpInside)
        }
    }
    @IBOutlet weak var signUpButton: UIButton! {
        didSet {
            signUpButton.addTarget(self, action: #selector(onSignUpButtonClicked), for: .touchUpInside)
        }
    }
    
    weak var delegate: ReloadViewDelegate?
    var loginVM: LoginVM = LoginVMImpl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginVM.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loginVM.tryToAutoLogIn()
    }
    
    @objc func onLoginButtonClicked() {
        logIn()
    }
    
    private func logIn() {
        let login = loginTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        loginVM.logIn(withCredentials: (login, password))
    }
    
    @objc func onSignUpButtonClicked() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let signUpVC = storyboard.instantiateViewController(withIdentifier: "SignUpVC") as? SignUpVC else { return }
        self.navigationController?.pushViewController(signUpVC, animated: true)
    }
    
}

extension LoginVC: Hideable {
    
    func hide() {
        delegate?.reload()
        self.dismiss(animated: true, completion: nil)
    }
    
}

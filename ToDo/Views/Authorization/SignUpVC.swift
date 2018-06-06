//
//  SignUpVC.swift
//  ToDo
//
//  Created by Kryg Tomasz on 06.06.2018.
//  Copyright © 2018 Kryg Tomasz. All rights reserved.
//

import UIKit
import JGProgressHUD

protocol SignUpVCDelegate: class {
    func showIndicator(description: String)
    func hideIndicator(withSuccess success: Bool, description: String, completion: EmptyCompletion?)
    func hideVC()
}

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
    
    lazy var hud = JGProgressHUD(style: .dark)
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


//MARK: SignUpVCDelegate
extension SignUpVC: SignUpVCDelegate {
    
    func showIndicator(description: String) {
        hud.textLabel.text = description
        hud.show(in: self.view)
    }
    
    func hideIndicator(withSuccess success: Bool, description: String, completion: EmptyCompletion? = nil) {
        if success {
            self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        }
        self.hud.dismiss()
    }
    
    func hideVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
}

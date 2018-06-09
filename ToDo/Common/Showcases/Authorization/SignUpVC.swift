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

    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = "Rejestracja"
        }
    }
    @IBOutlet weak var loginTextField: UITextField! {
        didSet {
            loginTextField.placeholder = "Email"
            loginTextField.keyboardType = .emailAddress
            loginTextField.delegate = self
        }
    }
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            passwordTextField.placeholder = "Hasło"
            passwordTextField.delegate = self

        }
    }
    @IBOutlet weak var confirmPasswordTextField: UITextField! {
        didSet {
            confirmPasswordTextField.placeholder = "Powtórz hasło"
            confirmPasswordTextField.delegate = self

        }
    }
    @IBOutlet weak var usernameTextField: UITextField! {
        didSet {
            usernameTextField.placeholder = "Nazwa użytkownika"
            usernameTextField.delegate = self

        }
    }
    @IBOutlet weak var signUpButton: UIButton! {
        didSet {
            signUpButton.setTitle("Zarejestruj", for: .normal)
            signUpButton.addTarget(self, action: #selector(onSignUpButtonClicked), for: .touchUpInside)
            signUpButton.backgroundColor = UIColor.cardColor
            signUpButton.layer.cornerRadius = GlobalValues.SMALL_CORNER_RADIUS
        }
    }
    @IBOutlet weak var backButton: UIButton! {
        didSet {
            backButton.setTitle("Mam już konto", for: .normal)
            backButton.addTarget(self, action: #selector(onBackButtonClicked), for: .touchUpInside)
        }
    }
    
    lazy var hud = JGProgressHUD(style: .dark)
    var signUpVM: SignUpVM = SignUpVMImpl()
    
    var keyboardWillShow: (() -> ())?
    var keyboardWillHide: (() -> ())?
    
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
    
    @objc func onBackButtonClicked() {
        self.navigationController?.popViewController(animated: true)
    }

}

//MARK: Constructor
extension SignUpVC {
    static func getInstance() -> SignUpVC? {
        let viewController = SignUpVC(nibName: "SignUpVC", bundle: Bundle(for: SignUpVC.self))
        _ = viewController.view
        return viewController
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

//MARK: Keyboard handling
extension SignUpVC: ShowcaseWithKeyboard {
    func assignShowKeyboardFunction(function: @escaping () -> Void) {
        keyboardWillShow = function
    }
    
    func assignHideKeyboardFunction(function: @escaping () -> Void) {
        keyboardWillHide = function
    }
}

//MARK: UITextField Delegate
extension SignUpVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        keyboardWillShow?()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        keyboardWillHide?()
    }
}

//
//  LoginShowcaseVC.swift
//  ToDo
//
//  Created by Kryg Tomasz on 08.06.2018.
//  Copyright © 2018 Kryg Tomasz. All rights reserved.
//

import UIKit
import JGProgressHUD

protocol LoginShowcaseViewControllerDelegate: class {
    func loginShowcaseCompletion()
}

protocol LoginVCDelegate: class {
    func showIndicator(description: String)
    func hideIndicator(withSuccess success: Bool, description: String, completion: EmptyCompletion?)
    func hideVC()
}

extension LoginShowcaseVC: DismissableShowcase {
    func assignDismissClosure(closure: @escaping (@escaping onHideCompletionBlock) -> Void) {
        closeView = closure
    }
}

extension LoginShowcaseVC: ShowcaseWithKeyboard {
    func assignShowKeyboardFunction(function: @escaping () -> Void) {
        keyboardWillShow = function
    }
    
    func assignHideKeyboardFunction(function: @escaping () -> Void) {
        keyboardWillHide = function
    }
}

class LoginShowcaseVC: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = "Logowanie"
        }
    }
    @IBOutlet weak var loginTextField: UITextField! {
        didSet {
            loginTextField.placeholder = "Email"
            loginTextField.delegate = self
        }
    }
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            passwordTextField.placeholder = "Hasło"
            passwordTextField.delegate = self
        }
    }
    @IBOutlet weak var loginButton: UIButton! {
        didSet {
            loginButton.setTitle("Zaloguj", for: .normal)
            loginButton.addTarget(self, action: #selector(onLoginButtonClicked), for: .touchUpInside)
            loginButton.backgroundColor = UIColor.cardColor
            loginButton.layer.cornerRadius = GlobalValues.SMALL_CORNER_RADIUS
        }
    }
    @IBOutlet weak var signupButton: UIButton! {
        didSet {
            signupButton.setTitle("Utwórz konto", for: .normal)
            signupButton.addTarget(self, action: #selector(onSignupButtonClicked), for: .touchUpInside)
            signupButton.backgroundColor = UIColor.cardColor
            signupButton.layer.cornerRadius = GlobalValues.SMALL_CORNER_RADIUS

        }
    }
    
    let hud = JGProgressHUD(style: .dark)
    
    weak var delegate: LoginShowcaseViewControllerDelegate?
//        didSet {
//            guard let model = delegate?.getModel() else { return }
//        }
//    }
    var loginVM: LoginVM = LoginVMImpl()
    
    var closeView: ((_ onHidden: @escaping onHideCompletionBlock) -> ())?
    var keyboardWillShow: (() -> ())?
    var keyboardWillHide: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginVM.delegate = self
    }
    
    @objc func onLoginButtonClicked() {
        logIn()
    }
    
    private func logIn() {
        let login = loginTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        loginVM.logIn(withCredentials: (login, password))
    }
    
    @objc func onSignupButtonClicked() {
        guard
            let signUpVC = SignUpVC.getInstance(),
            let showKeyboard = keyboardWillShow,
            let hideKeyboard = keyboardWillHide
        else { return }
        signUpVC.assignShowKeyboardFunction(function: showKeyboard)
        signUpVC.assignHideKeyboardFunction(function: hideKeyboard)
        self.navigationController?.pushViewController(signUpVC, animated: true)
    }

}

//MARK: LoginVCDelegate
extension LoginShowcaseVC: LoginVCDelegate {
    
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
        self.dismiss(animated: true, completion: nil)
        delegate?.loginShowcaseCompletion()
    }
    
}

//MARK: Constructor
extension LoginShowcaseVC {
    static func getInstance() -> LoginShowcaseVC? {
        let viewController = LoginShowcaseVC(nibName: "LoginShowcaseVC", bundle: Bundle(for: LoginShowcaseVC.self))
        _ = viewController.view
        return viewController
    }
}

//MARK: UITextField Delegate
extension LoginShowcaseVC: UITextFieldDelegate {
    
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

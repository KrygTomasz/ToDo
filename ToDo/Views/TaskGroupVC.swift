//
//  MainTasksVC.swift
//  ToDo
//
//  Created by Kryg Tomasz on 09.06.2018.
//  Copyright © 2018 Kryg Tomasz. All rights reserved.
//

import UIKit
import JGProgressHUD

class TaskGroupVC: UIViewController {
    
    var groupTaskVM: GroupTaskVM!
    lazy var addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(goToTasks))
    lazy var logoutBarButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(onLogoutClicked))
    let hud = JGProgressHUD(style: .dark)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groupTaskVM = GroupTaskVMImpl()
        ShowcaseManager.instance.set(presentingViewController: self)
        tryToPresentLoginScreen()
        prepareNavigationBar()
    }
    
    private func prepareNavigationBar() {
        self.navigationItem.title = "Grupy zadań"
        self.navigationItem.rightBarButtonItem = addBarButton
        self.navigationItem.leftBarButtonItem = logoutBarButton
        self.navigationController?.navigationBar.barTintColor = UIColor.cardColor
    }
    
    @objc func goToTasks() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tasksVC = storyboard.instantiateViewController(withIdentifier: "TasksVC")
        self.navigationController?.pushViewController(tasksVC, animated: true)
    }
    
    @objc func onLogoutClicked() {
        showLogoutAlert()
    }
    
    private func showLogoutAlert() {
        let logoutAlert = getLogoutAlert()
        self.present(logoutAlert, animated: true, completion: nil)
    }
    
    private func getLogoutAlert() -> UIAlertController {
        let alert = UIAlertController(title: "Czy na pewno chcesz się wylogować?", message: "", preferredStyle: .alert)
        let logoutAction = UIAlertAction(title: "Wyloguj", style: .default) { action in
        self.groupTaskVM.logout(completion: self.presentLoginScreen)
        }
        let cancelAction = UIAlertAction(title: "Anuluj", style: .default)
        alert.addAction(cancelAction)
        alert.addAction(logoutAction)
        return alert
    }

}

//MARK: Authorization showcase
extension TaskGroupVC {
    
    private func tryToPresentLoginScreen() {
        presentLoginScreen()
    }
    
    private func getLoginShowcaseModel() -> ShowcaseModel? {
        guard let loginVC = LoginShowcaseViewController.getInstance() else { return nil }
        loginVC.delegate = self
        let loginShowcaseModel = ShowcaseModel(with: loginVC, canBeShownFunction: checkLoginShowcaseConditions, canBeHide: true)
        return loginShowcaseModel
    }
    
    private func checkLoginShowcaseConditions() -> Bool {
        return true
    }
    
    private func presentLoginScreen() {
        ShowcaseManager.instance.show(using: getLoginShowcaseModel())
    }
    
}

extension TaskGroupVC: LoginShowcaseViewControllerDelegate {
    
    func loginShowcaseCompletion() {
//        reload()
    }
    
}

//
//  TasksViewController.swift
//  ToDo
//
//  Created by Kryg Tomasz on 05.06.2018.
//  Copyright © 2018 Kryg Tomasz. All rights reserved.
//

import UIKit
import JGProgressHUD

protocol ReloadViewDelegate: class {
    func reload()
}

class TasksViewController: UIViewController {
    
    @IBOutlet weak var backgroundImageView: UIImageView! {
        didSet {
            backgroundImageView.image = #imageLiteral(resourceName: "backgroundImage")
        }
    }
    @IBOutlet weak var tasksTableView: UITableView! {
        didSet {
            let taskCellNib = UINib(nibName: "TaskTVCell", bundle: nil)
            tasksTableView.register(taskCellNib, forCellReuseIdentifier: "TaskTVCell")
            tasksTableView.delegate = self
            tasksTableView.dataSource = self
            tasksTableView.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
        }
    }
    
    lazy var addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onAddClicked))
    lazy var logoutBarButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(onLogoutClicked))
    let hud = JGProgressHUD(style: .dark)
    var taskVM: TasksVM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskVM = TasksVMImpl()
        tryToPresentLoginScreen()
        prepareNavigationBar()
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.isTranslucent = true
//    }
    
    private func tryToPresentLoginScreen() {
        presentLoginScreen(animated: false)
    }
    
    private func presentLoginScreen(animated: Bool = true) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC else { return }
        loginVC.delegate = self
        let loginNavVC = UINavigationController(rootViewController: loginVC)
        self.present(loginNavVC, animated: animated, completion: nil)
    }
    
    private func presentLoginScreenAnimated() {
        presentLoginScreen()
    }
    
    private func prepareNavigationBar() {
        self.navigationItem.title = "Lista zadań"
        self.navigationItem.rightBarButtonItem = addBarButton
        self.navigationItem.leftBarButtonItem = logoutBarButton
        self.navigationController?.navigationBar.barTintColor = UIColor.cardColor
    }
    
    @objc func onAddClicked() {
        showAddTaskAlert()
    }
    
    private func showAddTaskAlert() {
        let addTaskAlert = getAddTaskAlert()
        self.present(addTaskAlert, animated: true, completion: nil)
    }
    
    private func getAddTaskAlert() -> UIAlertController {
        let alert = UIAlertController(title: "Dodaj zadanie", message: "", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Dodaj", style: .default) { action in
            guard
                let title = alert.textFields?.first?.text,
                !title.isEmpty
            else { return }
            self.addTask(withTitle: title)
        }
        let cancelAction = UIAlertAction(title: "Anuluj", style: .default)
        alert.addTextField()
        alert.addAction(cancelAction)
        alert.addAction(addAction)
        return alert
    }
    
    private func addTask(withTitle title: String) {
        taskVM.addTask(withTitle: title)
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
            self.taskVM.logout(completion: self.presentLoginScreenAnimated)
        }
        let cancelAction = UIAlertAction(title: "Anuluj", style: .default)
        alert.addAction(cancelAction)
        alert.addAction(logoutAction)
        return alert
    }

}

//MARK: UITableView Delegate and DataSource
extension TasksViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tasksTableView.dequeueReusableCell(withIdentifier: "TaskTVCell", for: indexPath) as? TaskTVCell else { return UITableViewCell() }
        let index = indexPath.row
        guard let taskVM = taskVM.getTaskVM(byIndex: index) else { return UITableViewCell() }
        cell.prepare(using: taskVM)
        return cell
    }
    
    func numberOfSections(in tableView: UICollectionView) -> Int {
        return taskVM.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskVM.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let index = indexPath.row
            let task = taskVM.getTaskVM(byIndex: index)?.task
            task?.ref?.removeValue()
        }
    }
    
}

//MARK: Indicators
extension TasksViewController {
    
    private func showIndicator() {
        hud.textLabel.text = "Pobieranie listy zadań..."
        hud.show(in: self.view)
    }
    
    private func hideIndicator() {
        UIView.animate(withDuration: 0.3) {
            self.hud.textLabel.text = "Pobrano"
            self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
            self.hud.dismiss(afterDelay: 1.0, animated: true)
        }
    }
    
    private func reloadCollectionView() {
        tasksTableView.reloadData()
//        tasksTableView.reloadSections([0], with: .none)
    }
    
}

//MARK: ReloadViewDelegate
extension TasksViewController: ReloadViewDelegate {
    
    func reload() {
        showIndicator()
        taskVM.prepare() {
            self.reloadCollectionView()
            self.hideIndicator()
        }
    }
    
}

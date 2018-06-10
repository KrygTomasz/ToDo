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
    
    @IBOutlet weak var taskGroupsCollectionView: UICollectionView! {
        didSet {
            taskGroupsCollectionView.contentInset = UIEdgeInsetsMake(4, 0, 4, 0)
            let taskGroupCellNib = UINib(nibName: "TaskGroupCVCell", bundle: nil)
            taskGroupsCollectionView.register(taskGroupCellNib, forCellWithReuseIdentifier: "TaskGroupCVCell")
            taskGroupsCollectionView.delegate = self
            taskGroupsCollectionView.dataSource = self
        }
    }
    var taskGroupsVM: TaskGroupsVM!
    lazy var addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onAddTaskGroupClicked))
    lazy var logoutBarButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(onLogoutClicked))
    let hud = JGProgressHUD(style: .dark)
    
    private weak var tasksVCDelegate: TasksVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskGroupsVM = TaskGroupsVMImpl()
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
    
    func goToTasks(using taskGroupVM: TaskGroupVM) {
        let tasksVC = TasksViewController.getInstance()
        tasksVC.taskGroupVM = taskGroupVM
        tasksVCDelegate = tasksVC
        self.navigationController?.pushViewController(tasksVC, animated: true)
    }
    
    @objc func onAddTaskGroupClicked() {
        showAddTaskGroupAlert()
    }
    
    private func showAddTaskGroupAlert() {
        let addTaskGroupAlert = getAddTaskGroupAlert()
        self.present(addTaskGroupAlert, animated: true, completion: nil)
    }
    
    private func getAddTaskGroupAlert() -> UIAlertController {
        let alert = UIAlertController(title: "Dodaj grupę zadań", message: "", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Dodaj", style: .default) { action in
            guard
                let title = alert.textFields?.first?.text,
                !title.isEmpty
                else { return }
            self.addTaskGroup(withTitle: title)
        }
        let cancelAction = UIAlertAction(title: "Anuluj", style: .default)
        alert.addTextField()
        alert.addAction(cancelAction)
        alert.addAction(addAction)
        return alert
    }
    
    private func addTaskGroup(withTitle title: String) {
        taskGroupsVM.addTaskGroup(withTitle: title)
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
            self.taskGroupsVM.logout(completion: self.presentLoginScreen)
        }
        let cancelAction = UIAlertAction(title: "Anuluj", style: .default)
        alert.addAction(cancelAction)
        alert.addAction(logoutAction)
        return alert
    }
    
    func reloadView() {
        showIndicator()
        taskGroupsVM.prepare() {
            self.reloadCollectionView()
            self.tasksVCDelegate?.reloadTasks()
            self.hideIndicator()
        }
    }

}

//MARK: Indicators
extension TaskGroupVC {
    
    private func showIndicator() {
        hud.textLabel.text = "Pobieranie grup zadań..."
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
        taskGroupsCollectionView.reloadData()
        //        tasksTableView.reloadSections([0], with: .none)
    }
    
}

//MARK: UICollectionView delegates
extension TaskGroupVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = indexPath.row
        guard
            let cell = taskGroupsCollectionView.dequeueReusableCell(withReuseIdentifier: "TaskGroupCVCell", for: indexPath) as? TaskGroupCVCell,
            let taskGroupVM = taskGroupsVM.getTaskGroupVM(byIndex: index)
        else { return UICollectionViewCell() }
        cell.prepare(using: taskGroupVM)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row
        let taskGroupVM = taskGroupsVM.getTaskGroupVM(byIndex: index)
        goToTasks(using: taskGroupVM!)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return taskGroupsVM.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return taskGroupsVM.numberOfItems()
    }
    
}

extension TaskGroupVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = taskGroupsCollectionView.frame.width / 2
        let height = taskGroupsCollectionView.frame.height / 2.1
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
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
        reloadView()
    }
    
}

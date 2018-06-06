//
//  TasksViewController.swift
//  ToDo
//
//  Created by Kryg Tomasz on 05.06.2018.
//  Copyright © 2018 Kryg Tomasz. All rights reserved.
//

import UIKit

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
    
    @IBOutlet weak var indicator: UIActivityIndicatorView! {
        didSet {
            indicator.color = UIColor.lightGray
        }
    }
    
    lazy var addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onAddClicked))
    var taskVM: TasksVM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskVM = TasksVMImpl()
        tryToPresentLoginScreen()
        self.navigationItem.title = "Lista zadań"
        self.navigationItem.rightBarButtonItem = addBarButton
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.barTintColor = UIColor.cardColor
    }
    
    func tryToPresentLoginScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC else { return }
        loginVC.delegate = self
        let loginNavVC = UINavigationController(rootViewController: loginVC)
        self.present(loginNavVC, animated: false, completion: nil)
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

}

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

extension TasksViewController {
    
    func showIndicator() {
        indicator.isHidden = false
        indicator.startAnimating()
    }
    
    func hideIndicator() {
        indicator.stopAnimating()
        indicator.isHidden = true
    }
    
    func reloadCollectionView() {
        tasksTableView.reloadData()
//        tasksTableView.reloadSections([0], with: .none)
    }
    
}

extension TasksViewController: ReloadViewDelegate {
    
    func reload() {
        showIndicator()
        taskVM.prepare() {
            self.reloadCollectionView()
            self.hideIndicator()
        }
    }
    
}

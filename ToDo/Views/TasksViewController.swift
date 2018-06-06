//
//  TasksViewController.swift
//  ToDo
//
//  Created by Kryg Tomasz on 05.06.2018.
//  Copyright © 2018 Kryg Tomasz. All rights reserved.
//

import UIKit
import Firebase

protocol TasksVCDelegate: class {
    func showIndicator()
    func hideIndicator()
    func reloadCollectionView()
}

class TasksViewController: UIViewController {
    
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
    var viewModel: TasksVM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = TasksVMImpl()
        viewModel.delegate = self
        self.navigationItem.title = "Lista zadań"
        self.navigationItem.rightBarButtonItem = addBarButton
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
        viewModel.addTask(withTitle: title)
    }

}

extension TasksViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tasksTableView.dequeueReusableCell(withIdentifier: "TaskTVCell", for: indexPath) as? TaskTVCell else { return UITableViewCell() }
        let index = indexPath.row
        guard let taskVM = viewModel.getTaskVM(byIndex: index) else { return UITableViewCell() }
        cell.prepare(using: taskVM)
        return cell
    }
    
    func numberOfSections(in tableView: UICollectionView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
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
            let task = viewModel.getTaskVM(byIndex: index)?.task
            task?.ref?.removeValue()
        }
    }
    
}

extension TasksViewController: TasksVCDelegate {
    
    func showIndicator() {
        indicator.isHidden = false
        indicator.startAnimating()
    }
    
    func hideIndicator() {
        indicator.stopAnimating()
        indicator.isHidden = true
    }
    
    func reloadCollectionView() {
//        tasksTableView.beginUpdates()
        tasksTableView.reloadData()
//        tasksTableView.endUpdates()
//        tasksTableView.reloadSections([0], with: .none)
        
    }
    
}

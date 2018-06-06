//
//  TaskTVCell.swift
//  ToDo
//
//  Created by Kryg Tomasz on 06.06.2018.
//  Copyright © 2018 Kryg Tomasz. All rights reserved.
//

import UIKit

class TaskTVCell: UITableViewCell {

    @IBOutlet weak var container: UIView! {
        didSet {
            container.layer.cornerRadius = 5.0
            container.layer.borderWidth = 1.0
            container.layer.borderColor = UIColor.lightGray.cgColor
            container.backgroundColor = UIColor.cardColor
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onContainerTap))
            container.addGestureRecognizer(tapGesture)
            container.isUserInteractionEnabled = true
        }
    }
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.textColor = UIColor.black
        }
    }
    @IBOutlet weak var separatorView: UIView! {
        didSet {
            separatorView.backgroundColor = UIColor.lightGray
        }
    }
    @IBOutlet weak var addedByUserLabel: UILabel! {
        didSet {
            addedByUserLabel.textColor = UIColor.black
        }
    }
    
    var taskVM: TaskVM! {
        didSet {
            titleLabel.text = taskVM.title
            addedByUserLabel.text = taskVM.addedByUser
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    
    func prepare(using taskVM: TaskVM) {
        self.taskVM = taskVM
    }
    
    @objc func onContainerTap() {
        taskVM.expanded = !taskVM.expanded
//        if taskVM.expanded {
//            titleLabel.numberOfLines = 0
//        } else {
//            titleLabel.numberOfLines = 2
//        }
    }
    
}

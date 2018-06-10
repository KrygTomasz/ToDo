//
//  TaskGroupCVCell.swift
//  ToDo
//
//  Created by Kryg Tomasz on 09.06.2018.
//  Copyright © 2018 Kryg Tomasz. All rights reserved.
//

import UIKit

class TaskGroupCVCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.layer.cornerRadius = GlobalValues.MEDIUM_CORNER_RADIUS
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
    
    var taskGroupVM: TaskGroupVM! {
        didSet {
            titleLabel.text = taskGroupVM.title
            addedByUserLabel.text = taskGroupVM.addedByUser
            containerView.backgroundColor = UIColor(hex: taskGroupVM.colorHex)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func prepare(using taskGroupVM: TaskGroupVM) {
        self.taskGroupVM = taskGroupVM
    }

}

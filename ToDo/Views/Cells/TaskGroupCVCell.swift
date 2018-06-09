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
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}

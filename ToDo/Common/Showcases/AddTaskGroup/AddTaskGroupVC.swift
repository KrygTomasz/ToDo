//
//  AddTaskGroupVC.swift
//  ToDo
//
//  Created by Kryg Tomasz on 12.06.2018.
//  Copyright © 2018 Kryg Tomasz. All rights reserved.
//

import UIKit

extension AddTaskGroupVC: DismissableShowcase {
    func assignDismissClosure(closure: @escaping (@escaping onHideCompletionBlock) -> Void) {
        
    }
}

extension AddTaskGroupVC: ShowcaseWithKeyboard {
    func assignShowKeyboardFunction(function: @escaping () -> Void) {
        keyboardWillShow = function
    }
    
    func assignHideKeyboardFunction(function: @escaping () -> Void) {
        keyboardWillHide = function
    }
}

class AddTaskGroupVC: UIViewController {

    var keyboardWillShow: (() -> ())?
    var keyboardWillHide: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

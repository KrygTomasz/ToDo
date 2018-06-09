//
//  LoginShowcaseModel.swift
//  ToDo
//
//  Created by Kryg Tomasz on 08.06.2018.
//  Copyright © 2018 Kryg Tomasz. All rights reserved.
//

import Foundation
import UIKit

class LoginShowcaseModel {
    
    var title: String?
    var loginPlaceholder: String?
    var passwordPlaceholder: String?
    var loginButtonText: String?
    var signupButtonText: String?
    var image: UIImage?
    
    init(title: String?, loginPlaceholder: String?, passwordPlaceholder: String?, loginButtonText: String?, signupButtonText: String?, image: UIImage?) {
        self.title = title
        self.loginPlaceholder = loginPlaceholder
        self.passwordPlaceholder = passwordPlaceholder
        self.loginButtonText = loginButtonText
        self.signupButtonText = signupButtonText
        self.image = image
    }
    
}

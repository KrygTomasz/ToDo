//
//  GroupTaskVMImpl.swift
//  ToDo
//
//  Created by Kryg Tomasz on 09.06.2018.
//  Copyright © 2018 Kryg Tomasz. All rights reserved.
//

import Foundation
import Firebase

class GroupTaskVMImpl: GroupTaskVM {
    
    func logout(completion: EmptyCompletion? = nil) {
        do {
            try Auth.auth().signOut()
            User.shared.reset()
            completion?()
        } catch {
            return
        }
    }
    
}

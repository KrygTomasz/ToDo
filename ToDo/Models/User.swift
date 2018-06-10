//
//  User.swift
//  ToDo
//
//  Created by Kryg Tomasz on 06.06.2018.
//  Copyright © 2018 Kryg Tomasz. All rights reserved.
//

import Foundation
import Firebase

final class User {
    
    static let shared = User()
    
    var email: String {
        get {
            let value = UserDefaults().string(forKey: GlobalValues.USER_LOGIN)
            return value ?? ""
        }
        set {
            UserDefaults().set(newValue, forKey: GlobalValues.USER_LOGIN)
        }
    }
    var username: String {
        get {
            let value = UserDefaults().string(forKey: GlobalValues.USER_NAME)
            return value ?? ""
        }
        set {
            UserDefaults().set(newValue, forKey: GlobalValues.USER_NAME)
        }
    }
    var password: String {
        get {
            let value = UserDefaults().string(forKey: GlobalValues.USER_PASSWORD)
            return value ?? ""
        }
        set {
            UserDefaults().set(newValue, forKey: GlobalValues.USER_PASSWORD)
        }
    }
    var id: String {
        get {
            var parsedId = email
            parsedId = parsedId.replacingOccurrences(of: ".", with: "")
            parsedId = parsedId.replacingOccurrences(of: "#", with: "")
            parsedId = parsedId.replacingOccurrences(of: "$", with: "")
            parsedId = parsedId.replacingOccurrences(of: "[", with: "")
            parsedId = parsedId.replacingOccurrences(of: "]", with: "")
            return parsedId
        }
    }
    var isLogged: Bool {
        get {
            let value = UserDefaults().string(forKey: GlobalValues.USER_LOGIN)
            let login = value ?? ""
            if login.isEmpty {
                return false
            } else {
                return true
            }
        }
    }
    
    private init() { }
    
    func update(email: String, password: String, username: String? = nil) {
        self.email = email
        self.password = password
        if let userNick = username {
            self.username = userNick
        }
    }
    
    func reset() {
        self.email = ""
        self.password = ""
        self.username = ""
    }
    
}

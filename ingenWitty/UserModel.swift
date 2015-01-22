//
//  UserModel.swift
//  ingenWitty
//
//  Created by cortanaOS on 1/21/15.
//  Copyright (c) 2015 cortanaOS. All rights reserved.
//

import Foundation

class UserModel: NSObject, Printable {
    let userId: String
    let firstName: String
    let lastName: String
    let email: String
    let username: String
    
    override var description: String {
        return "User Id: \(userId), First Name: \(firstName), Last Name: \(lastName), Email: \(email), Username: \(username)\n"
    }
    
    init(userId: String?, firstName: String?, lastName: String?, email: String?, username: String?) {
        self.userId = userId ?? ""
        self.firstName = firstName ?? ""
        self.lastName = lastName ?? ""
        self.email = email ?? ""
        self.username = username ?? ""
    }
}
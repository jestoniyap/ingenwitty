//
//  Model.swift
//  ingenWitty
//
//  Created by cortanaOS on 1/10/15.
//  Copyright (c) 2015 cortanaOS. All rights reserved.
//

import Foundation

class UserModel: NSObject, Printable {
    let email: String
    let username: String
    
    override var description: String {
        return "Email: \(email), Username: \(username)\n"
    }
    
    init(email: String?, username: String?) {
        self.email = email ?? ""
        self.username = username ?? ""
    }
}
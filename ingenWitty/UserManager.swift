//
//  UserManager.swift
//  ingenWitty
//
//  Created by cortanaOS on 1/12/15.
//  Copyright (c) 2015 cortanaOS. All rights reserved.
//

import Foundation

class UserManager {
    class func getUsersDataWithSuccess(success: ((usersData: NSData!) -> Void)){
        Client.getRequestFromURL(NSURL(string: UsersURL)!, completion:{(data, error) -> Void in
            if let urlData = data{
                success(usersData: urlData)
            }
        })
    }
}